import requests
import config
import sensor

def send_reading(data):
    data = sensor.read_bme680()
    try:
        response = requests.post(config.API_URL + "/readings", json=data, timeout=1.5)
    except requests.Timeout:
        print("the request timed out")
        pass
    except requests.ConnectionError:
        print("there a was connection error")
        pass
    else:
        print(response)
        print("Response:", response.json())
        
