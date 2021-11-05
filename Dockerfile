FROM golang:1.17-alpine AS build

RUN mkdir /app
WORKDIR /app
COPY . /app/
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags '-extldflags "-static"' -o /app/flagger-k6-webhook cmd/main.go

FROM alpine:3.14

COPY --from=build /app/flagger-k6-webhook /usr/bin/flagger-k6-webhook
COPY --from=loadimpact/k6 /usr/bin/k6 /usr/bin/k6

ENTRYPOINT /usr/bin/flagger-k6-webhook