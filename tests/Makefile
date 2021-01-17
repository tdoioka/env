# Specify bash for shell.
SHELL:=sh
SHELL:=$(shell which bash)
# Disable implicit tasks and variable
MAKEFLAGS += --no-builtin-rules --no-builtin-variables --no-print-directory

################################################################################
# Overridable values
################################################################################
# default IMAGE.
IMAGE ?= u18
# default image name.
INAME ?= $*
# connection user
CUSER ?= user
# container name.
CNAME ?= $(INAME).$(notdir $(cwd))
# default TASK.
TASK ?= enter
# Default goal is enter
.DEFAULT_GOAL = $(TASK)

variable.help:
	@echo -e "$(indent)Overwritable variables default values:"
	@echo -e ''
	@echo -e "$(indent)\tIMAGE\t= $(IMAGE)\t\t# Default BASE_MAGE keyword."
	@echo -e "$(indent)\tTASK\t= $(TASK)\t\t# Default task."
	@echo -e "$(indent)\tINAME\t= $(IMAGE)\t\t# Operation target image name."
	@echo -e "$(indent)\tCNAME\t= $(IMAGE).$(notdir $(cwd))\t# Operation target container name."
	@echo -e "$(indent)\tCUSER\t= $(CUSER)\t\t# User name in container."
	@echo -e ''

################################################################################
# Image Names.
################################################################################
# Available images, u20=Ubuntu-20.04, u18=Ubuntu-18.04, u16=Ubuntu-16.04.
images := u20 u18 u16

# image to base-os-image map
base_u20 = ubuntu:20.04
base_u18 = ubuntu:18.04
base_u16 = ubuntu:16.04

################################################################################
# tasks.
################################################################################
tasks = enter start stop stopall restart build clean rebuild
.PHONY: $(tasks)

$(tasks): %: $(IMAGE).%

# When exists image named $(1) plot $(2), if not plot $(3).
define ifimg
	$(if $(shell docker image ls -q $(1)),$(2),$(3))
endef
# When exists container named $(1) plot $(2), if not plot $(3).
define ifcnt
	$(if $(shell docker ps -qf name=$(1)),$(2),$(3))
endef
# For take over when recursive call.
export cwd ?= $(PWD)
# base os name
bname = $(base_$*)
# help command
helps=$(tasks:%=%.help)
.PHONY: $(helps) help
help:
	@echo -e "make $(PRECMD)           \t: Same as \`make $(PRECMD)$(IMAGE).$(TASK)'"
	@echo -e "make $(PRECMD)<os>       \t: Same as \`make $(PRECMD)<os>.$(TASK)'"
	@echo -e "make $(PRECMD)<task>     \t: Same as \`make $(PRECMD)$(IMAGE).<task>'"
	@echo -e "make $(PRECMD)<os>.<task>\t: Specify docker BASE_IMAGE and operation task."
	@echo
	@echo -e "\t<os>: A keyword that specifies docker base. You can use any of the following:"
	@echo
	@echo -e "\t\tKeyword\t| BASE_IMAGE "
	@echo -e "\t\t--------+------------------"
	@echo -e $(foreach x,$(images),"\t\t$(x)\t| $(base_$(x))\n")
	@echo
	@echo -e "\t<task>: A operation task. You can use any of the following:"
	@echo
	@$(foreach x,$(tasks),make -j1 -$(MAKEFLAGS) indent='\t\t' $(x).help;)
	@echo
	@make -j1 -$(MAKEFLAGS) indent='\t' variable.help;
	@echo

# build, clean and rebuild
#................................................................................
# Build image.
builds = $(images:%=%.build)
.PHONY: $(builds)
$(builds): %.build:
	$(call ifimg,$(INAME),,							\
		docker build -q -t $(INAME) --build-arg BASE_IMAGE=$(bname) .)
build.help: # show help
	@echo -e "$(indent)$(basename $@)\t: Build docker image."
	@echo -e "$(indent)\t  Can specify <image-name> with argument \`INAME=<image-name>'."
	@echo -e "$(indent)\t  If image already exists, do nothing."
# Remove image.
cleans = $(images:%=%.clean)
.PHONY: $(cleans)
$(cleans): %.clean: %.stopall
	$(call ifimg,$(INAME),			\
		docker rmi $(INAME))
