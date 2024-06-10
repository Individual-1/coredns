REM Build ARM64 coredns
podman run --rm -it -v %~dp0:/go/src/github.com/coredns/coredns -w /go/src/github.com/coredns/coredns golang:1.21 sh -c "GOARCH=amd64 GOOS=linux GOFLAGS=\""-buildvcs=false\"" make gen && GOARCH=amd64 GOOS=linux GOFLAGS=\""-buildvcs=false\"" make"
@if %errorlevel% neq 0 echo "Failed to build ARM64 coredns" && exit /b

REM Build docker container image
podman build --platform=arm64 -f Dockerfile -t coredns-blocklist .
@if %errorlevel% neq 0 echo "Failed to build docker image" && exit /b

REM Save built image
podman save -o coredns-blocklist.tar coredns-blocklist
@if %errorlevel% neq 0 echo "Failed to save image to tar" && exit /b