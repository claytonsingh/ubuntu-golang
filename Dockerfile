# syntax=docker/dockerfile:1

# Use ARG to make the base image configurable for different architectures
ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Set base image based on target architecture
FROM --platform=$TARGETPLATFORM ubuntu:jammy

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

# Download and install Go based on architecture
RUN case "$TARGETPLATFORM" in \
        "linux/amd64") \
            curl -sLo - https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar zxf - -C /usr/local && \
            ;; \
        "linux/386") \
            curl -sLo - https://go.dev/dl/go${GOLANG_VERSION}.linux-386.tar.gz | tar zxf - -C /usr/local && \
            ;; \
        "linux/arm64") \
            curl -sLo - https://go.dev/dl/go${GOLANG_VERSION}.linux-arm64.tar.gz | tar zxf - -C /usr/local && \
            ;; \
        "linux/arm/v7") \
            curl -sLo - https://go.dev/dl/go${GOLANG_VERSION}.linux-armv7l.tar.gz | tar zxf - -C /usr/local && \
            ;; \
        "linux/arm/v6") \
            curl -sLo - https://go.dev/dl/go${GOLANG_VERSION}.linux-armv6l.tar.gz | tar zxf - -C /usr/local && \
            ;; \
        "linux/riscv64") \
            curl -sLo - https://go.dev/dl/go${GOLANG_VERSION}.linux-riscv64.tar.gz | tar zxf - -C /usr/local && \
            ;; \
        *) \
            echo "Unsupported platform: $TARGETPLATFORM" && exit 1 && \
            ;; \
    esac

# Set up Go workspace
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

WORKDIR /go
