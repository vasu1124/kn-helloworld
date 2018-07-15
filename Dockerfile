# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang as builder

# Copy the local package files to the container's workspace.
COPY . /go/src/github.com/vasu1124/kn-helloworld/

# Build the helloworld command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN cd /go/src/github.com/vasu1124/kn-helloworld/; make


FROM scratch
COPY --from=builder /go/src/github.com/vasu1124/kn-helloworld/kn-helloworld-linux-amd64 /

# Run the kn-helloworld command by default when the container starts.
ENTRYPOINT [ "/kn-helloworld-linux-amd64" ]

# Document that the service listens on port 8080.
EXPOSE 8080