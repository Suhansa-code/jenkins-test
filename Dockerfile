
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ping


FROM alpine:latest

COPY --from=builder /app/ping /ping

RUN chmod +x /ping

EXPOSE 8081

ENTRYPOINT ["/ping"]

CMD [ "./echoHttp" ]
