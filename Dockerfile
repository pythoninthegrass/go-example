# syntax = docker/dockerfile:1.5

# build stage
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.20-alpine3.18 AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0
ENV GO111MODULE=on

WORKDIR /app

# cache the download before continuing
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY . .

# # test
# RUN CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
#     go test -v ./...

RUN go build -o app

# runner stage
FROM --platform=${BUILDPLATFORM:-linux/amd64} alpine:latest

LABEL org.opencontainers.image.source="${BASE_URL}/${GITHUB_REPO}"
LABEL org.opencontainers.image.description="Fly.io Go app"
LABEL org.opencontainers.image.licenses="Unlicense"

WORKDIR /app

COPY --from=build /app/app .

RUN adduser -D -h /home/nonroot nonroot

USER nonroot:nonroot

EXPOSE ${PORT:-8080}

CMD ["./app"]
