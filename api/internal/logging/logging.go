package logging

import (
	"context"

	"go.uber.org/zap"
)

type ctxKey struct{}

var defaultLogger *zap.Logger

func init() {
	logger, _ := zap.NewProduction()
	defaultLogger = logger
}

func NewLogger(pkg string) *zap.Logger {
	return defaultLogger.With(zap.String("package", pkg))
}

func WithLogger(ctx context.Context, pkg string) context.Context {
	logger := NewLogger(pkg)
	return context.WithValue(ctx, ctxKey{}, logger)
}

func GetLogger(ctx context.Context) *zap.Logger {
	if logger, ok := ctx.Value(ctxKey{}).(*zap.Logger); ok {
		return logger
	}
	return defaultLogger.With(zap.String("package", "default"))
}
