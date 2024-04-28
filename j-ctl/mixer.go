package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strconv"

	"github.com/spf13/cobra"
)

const MIX_LEVEL_VAR_NAME = "LOOPBACK_MIX_LEVEL"

func init() {
	mixerCmd.AddCommand(mixerGetCmd, mixerSetCmd)
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

func getMix() (*mixInfo, error) {
	mix := getMixValue()

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
	err = os.Setenv(MIX_LEVEL_VAR_NAME, fmt.Sprintf("%d", mix))
	if err != nil {
		return nil, err
	}
	return getMix()
}

type mixInfo struct {
	volumes
	mix int
}

func (i mixInfo) String() string {
	return fmt.Sprintf("mix: %d\nmedia: %f\nchat: %f", i.mix, i.mediaVolume, i.chatVolume)
}

func getMixValue() int {
	if levelRaw, ok := os.LookupEnv(MIX_LEVEL_VAR_NAME); ok && levelRaw != "" {
		level, err := strconv.Atoi(levelRaw)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			return 0
		}
		return level
	}
	return 0
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
