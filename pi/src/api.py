import requests
import config
import sensor

def send_reading(data):
    data = sensor.read_bme680
    response = requests.post(config.API_URL + "/readings", json=data)
    print(response)
    print("Response:", response.json())