# syntax = docker/dockerfile:1.5

# Build stage
FROM golang:1.20-alpine3.18 AS build
WORKDIR /app
COPY . .
RUN go build -o app

# Final stage
FROM alpine:latest
WORKDIR /app
COPY --from=build /app/app .
CMD ["./app"]
