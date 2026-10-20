# jobdeck-demo

## Container licenses

The published image includes this project's MIT license at `/LICENSE` and
third-party Go dependency licenses and notices at `/third_party`. Attribution
files already provided by the distroless base image are preserved.

`make build` regenerates the versioned documents under
`third_party/licenses/linux-amd64`; CI's existing `make check-clean` rejects
stale or untracked output. Run `make licenses` after changing dependencies or
the collector. The collector is pinned in `mise.toml`, as in gh-app.

Collection targets `./cmd/server` with `CGO_ENABLED=0` for `linux/amd64`, matching
the platform currently built and published by the image workflow. Add matching
collection and image-copy paths before introducing other release platforms.

The image copies the committed documents; regenerate and commit them before
building an image directly. This covers the application's Go dependencies,
not a new inventory of the base image or code copied outside Go dependencies.