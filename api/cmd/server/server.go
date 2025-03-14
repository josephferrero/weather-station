package cmd

import (
	"fmt"
	"log"
	"net/http"

	"github.com/common-nighthawk/go-figure"
	"github.com/josephferrero/weather-station-api/config"
	"github.com/josephferrero/weather-station-api/database"
	"github.com/josephferrero/weather-station-api/internal/handlers"
)

func StartServer() {
	database.RunMigrations()

	myFigure := figure.NewFigure("Weather Station API", "", true)
	myFigure.Print()

	cfg := config.GetConfig()

	mux := http.NewServeMux()
	mux.HandleFunc("/readings", handlers.HandleWeatherReading())

	fmt.Printf("REST API running on port %v...\n", cfg.HTTPPort)
	log.Fatal(http.ListenAndServe(":"+cfg.HTTPPort, mux))
}
