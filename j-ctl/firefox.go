package main

import (
	"cmp"
	"fmt"
	"os"
	"path"
	"slices"
	"strconv"
	"strings"

	"github.com/go-ini/ini"
	"github.com/spf13/cobra"
)

func init() {
	firefoxCmd.AddCommand(listProfilesCmd)
}

var firefoxCmd = &cobra.Command{
	Use:   "firefox",
	Short: "firefox-related commands",
}

var listProfilesCmd = &cobra.Command{
	Use:   "list-profiles",
	Short: "list all firefox profiles",
	RunE: func(cmd *cobra.Command, args []string) error {

		profiles, err := LoadFirefoxIni()
		if err != nil {
			return err
		}

		for _, profile := range profiles.Profiles {
			fmt.Fprintln(os.Stdout, profile.Name)
		}

		return nil
	},
}

func LoadFirefoxIni() (*FirefoxIni, error) {

	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, err
	}

	iniPath := path.Join(homeDir, ".mozilla/firefox/profiles.ini")

	cfg, err := ini.Load(iniPath)
	if err != nil {
		return nil, err
	}

	startWithLastProfile, err := cfg.Section("General").Key("StartWithLastProfile").Bool()
	if err != nil {
		return nil, err
	}

	var profiles []FirefoxIniProfile
	for _, section := range cfg.Sections() {
		if !strings.HasPrefix(section.Name(), "Profile") {
			continue
		}
		profile, err := parseIniProfile(section)
		if err != nil {
			return nil, err
		}
		if profile.Name == "default" {
			continue
		}
		profiles = append(profiles, *profile)
	}

	slices.SortFunc(profiles, func(a, b FirefoxIniProfile) int {
		return cmp.Compare(a.Index, b.Index)
	})

	return &FirefoxIni{
		StartWithLastProfile: startWithLastProfile,
		Profiles:             profiles,
	}, nil
}

type FirefoxIni struct {
	StartWithLastProfile bool
	Profiles             []FirefoxIniProfile
}

func parseIniProfile(section *ini.Section) (*FirefoxIniProfile, error) {

	index, err := strconv.Atoi(strings.TrimPrefix(section.Name(), "Profile"))
	if err != nil {
		return nil, err
	}

	return &FirefoxIniProfile{
		Index:      index,
		Default:    section.Key("Default").MustBool(false),
		IsRelative: section.Key("IsRelative").MustBool(false),
		Name:       section.Key("Name").String(),
		Path:       section.Key("Path").String(),
	}, nil
}

type FirefoxIniProfile struct {
	Index      int
	Default    bool
	IsRelative bool
	Name       string
	Path       string
}
