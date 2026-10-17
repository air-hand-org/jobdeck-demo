# syntax=docker/dockerfile:1

FROM ghcr.io/jdx/mise:2026.10.4-debian AS build
WORKDIR /src
ENV GOPATH=/go \
    GOTOOLCHAIN=local \
    MISE_TRUSTED_CONFIG_PATHS=/src

COPY mise.toml ./
RUN mise install go

COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod,id=jobdeck-go-mod \
    --mount=type=cache,target=/root/.cache/go-build,id=jobdeck-go-build \
    mise exec go -- go mod download

COPY cmd ./cmd
COPY internal ./internal
RUN --mount=type=cache,target=/go/pkg/mod,id=jobdeck-go-mod \
    --mount=type=cache,target=/root/.cache/go-build,id=jobdeck-go-build \
    CGO_ENABLED=0 mise exec go -- go build -trimpath -ldflags='-s -w' -o /out/demo ./cmd/server

FROM gcr.io/distroless/base-debian12:nonroot
COPY --from=build /out/demo /demo
USER nonroot:nonroot
ENTRYPOINT ["/demo"]
