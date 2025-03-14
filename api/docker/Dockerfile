FROM golang:1.24-alpine

RUN go install github.com/air-verse/air@latest

WORKDIR /tmp/

CMD ["air", "-c", ".air.toml"]