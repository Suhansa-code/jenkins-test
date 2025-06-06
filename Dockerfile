
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build echo

FROM alpine:latest

COPY --from=builder /app/echo /echo


EXPOSE 8080

ENTRYPOINT ["/echo"]

CMD [ "./echo" ]
