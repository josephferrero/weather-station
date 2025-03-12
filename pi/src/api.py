import requests
import config

def send_reading(data):
    headers = {"Content-Type": "apllication/json"}
    response = requests.post(config.API_URL + "/readings", json=data)
    print("Response:", response.json())