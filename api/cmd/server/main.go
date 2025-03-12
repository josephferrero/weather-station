package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/common-nighthawk/go-figure"
	"github.com/josephferrero/weather-station-api/internal/handlers"
)

func main() {
	mux := http.NewServeMux()

	myFigure := figure.NewFigure("Weather API", "", true)
	myFigure.Print()

	mux.HandleFunc("/readings", handlers.HandleWeatherReading())

	fmt.Println("REST API running on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", mux))
}
