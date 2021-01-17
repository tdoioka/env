# Specify bash for shell.
SHELL:=sh
SHELL:=$(shell which bash)
# Disable implicit tasks and variable
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

################################################################################
# Overridable values
################################################################################
# default BASE_IMAGE.
IMAGE ?= u18
# connection user.
CUSER ?= user
# Default goal task
.DEFAULT_GOAL = $(IMAGE)
################################################################################
# help
################################################################################
.PHONY: help
help:
	@$(MAKE) --no-print-directory -C $(dockerd) $@

################################################################################
# under ./tests tasks, inherit all commands
################################################################################
dockerd = tests
images = u20 u18 u16
tasks = enter start stop stopall restart build clean rebuild

targets = $(foreach image,$(images),$(foreach task,$(tasks),$(image).$(task)))
targets += $(images) $(tasks)
.PHONY: $(targets) $(dockerd)
$(targets):
	$(if $(wildcard $(dockerd)),\
		$(MAKE) -C $(dockerd) $@)

$(dockerd):
	$(if $(wildcard $@),$(MAKE) -C $@)
