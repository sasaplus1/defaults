.DEFAULT_GOAL := all

SHELL := /bin/bash

makefile := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(dir $(makefile))

#-------------------------------------------------------------------------------

.PHONY: all
all: ## output targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(makefile) | awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

.PHONY: backup
backup: date := $(shell date +%Y%m%dT%H%M%S)
backup: rand := $(shell cat /dev/urandom | LC_CTYPE=C tr -dc '[:alnum:]' | head -c 3)
backup: ## [subtarget] backup current defaults
	defaults read > defaults.$(date)-$(rand).txt

.PHONY: clean
clean: ## clear backup defaults
	$(RM) defaults.*.txt

.PHONY: vars
vars: ## print variables
	@$(MAKE) -f $(makefile) -prR | grep '^# makefile' -A 1
