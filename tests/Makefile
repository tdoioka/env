SHELL:=sh
SHELL:=$(shell which bash)

IMAGES:= u20env u18env u16env
BASE_u20env=ubuntu:20.04
BASE_u18env=ubuntu:18.04
BASE_u16env=ubuntu:16.04
DEFENV=u18env

################################################################
## Management
################################################################
TASKS=run con build clean
.PHONY: $(TASKS) debug
$(TASKS): %: $(DEFENV).%

.PHONY: $(IMAGES)
$(IMAGES): %: %.run

debug:
	@echo $(BUILDS)
	@echo $(CLEANS)

################################################################
## BUILD/CLEAN Rule
################################################################
BUILDS := $(IMAGES:u%env=u%env.build)
.PHONY: $(BUILDS)
$(BUILDS): %.build:
	./docker_build.sh $@ '$(BASE_$(@:%.build=%))'

CLEANS := $(IMAGES:u%env=u%env.clean)
.PHONY: $(CLEANS)
$(CLEANS): %.clean:
	./docker_build.sh $@

################################################################
## RUN rule
################################################################
.cwd=$(PWD)
.name=$(basename $@)
.instance=$(.name)-$(notdir $(PWD))

RUNS := $(IMAGES:u%env=u%env.run)
.PHONY: $(RUNS)
$(RUNS): %.run: %.build
	docker run --rm --name "$(.instance)" -v "$(.cwd):/work" --workdir="/work" -it -e "TERM=$(TERM)" "$(.name)"

CONS := $(IMAGES:u%env=u%env.con)
.PHONY: $(CONS)
$(CONS): %.con: %.build
	docker exec -u user -it "$(.instance)" /bin/bash
