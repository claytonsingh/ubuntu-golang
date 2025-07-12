# syntax=docker/dockerfile:1

FROM riscv64/ubuntu:jammy

ENV GOPATH="/go" GOLANG_VERSION="1.22.4" GOTOOLCHAIN="local" GOROOT="/usr/local/go" PATH="/usr/local/go/bin:$PATH"

RUN apt update && \
apt install -y ca-certificates curl build-essential git && \
apt-get clean && \
(cd /usr/local && curl -sLo - https://go.dev/dl/go1.22.4.linux-riscv64.tar.gz | tar zxf -) && \
mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

WORKDIR /go
