
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o echo

FROM alpine:latest

COPY --from=builder /app/echo /echo


EXPOSE 8081

ENTRYPOINT ["/echo"]

CMD [ "./echo" ]
