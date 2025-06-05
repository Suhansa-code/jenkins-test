FROM int-nexus.mytaxi.lk:8082/base_images/build_alpine-3.20_go-1.23.5:latest AS builder
#FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ping

FROM alpine:latest

COPY --from=builder /app/ping /ping

RUN chmod +x /ping

EXPOSE 8080

ENTRYPOINT ["/ping"]
