package main

import (
	"context"
	"fmt"
	"slices"

	"github.com/joshuarubin/go-sway"
	"github.com/spf13/cobra"
)

func init() {
	swayCmd.AddCommand(swaySwitchCmd)
	swaySwitchCmd.Flags().StringSlice("displays", []string{}, "list of displays")
	swaySwitchCmd.Flags().Int("offset", 0, "offset to shift focused workspace by")
}

var swayCmd = &cobra.Command{
	Use:   "sway",
	Short: "sway-related commands",
}

var swaySwitchCmd = &cobra.Command{
	Use:   "switch",
	Short: "switch to a workspace with offset and loop",
	RunE: func(cmd *cobra.Command, args []string) error {
		displays, err := cmd.Flags().GetStringSlice("displays")
		if err != nil {
			return err
		}
		offset, err := cmd.Flags().GetInt("offset")
		if err != nil {
			return err
		}
		if len(displays) == 0 {
			return fmt.Errorf("must specify at least 1 display with --displays")
		}

		swayClient, err := sway.New(context.Background())
		if err != nil {
			return err
		}
		err = SwitchWorkspaceOffset(swayClient, displays, offset)
		if err != nil {
			return err
		}

		return nil
	},
}

func SwitchWorkspaceOffset(client sway.Client, displays []string, offset int) error {
	target, err := GetWorkspaceOffset(client, displays, offset)
	if err != nil {
		return err
	}

	_, err = client.RunCommand(context.Background(), fmt.Sprintf("workspace %s", target.Name))
	if err != nil {
		return err
	}

	return nil
}

func GetWorkspaceOffset(client sway.Client, displays []string, offset int) (*sway.Workspace, error) {
	workspaces, err := Workspaces(client, displays)
	if err != nil {
		return nil, err
	}

	var focusedIndex int = -1
	for i, workspace := range workspaces {
		if workspace.Focused {
			focusedIndex = i
			break
		}
	}

	if focusedIndex == -1 {
		return nil, fmt.Errorf("no workspace is focused")
	}

	targetIndex := focusedIndex + offset
	if targetIndex < 0 {
		targetIndex += len(workspaces)
	}

	if targetIndex >= len(workspaces) {
		targetIndex -= len(workspaces)
	}

	res := workspaces[targetIndex]
	return &res, nil
}

func Workspaces(client sway.Client, displays []string) ([]sway.Workspace, error) {
	workspaces, err := client.GetWorkspaces(context.Background())
	if err != nil {
		return nil, err
	}

	workspacesInOrder := []sway.Workspace{}

	for _, display := range displays {
		for _, workspace := range workspaces {
			if workspace.Output == display {
				workspacesInOrder = append(workspacesInOrder, workspace)
			}
		}
	}

	if len(workspacesInOrder) != len(workspaces) {
		workspacesNotInDisplays := []sway.Workspace{}
		for _, workspace := range workspaces {
			if !slices.Contains(displays, workspace.Output) {
				workspacesNotInDisplays = append(workspacesNotInDisplays, workspace)
			}
		}
		return nil, fmt.Errorf(
			"smome workspaces are not part of the specified list of displays (%v): %v",
			displays,
			workspacesNotInDisplays,
		)
	}

	return workspacesInOrder, nil
}
