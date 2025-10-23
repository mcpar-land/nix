package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

var weatherCmd = &cobra.Command{
	Use:                "weather",
	Short:              "get weather",
	DisableFlagParsing: true,
	Run: func(cmd *cobra.Command, args []string) {

		if len(args) != 1 {
			cmd.PrintErrln("requires location arg")
			os.Exit(1)
		}

		res := fetchWeather(args[0])

		rb, err := json.Marshal(res)
		if err != nil {
			panic(err)
		}
		os.Stdout.Write(rb)
	},
}

func fetchWeather(location string) weatherBarItemResponse {

	shortUrl := "https://v2d.wttr.in/" + location + "?format=%25C%20%25t"
	shortResp, err := http.Get(shortUrl)
	if err != nil {
		return weatherBarItemResponse{
			Text: fmt.Sprintf("err: %v", err),
		}
	}
	shortBody, err := io.ReadAll(shortResp.Body)
	if err != nil {
		return weatherBarItemResponse{
			Text: fmt.Sprintf("err: %v", err),
		}
	}
	short := string(shortBody)

	// longUrl := "https://wttr.in/" + location + "?ATd&format=v2"
	longUrl := "https://wttr.in/" + location + "?2QFATd"
	longResp, err := http.Get(longUrl)
	if err != nil {
		return weatherBarError(err)
	}
	longBody, err := io.ReadAll(longResp.Body)
	if err != nil {
		return weatherBarError(err)
	}
	long := string(longBody)
	long = strings.ReplaceAll(long, "\r\n", "\r")
	long = strings.ReplaceAll(long, "\n", "\r")

	return weatherBarItemResponse{
		Text:    short,
		Tooltip: long,
	}
}

func weatherBarError(err error) weatherBarItemResponse {
	return weatherBarItemResponse{
		Text:    "Weather error",
		Tooltip: fmt.Sprintf("%v", err),
		Class:   "error",
	}
}

type weatherBarItemResponse struct {
	Text    string `json:"text"`
	Tooltip string `json:"tooltip"`
	Class   string `json:"class"`
}
