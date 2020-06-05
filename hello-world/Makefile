app := hello-world
image := fnhs.azurecr.io/platform/$(app)
tag := latest

.PHONY: default
default: ## Run locally
	cargo run

.PHONY: test
test: ## Run tests [TEST=test_name (optional)]
	cargo test $$TEST

.PHONY: docker-build
docker-build: ## Build and tag Docker image
	DOCKER_BUILDKIT=1 docker build \
		--progress plain \
		--tag $(app) \
		--tag $(image) \
		--tag $(image):$(tag) \
		.
.PHONY: docker-run
docker-run: ## Run Docker image
	docker run -it -p 3030:3030 $(image)

.PHONY: docker-push
docker-push: ## Push Docker image
	docker push $(image)
	docker push $(image):$(tag)

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
