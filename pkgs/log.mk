include path.conf

# Logging directory.
log-DIR ?= $(LOGD)
DIRS += $(log-DIR)

# Set BUILD-DATETIME
export BUILDTIME := $(or $(BUILDTIME),$(shell date +%y%m%d.%H%M%S))

# Set logfile path and pipewrite snipet
.log-FNAME := log.$(BUILDTIME)
.log-FPATH := $(log-DIR)/$(.log-FNAME)
.log-pipewrite := | tee -a $(.log-FPATH)

# Timestamp.
.log-TSFMT := '+%F-%T.%N(%Z)'
# gettime: Get timestamp for use in oneshot shell.
.log-shdate = date $(.log-TSFMT)
.log-gettime = $(shell $(.log-shdate))
# shgettime: Get timestamp for use in shell loop sequence.
.log-shgettime = $$($(.log-shdate))

# Logging.
define .log-xxx
	@echo "$(.log-gettime) $(1): $(or $(2),----) [$(@F:done.%=do.%)] $(3)"
endef
define log-wrn
	$(call .log-xxx,WRN,$(1),$(2))
endef
define log-inf
	$(call .log-xxx,INF,$(1),$(2))
endef
define log-dbg
	$(if $(DEBUG),$(call .log-xxx,DBG,$(1),$(2)))
endef

# Logging with write file.
define log-wrnw
	$(call log-wrn,,$(1)) $(.log-pipewrite)
endef
define log-infw
	$(call log-inf,,$(1)) $(.log-pipewrite)
endef
define log-dbgw
	$(if $(DEBUG),$(call log-dbg,,$(1)) $(.log-pipewrite))
endef


# logging task pre and post.
# ================================================================
# Prerequisites strings.
.log-PREREQ  = $(if $^$|,<= [$^$(if $^, )|$(if $|, )$|])
.log-UPDATED = $(if $?,updated [$?],)

log-pre = $(call .log-pre)
define .log-pre
	$(call log-inf,TASK,$(.log-PREREQ))
	$(call log-dbg,,$(.log-UPDATED))
endef
log-post = $(call .log-post)
define .log-post
	$(call log-dbg,DONE)
	$(if $(wildcard $(@D)),,mkdir -p $(@D))
	touch $@
endef

# Write the log message to a file while fixing it to the end of the console.
# ================================================================

# File name
.log-TASK     = $(@F:done.%=%)
.log-TASKFILE = $(.log-FPATH).$(.log-TASK)

# Console line length.
.log-COLS := $(shell tput cols)
# TAG strint length.
.log-TAGLEN  = $(shell echo "[$(.log-TASK)] " | wc -c)
# Timestamp string length.
.log-TSLEN := $(shell $(.log-shdate) | wc -c)
# Number of characters that can be used in the message
.log-LEN = $(shell echo $$(($(.log-COLS) - $(.log-TSLEN) - $(.log-TAGLEN) - 1)))

# Write the passed characters to a file, format it and output it to the console.
.log-cmdpipewrite  =
.log-cmdpipewrite += | tee -a $(.log-TASKFILE)
# Erase control characters other than line breaks.
.log-cmdpipewrite += | perl -pe 's/(?![\n])[[:cntrl:]]/ /g;'
# Edit the message to fit on one line.
.log-cmdpipewrite += | perl -pe 's|^(.{$(.log-TSLEN)}).*?(.{0,$(.log-LEN)})\n|\r\e[2K\1\[$(.log-TASK)\] \2 |g'

# Get the cursor position and start a new line if it is not the beginning of a line.
define .log-nl
if [[ $$(ROW=; COL=; IFS=';' read -sdR -p $$'\E[6n' ROW COL; echo "$${COL#*[}") -gt 1 ]]; then echo; fi
endef

# Generate a time-stamped log.
.log-line  = echo "$(.log-shgettime) $(1)" $(.log-cmdpipewrite)
# Print the log to a file and console. the console output is formatted.
log-cmd = 2>&1 | while read -r l ; do $(call .log-line,$$l) ; done; $(.log-nl)
