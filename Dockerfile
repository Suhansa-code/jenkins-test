
FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o echo ./echoHttp.go

FROM alpine:latest

COPY --from=builder /app/echo /echo


EXPOSE 8080

ENTRYPOINT ["/echo"]

CMD [ "./echo" ]
