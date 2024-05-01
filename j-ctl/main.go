package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func init() {
	rootCmd.AddCommand(helloCmd, i3Cmd, mixerCmd, iconCmd, firefoxCmd, chromeCmd)
}

var rootCmd = &cobra.Command{
	Use:   "j-ctl",
	Short: "John's ctl - personal scripts and CLI glue for my desktop environment",
}

var helloCmd = &cobra.Command{
	Use:   "hello",
	Short: "says hello",
	Run: func(cmd *cobra.Command, args []string) {
		cmd.Println("Hello :)")
	},
}
