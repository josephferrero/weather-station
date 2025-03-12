package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

type WeatherReading struct {
	Timestamp     string  `json:"timestamp"`
	Temperature   float64 `json:"temperature"`
	Humidity      float64 `json:"humidity"`
	Pressure      float64 `json:"pressure"`
	GasResistance float64 `json:"gasResistance"`
}

var readings []WeatherReading

func SendReading(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid method", http.StatusBadRequest)
	}
	var reading WeatherReading
	if err := json.NewDecoder(r.Body).Decode(&reading); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
	}
	reading.Timestamp = time.Now().Format(time.RFC3339)
	readings = append(readings, reading)
	json.NewEncoder(w).Encode(map[string]any{"message": "Reading stored"})
}

func GetReadings(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Invalid method", http.StatusBadRequest)
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(readings)
}

func main() {
	http.HandleFunc("/readings", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			SendReading(w, r)
		} else if r.Method == http.MethodGet {
			GetReadings(w, r)
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})
	fmt.Println("REST API running on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
