package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"os/user"
	"path"
	"strconv"

	"github.com/spf13/cobra"
)

const MIX_TRANSIENT_ID = 34877 // random const for notifications that are transient
const MIX_VALUE_FILENAME = ".j-ctl-mix-value"

func init() {
	mixerCmd.AddCommand(mixerGetCmd, mixerSetCmd, mixerIncCmd)
}

var mixerCmd = &cobra.Command{
	Use:   "mixer",
	Short: "two-loopback mix between media and chat",
}

var mixerGetCmd = &cobra.Command{
	Use:   "get",
	Short: "get the current volume levels",
	Run: func(cmd *cobra.Command, args []string) {
		res, err := getMix()
		if err != nil {
			cmd.PrintErrln(err)
			os.Exit(1)
		}
		cmd.Println(res)
	},
}

var mixerSetCmd = &cobra.Command{
	Use:   "set [value]",
	Short: "set the mixer to a new value between -50 and 50 inclusive",
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) != 1 {
			cmd.PrintErrln("expected 1 argument for value")
			os.Exit(1)
		}
		newMix, err := strconv.Atoi(args[0])
		if err != nil {
			cmd.PrintErrln(err)
			os.Exit(1)
		}
		res, err := setMix(newMix)
		if err != nil {
			cmd.PrintErrln(err)
			os.Exit(1)
		}
		cmd.PrintErrln(res)
	},
}

var mixerIncCmd = &cobra.Command{
	Use:   "inc [value]",
	Short: "increment/decrement mixer value by a number",
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) != 1 {
			cmd.PrintErrln("expected 1 argument for value")
			os.Exit(1)
		}
		incAmount, err := strconv.Atoi(args[0])
		if err != nil {
			cmd.PrintErrln(err)
			os.Exit(1)
		}
		mix, err := getMixValue()
		if err != nil {
			cmd.PrintErrln(err)
			os.Exit(1)
		}
		newMix := mix + incAmount
		newMix = min(50, newMix)
		newMix = max(-50, newMix)
		res, err := setMix(newMix)
		if err != nil {
			cmd.PrintErrln(err)
			os.Exit(1)
		}
		fmt.Fprint(os.Stdout, res)
	},
}

func getMix() (*mixInfo, error) {
	mix, err := getMixValue()
	if err != nil {
		return nil, err
	}

	mediaVolume, err := getPipewireVolumeForNode("loopback-media")
	if err != nil {
		return nil, err
	}
	chatVolume, err := getPipewireVolumeForNode("loopback-chat")
	if err != nil {
		return nil, err
	}

	return &mixInfo{
		mix: mix,
		volumes: volumes{
			mediaVolume: mediaVolume,
			chatVolume:  chatVolume,
		},
	}, nil
}

func setMix(mix int) (*mixInfo, error) {
	if mix < -50 || mix > 50 {
		return nil, fmt.Errorf("mix %d must be between -50 and 50", mix)
	}
	volumes := mixToVolumes(mix)
	err := setPipewireVolumeForNode("loopback-media", volumes.mediaVolume)
	if err != nil {
		return nil, err
	}
	err = setPipewireVolumeForNode("loopback-chat", volumes.chatVolume)
	if err != nil {
		return nil, err
	}
	err = setMixValue(mix)
	if err != nil {
		return nil, err
	}

	err = Notification{
		Title:     "Media / Chat Mix",
		Transient: true,
	}.
		WithHint(HintTransientId, MIX_TRANSIENT_ID).
		WithHint(HintProgressValue, mix+50).
		Send()

	if err != nil {
		fmt.Fprintln(os.Stderr, "error sending notif for mixer change:", err)
	}

	return getMix()
}

type mixInfo struct {
	volumes
	mix int
}

func (i mixInfo) String() string {
	return fmt.Sprintf("%d", i.mix)
}

func setMixValue(value int) error {
	usr, err := user.Current()
	if err != nil {
		return err
	}
	filePath := path.Join(usr.HomeDir, MIX_VALUE_FILENAME)
	err = os.WriteFile(filePath, []byte(strconv.Itoa(value)), 0644)
	if err != nil {
		return err
	}
	return nil
}

func getMixValue() (int, error) {
	usr, err := user.Current()
	if err != nil {
		return 0, err
	}
	filePath := path.Join(usr.HomeDir, MIX_VALUE_FILENAME)
	file, err := os.ReadFile(filePath)
	if errors.Is(err, fs.ErrNotExist) {
		fmt.Fprintln(os.Stderr, filePath, "does not exist yet! returning 0")
		return 0, nil
	} else if err != nil {
		return 0, err
	}
	level, err := strconv.Atoi(string(file))
	if err != nil {
		return 0, err
	}
	return level, nil
}

func getPipewireVolumeForNode(node string) (float32, error) {
	var nodeInfo []struct {
		Id      int `json:"id"`
		Version int `json:"version"`
		Info    struct {
			Params struct {
				Props []struct {
					Volume float32 `json:"volume"`
					Mute   bool    `json:"mute"`
				}
			} `json:"params"`
		} `json:"info"`
	}
	cmd := exec.Command("pw-dump", "-N", node)
	stdout, err := cmd.Output()
	if err != nil {
		return 0.0, err
	}
	err = json.Unmarshal(stdout, &nodeInfo)
	if err != nil {
		return 0.0, err
	}
	return nodeInfo[0].Info.Params.Props[0].Volume, nil
}

func setPipewireVolumeForNode(node string, volume float32) error {
	fmt.Fprintln(os.Stderr, "setting", node, "to", volume)
	cmd := exec.Command(
		"pw-cli",
		"s",
		node,
		"Props",
		"{volume:"+fmt.Sprintf("%f", volume)+"}",
	)
	output, err := cmd.CombinedOutput()
	fmt.Fprintln(os.Stderr, string(output))
	if err != nil {
		return err
	}
	return nil
}

type volumes struct {
	mediaVolume float32
	chatVolume  float32
}

// mix is between -50 and 50
//
// | mix value   | media volume | chat volume |
// |-------------|--------------|-------------|
// | -50         | 1.0          | 0.0         |
// | -25         | 1.0          | 0.5         |
// | 0           | 1.0          | 1.0         |
// | 25          | 0.5          | 1.0         |
// | 50          | 0.0          | 1.0         |
//
// https://www.desmos.com/calculator/baiij9alri
//
// media(x) = { x <= 0: 1, (x / -50 ) + 1 }
// chat(x)  = { x >= 0: 1, (x /  50 ) + 1 }
func mixToVolumes(mix int) volumes {
	var (
		mediaVolume float32 = 1.0
		chatVolume  float32 = 1.0
	)

	if mix > 0 {
		mediaVolume = (float32(mix) / -50.0) + 1.0
	}
	if mix < 0 {
		chatVolume = (float32(mix) / 50.0) + 1.0
	}

	return volumes{
		mediaVolume: mediaVolume,
		chatVolume:  chatVolume,
	}
}
