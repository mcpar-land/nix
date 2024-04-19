package main

import (
	"fmt"
	"slices"

	"github.com/spf13/cobra"
	"go.i3wm.org/i3"
)

func init() {
	i3Cmd.AddCommand(i3SwitchCmd)
	i3SwitchCmd.Flags().StringSlice("displays", []string{}, "list of displays")
	i3SwitchCmd.Flags().Int("offset", 0, "offset to shift focused workspace by")
}

var i3Cmd = &cobra.Command{
	Use:   "i3",
	Short: "i3-related commands",
}

var i3SwitchCmd = &cobra.Command{
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

		err = SwitchWorkspaceOffset(displays, offset)
		if err != nil {
			return err
		}

		return nil

	},
}

func SwitchWorkspaceOffset(displays []string, offset int) error {
	target, err := GetWorkspaceOffset(displays, offset)
	if err != nil {
		return err
	}

	_, err = i3.RunCommand(fmt.Sprintf("workspace %s", target.Name))
	if err != nil {
		return err
	}

	return nil
}

func GetWorkspaceOffset(displays []string, offset int) (*i3.Workspace, error) {
	workspaces, err := Workspaces(displays)
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

func Workspaces(displays []string) ([]i3.Workspace, error) {
	workspaces, err := i3.GetWorkspaces()
	if err != nil {
		return nil, err
	}

	workspacesInOrder := []i3.Workspace{}

	for _, display := range displays {
		for _, workspace := range workspaces {
			if workspace.Output == display {
				workspacesInOrder = append(workspacesInOrder, workspace)
			}
		}
	}

	if len(workspacesInOrder) != len(workspaces) {
		workspacesNotInDisplays := []i3.Workspace{}

		for _, workspace := range workspaces {
			if !slices.Contains(displays, workspace.Output) {
				workspacesNotInDisplays = append(workspacesNotInDisplays, workspace)
			}
		}

		return nil, fmt.Errorf(
			"some workspaces are not part of the specified list of displays (%v): %v",
			displays,
			workspacesNotInDisplays,
		)
	}

	return workspacesInOrder, nil
}
