package handlers

import (
	"encoding/json"
	"io"
	"net/http"
	"time"

	"github.com/josephferrero/weather-station-api/internal/logging"
)

type WeatherReading struct {
	Timestamp     string  `json:"timestamp"`
	Temperature   float64 `json:"temperature"`
	Humidity      float64 `json:"humidity"`
	Pressure      float64 `json:"pressure"`
	GasResistance int     `json:"gasResistance"`
	Alt           float64 `json:"alt"`
}

var readings []WeatherReading

func HandleWeatherReading() http.HandlerFunc {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		logger := logging.GetLogger(r.Context())
		bytes, err := io.ReadAll(r.Body)
		if err != nil {
			logger.Sugar().Error(err)
		}
		logger.Debug(string(bytes))
		if r.Method == http.MethodPost {
			logger.Info("Recieved a new sensor reading")
			var reading WeatherReading
			if err := json.NewDecoder(r.Body).Decode(&reading); err != nil {
				logger.Error(err.Error())
				http.Error(w, "Invalid input", http.StatusBadRequest)
			}
			reading.Timestamp = time.Now().Format(time.RFC3339)
			readings = append(readings, reading)
			w.WriteHeader(http.StatusCreated)
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(map[string]any{"message": "Reading stored"})
			return
		}
		if r.Method == http.MethodGet {
			logger.Info("Responding with sensor readings")
			if r.Method != http.MethodGet {
				http.Error(w, "Invalid method", http.StatusBadRequest)
			}
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(readings)
			return
		}
		http.Error(w, "Unsupported method", http.StatusMethodNotAllowed)
	})

}
