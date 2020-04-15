NAME=terraform-provider-jenkins
VERSION=$(shell cat VERSION)
COMMIT = $(shell git log -1 --format="%h" 2>/dev/null || echo "0")
BUILD_DATE = $(shell date -u +%Y-%m-%dT%H:%M:%SZ)

LDFLAGS = -ldflags "\
  -X $(PROJECT)/constants.COMMIT=$(COMMIT) \
  -X $(PROJECT)/constants.VERSION=$(VERSION) \
  -X $(PROJECT)/constants.BUILD_DATE=$(BUILD_DATE) \
  "

GOCMD=go
GOBUILD = $(GOCMD) build $(LDFLAGS)

build:
	GOOS=linux GOARCH=amd64  $(GOBUILD) -o dist/linux_amd64/$(NAME)_v$(VERSION) cmd/provider/main.go
	GOOS=darwin GOARCH=amd64 $(GOBUILD) -o dist/darwin_amd64/$(NAME)_v$(VERSION) cmd/provider/main.go

check:
	make build
	terraform init
	terraform plan
