# syntax=docker/dockerfile:1

# Use ARG to make the base image configurable for different architectures
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG GOARCH

# Set base image based on target architecture
FROM --platform=$TARGETPLATFORM debian:bullseye

# Set environment variables
ENV GOPATH="/go" \
    GOLANG_VERSION="1.24.5" \
    GOTOOLCHAIN="local" \
    GOROOT="/usr/local/go" \
    PATH="/usr/local/go/bin:$PATH"

# Install dependencies
RUN apt update && \
    apt install -y ca-certificates curl build-essential git && \
    apt-get clean

# Download and install Go based on GOARCH
curl -sLo - https://go.dev/dl/go${GOLANG_VERSION}.linux-${GOARCH}.tar.gz | tar zxf - -C /usr/local

# Set up Go workspace
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

WORKDIR /go
