# Environment variables:
all: cicd-build

export DOCKER_BUILDKIT := 1

# This is the list of all Go files in the project.
# We'll use this as the dependency list for all of the Go-based binaries.
ALL_GO_FILES := $(shell find ./ -name '*.go')

.PHONY: clean
clean:
	go clean
	rm -rf bin

# Runs unit tests
.PHONY: test
test:
	go vet ./...
	go test -cover -race -parallel 10 ./...

.PHONY: format
format:
	go fmt ./...

#
# CI/CD targets
#

.PHONY: cicd-build
cicd-build: bin/go-msi bin/go-msi.exe

bin/go-msi.exe: $(ALL_GO_FILES)
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $@ ./cmd/go-msi/...

bin/go-msi: $(ALL_GO_FILES)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $@ ./cmd/go-msi/...

