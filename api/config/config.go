package config

import "os"

var cfg *config

type config struct {
	HTTPPort string

	// Postgres configs
	PGHost     string
	PGPort     string
	PGUser     string
	PGPassword string
	PGDatabase string
}

func GetConfig() *config {
	if cfg == nil {
		return newConfig()
	}
	return cfg
}

func newConfig() *config {
	return &config{
		HTTPPort:   os.Getenv("HTTP_PORT"),
		PGHost:     os.Getenv("PGHOST"),
		PGPort:     os.Getenv("PGPORT"),
		PGUser:     os.Getenv("PGUSER"),
		PGPassword: os.Getenv("PGPASSWORD"),
		PGDatabase: os.Getenv("PGDATABASE"),
	}
}
