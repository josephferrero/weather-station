import board
import busio
import adafruit_bme680

# Initialize I2C
i2c = busio.I2C(board.SCL, board.SDA)

# ✅ Use `0x77` instead of `0x76`
sensor = adafruit_bme680.Adafruit_BME680_I2C(i2c, address=0x77)


# Configure sensor settings
sensor.sea_level_pressure = 1013.25  # Adjust based on your location
sensor.set_gas_heater(320, 150)

def read_bme680():
    """Reads data from BME680 and returns as a dictionary."""
    return {
        "temperature": sensor.temperature,
        "humidity": sensor.humidity,
        "pressure": sensor.pressure,
        "gasResistance": sensor.gas,
        "alt": sensor.altitude,
        }