import time
from api import send_reading

while True:
    send_reading()
    time.sleep(10)