IMAGES := u20 u18 u16
DEFENV := u18

DOCDIR=tests

################################################################
## Management
################################################################
TASKS=envrun envcon envclean
.PHONY: $(TASKS)
$(TASKS): %: $(DEFENV).%

################################################################
## Environment run/connect/clean
################################################################
.name=$(basename $@)

RUNS := $(IMAGES:%=%.envrun)
.PHONY: $(RUNS)
$(RUNS):
	$(MAKE) -C $(DOCDIR) $(.name)env CWD=$(PWD)

CONS := $(IMAGES:%=%.envcon)
.PHONY: $(CONS)
$(CONS):
	$(MAKE) -C $(DOCDIR) $(.name)env.con

CLEANS := $(IMAGES:%=%.envclean)
.PHONY: $(CLEANS)
$(CLEANS):
	$(MAKE) -C $(DOCDIR) $(.name)env.clean

help:
	@echo "Usage:"
	@echo ""
	@echo "make <IMAGE>.<TASK>"
	@echo ""
	@echo "	IMAGE:"
	@echo "		$(IMAGES)"
	@echo "		u = Ubuntu, Number is madjor release version."
	@echo ""
	@echo "	TASK:"
	@echo "		envrun:"
	@echo "			Run docker environment container for test,"
	@echo "			build image When not exist."
	@echo "		envcon:"
	@echo "			Connect to already running docker container."
	@echo "		envclean:"
	@echo "			Delete docker environment container image."

edits := edit clean.edit
.PHONY: $(edits)
$(edits):
	$(MAKE) -C pkgs $@
