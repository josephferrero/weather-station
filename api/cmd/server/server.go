package cmd

import (
	"fmt"
	"log"
	"net/http"

	"github.com/common-nighthawk/go-figure"
	"github.com/josephferrero/weather-station-api/internal/handlers"
)

func StartServer() {
	myFigure := figure.NewFigure("Weather Station API", "", true)
	myFigure.Print()

	mux := http.NewServeMux()
	mux.HandleFunc("/readings", handlers.HandleWeatherReading())

	fmt.Println("REST API running on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", mux))
}
