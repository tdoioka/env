# Use second expansion
.SECONDEXPANSION:
# Disable Implicit Rules and variable (-Rr)
suppress-implicit := --no-builtin-rules --no-builtin-variables
Q ?= y
quiet = $(if $(filter-out n 0,$(Q)),--quiet)
child-mkflag := $(MAKEFLAGS) $(quiet)
MAKEFLAGS += $(suppress-implicit)
MAKEFLAGS += $(quiet) --no-print-directory
MAKE_COMMAND := make MAKEFLAGS=$(child-mkflag) --no-print-directory

# Set internal parameter.
SHELL := /bin/bash -e -o pipefail
D ?=
DEBUG ?= $(filter-out n 0,$(D))
.DEFAULT_GOAL ?= all

.PHONY: all
all:

include path.conf

# Directories for make
DIRS =
# # Intermediate files, remove when clean task
# .INTER_FILES =

# Common shell rc directory in pkgs DIR
SHRC := _shrc
DIRS += $(SHRC)
# CACHED := _state
DIRS += $(CACHED)

include log.mk
include pkgs.mk

################################################################
# Common tasks
################################################################
# .PHONY: clean

$(sort $(DIRS)):
	$(log-pre)
	mkdir -p $@
	$(log-post)
