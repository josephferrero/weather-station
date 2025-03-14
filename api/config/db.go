package config

import (
	"database/sql"
	"fmt"
	"sync"

	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/pgdialect"
	"github.com/uptrace/bun/driver/pgdriver"
	"github.com/uptrace/bun/schema"
)

var (
	pgOnce sync.Once
	bunDB  *bun.DB
)

func GetDB() *bun.DB {
	pgOnce.Do(func() {
		bunDB = NewDB()
	})
	return bunDB
}

func NewDB() *bun.DB {
	cfg := GetConfig()
	dsn := fmt.Sprintf("postgres://%s:%s@%s/%s?sslmode=disable", cfg.PGUser, cfg.PGPassword, cfg.PGHost, cfg.PGDatabase)
	schema.SetTableNameInflector(func(s string) string {
		return s
	})
	sqldb := sql.OpenDB(pgdriver.NewConnector(pgdriver.WithDSN(dsn)))
	return bun.NewDB(sqldb, pgdialect.New())
}
