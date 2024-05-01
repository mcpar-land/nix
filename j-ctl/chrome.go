package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path"

	"github.com/spf13/cobra"
)

func init() {
	chromeCmd.AddCommand(chromeListProfilesCmd, chromeGetProfileCmd)
}

var chromeCmd = &cobra.Command{
	Use:   "chrome",
	Short: "google chrome related commands",
}

var chromeListProfilesCmd = &cobra.Command{
	Use:   "list-profiles",
	Short: "list google chrome profiles",
	RunE: func(cmd *cobra.Command, args []string) error {
		profiles, err := GetChromeProfiles()
		if err != nil {
			return err
		}
		for _, profile := range profiles {
			fmt.Fprintln(os.Stdout, profile.Label)
		}
		return nil
	},
}

var chromeGetProfileCmd = &cobra.Command{
	Use:   "get-profile [LABEL]",
	Short: "gets the data directory for a profile with a given label",
	RunE: func(cmd *cobra.Command, args []string) error {

		if len(args) != 1 {
			return fmt.Errorf("expected 1 argument for profile label")
		}

		profiles, err := GetChromeProfiles()
		if err != nil {
			return err
		}

		for _, profile := range profiles {
			if profile.Label == args[0] {
				fmt.Fprintln(os.Stdout, profile.FolderName)
				return nil
			}
		}

		return fmt.Errorf("Profile with label '%s' not found (expected one of %v)", args[0], profiles)
	},
}

func GetChromeProfiles() ([]ChromeProfile, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, err
	}
	chromeDir := path.Join(homeDir, ".config/google-chrome")

	localStatePath := path.Join(chromeDir, "Local State")

	var localState struct {
		Profile struct {
			InfoCache map[string]struct {
				GaiaGivenName string `json:"gaia_given_name"`
				Name          string `json:"name"`
			} `json:"info_cache"`
			ProfilesOrder []string `json:"profiles_order"`
		} `json:"profile"`
	}

	localStateRaw, err := os.ReadFile(localStatePath)

	err = json.Unmarshal(localStateRaw, &localState)
	if err != nil {
		return nil, err
	}

	var profiles []ChromeProfile

	for _, profileName := range localState.Profile.ProfilesOrder {
		profile := localState.Profile.InfoCache[profileName]
		label := profile.GaiaGivenName
		if profile.GaiaGivenName != profile.Name {
			label = fmt.Sprintf("%s (%s)", profile.GaiaGivenName, profile.Name)
		}
		profiles = append(profiles, ChromeProfile{
			Label:      label,
			FolderName: profileName,
		})
	}

	return profiles, nil
}

type ChromeProfile struct {
	Label      string
	FolderName string
}
