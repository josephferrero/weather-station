FROM golang:1.24.1-alpine

WORKDIR /go/src/api

RUN apk update

COPY ./ /go/src/api

RUN go build -o ./bin/server