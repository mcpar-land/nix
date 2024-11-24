package main

import (
	"fmt"
	"os/exec"
	"strconv"
	"strings"

	"github.com/spf13/cobra"
)

var lightCmd = &cobra.Command{
	Use: "light",
	RunE: func(cmd *cobra.Command, args []string) error {
		return toggleLightLevel()
	},
}

func toggleLightLevel() error {
	light, err := getLightLevel()
	if err != nil {
		return err
	}
	if light == 100.0 {
		return setLightLevel(0.0)
	}
	return setLightLevel(100.0)
}

func setLightLevel(light float32) error {
	cmd := exec.Command("light", "-S", fmt.Sprint(light))
	_, err := cmd.CombinedOutput()
	if err != nil {
		return err
	}

	return nil
}

func getLightLevel() (float32, error) {
	cmd := exec.Command("light", "-G")
	output, err := cmd.CombinedOutput()
	if err != nil {
		return 0.0, err
	}
	o := strings.TrimSpace(string(output))
	brightness64, err := strconv.ParseFloat(o, 32)
	if err != nil {
		return 0.0, err
	}
	return float32(brightness64), nil
}