clean.help:
	@echo -e "$(indent)$(basename $@)\t: Remove docker image."
	@echo -e "$(indent)\t  Can specify <image-name> with argument \`INAME=<image-name>'."
	@echo -e "$(indent)\t  If the runnning containers are using the specified image,"
	@echo -e "$(indent)\t  stop those conters."
	@echo -e "$(indent)\t  If image not exists, do nothing."
# Rebuild image.
rebuilds = $(images:%=%.rebuild)
.PHONY: $(rebuilds)
$(rebuilds): %.rebuild:
	$(MAKE) $*.clean
	$(MAKE) $*.build
rebuild.help:
	@echo -e "$(indent)$(basename $@)\t: \`clean' then \`build'."
# start, stop, stopall and restart
#................................................................................
# Launch container as background.
starts = $(images:%=%.start)
.PHONY: $(starts)
$(starts): %.start: %.build
	$(call ifcnt,$(CNAME),,				\
		docker run --rm -itd --name $(CNAME)	\
			-v $(cwd):/work:ro		\
			-e "TERM=$(TERM)"		\
			-e "CUSER=$(CUSER)"		\
			--workdir=/work			\
			"$(INAME)")
	$(call ifcnt,$(CNAME),,$(call syncwait))
define syncwait
	@echo wait sync...
	@while [[ $$(($$(grep -e Dirty: -e Writeback: /proc/meminfo |		\
		awk '{print "+" $$2}'))) -ne 0 ]]; do sync; sleep 0.5; done
endef
start.help:
	@echo -e "$(indent)$(basename $@)\t: Start a container."
	@echo -e "$(indent)\t  If image is not exists, build by \`build' task."
	@echo -e "$(indent)\t  Can specify <container-name> with argument"
	@echo -e "$(indent)\t  \`CNAME=<container-name>'."
	@echo -e "$(indent)\t  Can specify <image-name> with argument \`INAME=<image-name>'."
	@echo -e "$(indent)\t  Can specify <user-name> with argument \`CUSER=<user-name>'."
	@echo -e "$(indent)\t  If you specified <user-name>, must specify the same"
	@echo -e "$(indent)\t   <user-name> with \`enter'."
# Shutdown container.
stops = $(images:%=%.stop)
.PHONY: $(stops)
$(stops): %.stop:
	$(call ifcnt,$(CNAME),			\
		docker stop $(CNAME))
stop.help:
	@echo -e "$(indent)$(basename $@)\t: Stop a container."
	@echo -e "$(indent)\t  Can specify container with argument \`CNAME=<container-name>'."
	@echo -e "$(indent)\t  If container is not started, do nothing."
# Down all same image instance.
define stopall
	$(if $(1),docker stop $(1))
endef
stopalls = $(images:%=%.stopall)
.PHONY: $(stopalls)
$(stopalls): %.stopall:
	$(call stopall,$(shell docker ps -qf ancestor=$(INAME)))
stopall.help:
	@echo -e "$(indent)$(basename $@)\t: Stop all containers uses specified image. "
	@echo -e "$(indent)\t  Can specify <image-name> with argument \`INAME=<image-name>'."
	@echo -e "$(indent)\t  If no container is started, do nothing."
# Restart container.
restarts = $(images:%=%.restart)
.PHONY: $(restarts)
$(restarts): %.restart:
	$(MAKE) $*.stop
	$(MAKE) $*.start
restart.help:
	@echo -e "$(indent)$(basename $@)\t: \`stop' then \`start'."

# enter
#................................................................................
# Enter container
enters = $(images:%=%.enter)
.PHONY: $(enters)
$(enters): %.enter: %.start
	docker exec -u $(CUSER) --workdir=/home/$(CUSER) -it $(CNAME) /bin/bash
enter.help:
	@echo -e "$(indent)$(basename $@)\t: Entering a container."
	@echo -e "$(indent)\t  If container not exists, start by \`start' task."
	@echo -e "$(indent)\t  Can specify container with argument \`CNAME=<container-name>'."
	@echo -e "$(indent)\t  Can specify entering user with argument \`CUSER=<user-name>'."
	@echo -e "$(indent)\t  If the container was started with CUSER, must specify the"
	@echo -e "$(indent)\t  same <user-name>."
	@echo -e "$(indent)\t  If need image creation, can specify <image-name> with"
	@echo -e "$(indent)\t  argument \`INAME=<image-name>'."
# Image name default task is enter
$(images): %: %.enter
.PHONY: $(images)
