REM This is broken because of quote escapes and CMD/Powershell being garbage
REM Build ARM64 coredns
podman run --rm -it -v %~dp0:/go/src/github.com/coredns/coredns -w /go/src/github.com/coredns/coredns golang:1.21 sh -c "GOFLAGS=^"-buildvcs=false^" make gen && GOFLAGS=^"-buildvcs=false^" make coredns SYSTEM=^"GOOS=linux GOARCH=arm64^" CHECK=^"^" BUILTOPTS=^"^""
@if %errorlevel% neq 0 echo "Failed to build ARM64 coredns" && exit /b

REM Build docker container image
podman build --no-cache --platform linux/arm64 --format docker -f Dockerfile -t coredns-blocklist .
@if %errorlevel% neq 0 echo "Failed to build image" && exit /b

REM Save built image
podman save -o coredns-blocklist.tar coredns-blocklist
@if %errorlevel% neq 0 echo "Failed to save image to tar" && exit /b