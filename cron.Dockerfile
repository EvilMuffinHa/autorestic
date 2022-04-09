FROM golang:1.17-alpine as builder

WORKDIR /app
COPY go.* .
RUN go mod download
COPY . .
RUN go build

FROM alpine
RUN apk add --no-cache restic rclone bash openssh
COPY --from=builder /app/autorestic /usr/bin/autorestic
RUN echo '*/5  *  *  *  *    /usr/bin/autorestic --ci cron' > /etc/crontabs/root
CMD [ "crond", "-f" ]
