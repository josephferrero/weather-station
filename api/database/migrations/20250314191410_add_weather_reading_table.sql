-- +goose Up
CREATE TABLE
    weather_reading (
        id SERIAL,
        timestamp VARCHAR,
        temperature DOUBLE PRECISION,
        humidity DOUBLE PRECISION,
        pressure DOUBLE PRECISION,
        gas_resistance DOUBLE PRECISION,
        altitude DOUBLE PRECISION
    );