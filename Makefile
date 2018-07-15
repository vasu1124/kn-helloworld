DOCKERREPO:=vasu1124

# nothing to edit beyond this point
BINARY:=kn-helloworld
GOARCH:=amd64

COMMIT:=$(shell git rev-parse HEAD)
BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)

LDFLAGS=-ldflags "-X github.com/vasu1124/kn-helloworld/pkg/version.VERSION=${COMMIT}"

# Build the project
ifeq ($(shell uname -s), Darwin)
    all=${BINARY}-darwin-${GOARCH}
else
    all=${BINARY}-linux-${GOARCH}
endif
all: ${all}

clean:
	-rm -f ${BINARY}-* debug Gopkg.lock

${GOPATH}/bin/dep:
	go env
	-mkdir ${GOPATH}/bin
	go get -v -u github.com/golang/dep/cmd/dep

depensure: ${GOPATH}/bin/dep
	${GOPATH}/bin/dep ensure -v

SOURCES := $(shell find . -type f -name '*.go')

${BINARY}-linux-${GOARCH}: ${SOURCES}
	CGO_ENABLED=0 GOOS=linux GOARCH=${GOARCH} go build ${LDFLAGS} -o ${BINARY}-linux-${GOARCH} cmd/kn-helloworld/main.go 

${BINARY}-darwin-${GOARCH}: ${SOURCES}
	CGO_ENABLED=0 GOOS=darwin GOARCH=${GOARCH} go build ${LDFLAGS} -o ${BINARY}-darwin-${GOARCH} cmd/kn-helloworld/main.go
