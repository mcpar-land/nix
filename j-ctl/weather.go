package main

import (
	"encoding/json"
	"fmt"
	"io"
	"math"
	"net/http"
	"os"
	"strconv"

	"github.com/spf13/cobra"
)

var weatherCmd = &cobra.Command{
	Use:                "weather",
	Short:              "get weather",
	DisableFlagParsing: true,
	Run: func(cmd *cobra.Command, args []string) {

		str, err := displayWeather(args)
		if err != nil {
			fmt.Fprint(os.Stderr, err)
			os.Exit(1)
		}

		fmt.Fprint(os.Stdout, str)
	},
}

func displayWeather(args []string) (string, error) {
	if len(args) != 2 {
		return "", fmt.Errorf("requires lat, long args")
	}

	lat, err := strconv.ParseFloat(args[0], 32)
	if err != nil {
		return "", fmt.Errorf("error parsing lat: %v", err)
	}
	long, err := strconv.ParseFloat(args[1], 32)
	if err != nil {
		return "", fmt.Errorf("error parsing long: %v", err)
	}

	data, err := fetchWeather(lat, long)
	if err != nil {
		return "", err
	}

	temp := int(math.Round(data.Temperature))

	return fmt.Sprintf("%d° %v", temp, weatherCodeHuman(data.Weather)), nil
}

func fetchWeather(lat float64, long float64) (*weatherData, error) {
	url := weatherUrl(lat, long)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var responseJson struct {
		Current weatherData `json:"current"`
	}

	err = json.Unmarshal(respBody, &responseJson)
	if err != nil {
		return nil, err
	}

	return &responseJson.Current, nil
}

// latitude=42.38874
// longitude=-71.12556
func weatherUrl(lat float64, long float64) string {
	return fmt.Sprintf(
		"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current=temperature_2m,weather_code&temperature_unit=fahrenheit",
		lat,
		long,
	)
}

type weatherData struct {
	Temperature float64 `json:"temperature_2m"`
	Weather     int     `json:"weather_code"`
}

func weatherCodeHuman(code int) string {
	switch code {
	case 0, 1:
		return "Clear"
	case 2, 3:
		return "Cloudy"
	case 45, 48:
		return "Fog"
	case 51, 53, 55:
		return "Drizzle"
	case 61, 63, 65:
		return "Rain"
	case 66, 67:
		return "Freezing Rain"
	case 71, 73, 75, 77:
		return "Snow"
	case 80, 81, 82:
		return "Rain Showers"
	case 85, 86:
		return "Snow Showers"
	case 95:
		return "Thunderstorm"
	case 96, 99:
		return "Hailstorm"
	default:
		return fmt.Sprintf("unknown code %d", code)
	}
}
