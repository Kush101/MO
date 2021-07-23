.PHONY: default

BINARY="reflectstruct"

GOCMD=go
GORUN=$(GOCMD) run
GOBUILD=$(GOCMD) build
GOTEST=$(GOCMD) test
GODOC=$(GOCMD) doc
GOGET=$(GOCMD) get

default:
	@echo "build target is required for $(BINARY)"
	@exit 1
doc:
	$(GODOC) -all ...
fmt:
	gofmt -l -w .
	goimports -l -w .
	goreturns -l -w .
build: fmt
	$(eval FLAGS := "-s -w")
	$(GOBUILD) -v -ldflags $(FLAGS) -o $(BINARY)
run:
	$(GORUN) -v .
build_linux:
	GOOS=linux GOARCH=amd64 $(GOBUILD) -v -ldflags "-s -w" -o $(BINARY)
build_mac:
	GOOS=darwin GOARCH=amd64 $(GOBUILD) -v -ldflags "-s -w" -o $(BINARY)
build_win:
	GOOS=windows GOARCH=amd64 $(GOBUILD) -v -ldflags "-s -w" -o $(BINARY).exe
test:
	$(GOTEST) -race -cover -covermode=atomic -v -count 1 .
bench:
	$(GOTEST) -parallel=4 -run="none" -benchtime="5s" -benchmem -bench=.
