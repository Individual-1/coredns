#!/bin/sh

# Build ARM64 coredns
MSYS_NO_PATHCONV=1 podman run --rm -it -v $PWD:/go/src/github.com/coredns/coredns -w /go/src/github.com/coredns/coredns golang:1.21 sh -c 'GOFLAGS="-buildvcs=false" make gen && GOFLAGS="-buildvcs=false" make coredns SYSTEM="GOOS=linux GOARCH=arm64" CHECK="" BUILTOPTS=""'
if [ "$?" -ne 0 ]; then
echo "Failed to build coredns"
exit 1
fi

#Build docker container image
podman build --no-cache --platform linux/arm64 --format docker -f Dockerfile -t coredns-blocklist .
if [ "$?" -ne 0 ]; then
echo "Failed to build image"
exit 1
fi

# Save built image
podman save -o coredns-blocklist.tar coredns-blocklist
if [ "$?" -ne 0 ]; then
echo "Failed to save image"
exit 1
fi