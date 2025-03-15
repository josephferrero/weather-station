package models

import (
	"context"

	"github.com/josephferrero/weather-station-api/config"
)

type WeatherReading struct {
	ID            int64   `bun:",pk,autoincrement" json:"id"`
	Timestamp     string  `json:"timestamp"`
	Temperature   float64 `json:"temperature"`
	Humidity      float64 `json:"humidity"`
	Pressure      float64 `json:"pressure"`
	GasResistance float64 `json:"gasResistance"`
	Altitude      float64 `json:"altitude"`
}

func InsertWeatherReading(ctx context.Context, wr *WeatherReading) error {
	db := config.GetDB()

	if _, err := db.NewInsert().Model(wr).Exec(ctx); err != nil {
		return err
	}

	return nil
}

func ListWeatherReadings(ctx context.Context) ([]*WeatherReading, error) {
	db := config.GetDB()

	wrs := make([]*WeatherReading, 0)

	if err := db.NewSelect().Model(&wrs).Scan(ctx); err != nil {
		return nil, err
	}

	return wrs, nil
}
