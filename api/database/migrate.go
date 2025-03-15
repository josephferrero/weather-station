package database

import (
	"context"
	"embed"

	"github.com/josephferrero/weather-station-api/config"
	"github.com/josephferrero/weather-station-api/internal/logging"
	"github.com/pressly/goose/v3"
)

//go:embed migrations/*.sql
var migrations embed.FS

func RunMigrations() {
	logger := logging.GetLogger(context.Background())
	logger.Info("Running migrations...")

	db := config.GetDB()

	goose.SetBaseFS(migrations)

	if err := goose.Up(db.DB, "migrations"); err != nil {
		logger.Error(err.Error())
	}
}
