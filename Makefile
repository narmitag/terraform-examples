
.PHONY: all info init refresh plan apply destroy fmt

# use `make plan` to do a dry-run. And same pattern for all other commands

fmt:
	terraform get
	terraform validate
	terraform fmt

check:
	tfsec .

run-tests:
	cd test; go test -v -timeout 30m
