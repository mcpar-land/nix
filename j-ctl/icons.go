package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/spf13/cobra"
)

func init() {
	iconCmd.AddCommand(batteryCmd)
}

var iconCmd = &cobra.Command{
	Use:   "icon",
	Short: "icons for bar",
}

var batteryCmd = &cobra.Command{
	Use:   "battery",
	Short: "battery icon with percentage",
	Run: func(cmd *cobra.Command, args []string) {

		powerSupplyDir, err := os.ReadDir("/sys/class/power_supply")
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			return
		}

		var batName string
		for _, entry := range powerSupplyDir {
			if strings.Contains(entry.Name(), "BAT") {
				batName = entry.Name()
				break
			}
		}
		if batName == "" {
			fmt.Fprintln(os.Stderr, "no battery found")
			return
		}

		capacityRaw, err := os.ReadFile(fmt.Sprintf(
			"/sys/class/power_supply/%s/capacity",
			batName,
		))
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			return
		}

		statusRaw, err := os.ReadFile(fmt.Sprintf(
			"/sys/class/power_supply/%s/status",
			batName,
		))
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			return
		}

		status := string(statusRaw)
		status = strings.TrimSpace(status)
		status = strings.ToLower(status)
		isCharging := status == "charging"

		capacity, err := strconv.Atoi(strings.TrimSpace(string(capacityRaw)))
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			return
		}

		// 󱉞
		icons := "󰁺󰁻󰁼󰁽󰁾󰁿󰂀󰂁󰂂󰁹"
		iconIndex := min(9, capacity/10)
		icon := strings.Split(icons, "")[iconIndex]

		if isCharging {
			icon = "󰂄"
		}

		fmt.Fprintf(os.Stdout, "%s %d%%", icon, capacity)
	},
}
