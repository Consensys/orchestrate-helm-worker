.PHONY: push
push: push-api push-worker

.PHONY: push-api
push-api:
	@helm push-artifactory core-stack-api helm-orchestrate

.PHONY: push-worker
push-worker:
	@helm push-artifactory core-stack-worker helm-orchestrate

.PHONY: lint
lint:
	@helm lint core-stack-api core-stack-worker
