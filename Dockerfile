FROM golang:1.10-alpine AS deps

ARG GLIDE_VERSION="0.13.2"

ENV CGO_ENABLED="0" \
    GOPATH=/go

WORKDIR /go/src/github.com/aelsabbahy/goss

COPY . $PWD

RUN apk add --no-cache git make && \
    wget -O - "https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz" | tar xvz -C /tmp --strip-components=1 linux-amd64/glide && \
    install /tmp/glide -t /usr/local/bin -o root -g root -m 755

FROM deps AS builder

RUN glide install && \
    make build

FROM scratch

COPY --from=builder /go/src/github.com/aelsabbahy/goss/release/goss-linux-amd64 /goss

ENTRYPOINT ["/goss"]
