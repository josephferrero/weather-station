FROM python:3.9

WORKDIR /app
COPY src/ /app/
COPY requirements.txt /app/

RUN pip install -r requirements.txt

CMD ["python3", "main.py"]