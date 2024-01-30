# syntax=docker/dockerfile:experimental

FROM golang:1.21.6-alpine3.19 as dev
RUN apk add --no-cache git ca-certificates make
RUN adduser -D appuser
COPY . /src/
WORKDIR /src

ENV GO111MODULE=on
RUN rm -f lelastic
RUN CGO_ENABLED=0 GOOS=linux go build

FROM alpine:3.19
# Add Certificates into the image, for anything that does API calls
COPY --from=dev /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
# Add lelastic binary
COPY --from=dev /src/lelastic /
ENTRYPOINT ["/lelastic"]
