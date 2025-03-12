import time
from api import send_reading

while True:
    data = {"temperature": 100.0}
    send_reading(data)
    time.sleep(10)