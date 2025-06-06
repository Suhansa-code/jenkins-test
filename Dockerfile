
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY . .

RUN go build -o echoHttp main.go

FROM alpine:latest

COPY --from=builder /app/ping /ping

RUN chmod +x /ping

EXPOSE 8081

ENTRYPOINT ["/ping"]
