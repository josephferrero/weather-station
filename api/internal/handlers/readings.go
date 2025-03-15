package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/josephferrero/weather-station-api/internal/logging"
	"github.com/josephferrero/weather-station-api/internal/models"
)

func HandleWeatherReading() http.HandlerFunc {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		logger := logging.GetLogger(r.Context())
		if r.Method == http.MethodPost {
			logger.Info("Recieved a new sensor reading")
			var reading models.WeatherReading
			if err := json.NewDecoder(r.Body).Decode(&reading); err != nil {
				logger.Error(err.Error())
				http.Error(w, "Invalid input", http.StatusBadRequest)
			}
			reading.Timestamp = time.Now().Format(time.RFC3339)
			if err := models.InsertWeatherReading(r.Context(), &reading); err != nil {
				logger.Error(err.Error())
				http.Error(w, "failed to insert weather readings", http.StatusInternalServerError)
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
			json.NewEncoder(w).Encode(map[string]any{"message": "Reading stored"})
			return
		}
		if r.Method == http.MethodGet {
			logger.Info("Responding with sensor readings")
			if r.Method != http.MethodGet {
				http.Error(w, "Invalid method", http.StatusBadRequest)
			}
			readings, err := models.ListWeatherReadings(r.Context())
			if err != nil {
				logger.Error(err.Error())
				http.Error(w, "failed to get weather readings", http.StatusInternalServerError)
			}
			json.NewEncoder(w).Encode(readings)
			return
		}
		http.Error(w, "Unsupported method", http.StatusMethodNotAllowed)
	})
}
