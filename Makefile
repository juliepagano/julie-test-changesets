GO                    ?= go
VERSION               ?= $(shell cat VERSION)
GORELEASER_PARALLEL   ?= 0
DATE                  := $(shell date +%Y-%m-%d)

.PHONY: generate-changelog
generate-changelog:
	$(GO) run ./scripts/generate-changelog/generate-changelog.go --version="${VERSION}"

## Build go 
.PHONY: cross-build
cross-build: ## Cross build binaries for all platforms (Use "make build" in development)
	goreleaser build --snapshot --rm-dist --parallelism ${GORELEASER_PARALLEL}

.PHONY: cross-release
cross-release:
	goreleaser release --rm-dist --parallelism ${GORELEASER_PARALLEL} --release-notes GENERATED_CHANGELOG.md

.PHONY: bump-version
bump-version:
	./scripts/ui_release.sh --bump-version "${VERSION}"
	cd ui/ && npm install
<<<<<<< HEAD
	git add "./ui/package-lock.json" "./**/package.json"

.PHONY: tag
tag:
	./scripts/release.sh --tag "${VERSION}"
=======
	git add "./ui/package-lock.json" "./**/package.json"
>>>>>>> origin/main
