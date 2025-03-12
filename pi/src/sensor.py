import time
import board
import busio
import adafruit_bme680

# Initialize I2C
i2c = busio.I2C(board.SCL, board.SDA)

# ✅ Use `0x77` instead of `0x76`
sensor = adafruit_bme680.Adafruit_BME680_I2C(i2c, address=0x77)

# Configure sensor settings
sensor.sea_level_pressure = 1013.25  # Adjust based on your location

def read_bme680():
    """Reads data from BME680 and returns as a dictionary."""
    return {
        "temperature": sensor.temperature,
        "humidity": sensor.humidity,
        "pressure": sensor.pressure,
        "gas_resistance": sensor.gas
    }

if __name__ == "__main__":
    while True:
        data = read_bme680()
        print(f"🌡️ Temp: {data['temperature']:.2f}°C, 💧 Humidity: {data['humidity']:.2f}%, ⬆️ Pressure: {data['pressure']:.2f} hPa, 🔥 Gas: {data['gas_resistance']:.2f} Ohms")
        time.sleep(2)