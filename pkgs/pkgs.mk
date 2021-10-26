# Use second expansion
.SECONDEXPANSION:
# set locale
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

include path.conf

# This OS version
lsb-v:=$(shell lsb_release -c | awk '{print $$NF}')

################################################################
# Goal
pkg-goal := $(or $(MAKECMDGOALS),$(.DEFAULT_GOAL),all)
state := $(CACHED)
# Inter tasks.
first := $(state)/done.first
preup := $(state)/done.preup
update := $(state)/done.update
all := $(state)/done.all

# Fake task for not implemented.
$(state)/%:
	$(log-pre)
	$(call log-wrn,[$@] is NOT Implement!!)
	$(log-post)

################################################################
# Functions for indivisual PKGs basic tasks.
################################################################
define pkg-rule-task
pkg := $$(notdir $$(shell dirname $$(lastword $$(MAKEFILE_LIST))))
pkg-preup := $(preup)-$$(pkg)
pkg-update := $(update)-$$(pkg)
pkg-all := $(all)-$$(pkg)
$$(eval $$(call pkg-rule-task1,$$(pkg)))
$$(eval $$(call pkg-link-task,$$(pkg)))
endef

define pkg-rule-task1
$(preup)-$(1): $(wildcard $(1)/pkg.mk)| $(first)
$(preup)-$(1): $$(addprefix $(preup)-,$$(pkg-bdeps) $$(pkg-rdeps))

$(update)-$(1): $(wildcard $(1)/pkg.mk) $(preup)-$(1)| $(preup)
$(update)-$(1): $$(addprefix $(update)-,$$(pkg-bdeps) $$(pkg-rdeps))

$(all)-$(1): $(wildcard $(1)/pkg.mk) $(update)-$(1)| $(update)
$(all)-$(1): $$(addprefix $(all)-,$$(pkg-bdeps))

.PHONY: $(1)
$(1): $(all)-$(1) $(wildcard $(1)/pkg.mk)
$(1): $$(addprefix $(all)-,$$(pkg-rdeps))
$(1):
	$$(log-pre)
	$$(log-post)

all: $(all)-$(1)

$(1)-state := $(wildcard $(state)/*-$(1))
.PHONY: clean clean.$(1)
clean: clean.$(1)
clean.$(1):
	$$(log-pre)
	$$(if $$($(1)-state),-rm -v $$($(1)-state) $$(log-cmd))
	$$(call log-dbg,DONE)

.PHONY: clean-r clean-r.$(1)
clean-r: clean
clean-r.$(1): clean.$(1) $$(addprefix clean-r.,$$(pkg-bdeps))

.PHONY: upgrade upgrade.$(1)
upgrade: upgrade.$(1)
upgrade.$(1): clean.$(1)
	$$(log-pre)
	$$(MAKE) $(1)
	$$(call log-dbg,DONE)
endef

define pkg-link-task
$$(SHRC)/%.rc.sh: $(1)/%.rc.sh | $$(SHRC)
	$$(call pkg-link,$$<,$$@)
$$(SHRC)/%.rc.zsh: $(1)/%.rc.zsh | $$(SHRC)
	$$(call pkg-link,$$<,$$@)
$$(SHRC)/%.rc.bash: $(1)/%.rc.bash | $$(SHRC)
	$$(call pkg-link,$$<,$$@)
$$(ZFUNC)/%: $(1)/%.func.zsh | $$(ZFUNC)
	$$(call pkg-link,$$<,$$@)
$$(HOME)/.%: $(1)/%.rc
	$$(call pkg-link,$$<,$$@)
endef

################################################################
# All makefile, packages.
################################################################
mks = $(wildcard */pkg.mk)
include $(mks)

pkgs = $(mks:%/pkg.mk=%)

################################################################
# All target.
################################################################
pkg-bdeps =
pkg-rdeps = $(pkgs)
$(eval $(call pkg-rule-task1,all))
$(preup)-all $(update)-all $(all)-all:
	$(log-pre)
	$(log-post)

.PHONY: all update preup
preup: $(preup)-all
update: $(update)-all
all: $(all)-all
preup update:
	$(log-pre)
	$(log-post)

################################################################
# All basic tasks.
################################################################
chain := $(strip $(foreach pkg,$(pkgs),$(findstring $(pkg),$(pkg-goal))))
chain := $(or $(chain),$(pkg-goal))
$(preup): $(first) $(chain:%=$(preup)-%)
$(update): $(preup) $(chain:%=$(update)-%)
$(all): $(update) $(chain:%=$(all)-%)
$(first) $(preup) $(update) $(all):| $(DIRS)
$(first):
	$(log-pre)
	$(call pkg-schedule, \
		software-properties-common \
		lsb-release \
	)
	$(log-post)
$(preup) $(update):
	$(log-pre)
	$(call pkg-update-and-install)
	$(log-post)
$(all):
	$(log-pre)
	$(log-post)

# ==============================================================
# Package update and install tasks
# ==============================================================
export DEBIAN_FRONTEND=noninteractive
.pkg-updated := $(CACHED)/$(UPDATED)
define pkg-update-and-install
	$(call .pkg-update-ifneed)
	$(call .pkg-install-ifneed)
endef
# Repo update.
define .pkg-update-ifneed
	$(if $(wildcard $(.pkg-updated)),,$(call .pkg-do-updaterepo))
endef
define .pkg-do-updaterepo
	sudo apt-get update -y $(log-cmd)
	touch $(.pkg-updated)
endef
# Package Install
.pkg-list := $(CACHED)/pkgs.list
.pkg-lock := flock $(.pkg-list)
.pkg-dmpsched :=
.pkg-dmpsched += sed $(.pkg-list) -e "s/  */\n/g"
.pkg-dmpsched += | sort -u | tr "\n" " "
.pkg-dmpsched-cmd := $(.pkg-lock) bash -c '$(.pkg-dmpsched)'
.pkg-dmpsched-mcr = $(shell $(.pkg-dmpsched-cmd))
.pkg-needinstall = $(and $(.pkg-dmpsched-mcr),$(call .pkg-chkpkgs))
.pkg-inscmd := sudo apt-get install -y --no-install-recommends
.pkg-inscmd += -o Dpkg::Options::="--force-confdef"
.pkg-inscmd += -o Dpkg::Options::="--force-confold"
define .pkg-install-ifneed
	$(call log-infw,Install [$(.pkg-dmpsched-mcr)])
	$(if $(.pkg-needinstall),$(.pkg-pkginstall))
endef
define .pkg-chkpkgs
	$(shell dpkg -L $(.pkg-dmpsched-mcr) >/dev/null 2>&1 || echo NA)
endef
define .pkg-pkginstall
	$(.pkg-inscmd) $(.pkg-dmpsched-mcr) $(log-cmd)
	$(.pkg-lock) rm -vf $(.pkg-list) $(log-cmd)
endef

################################################################
# Public functions.
################################################################

# ==============================================================
# Usage:
#   $(call pkg-addrepo,SEARCHWORD,REPOSITORY)
# Description:
#   Add pkg REPOSITORY, if not find SEARCHWORD repository list.
#   It is intended for use at $(pkg-preup) or $(pkg-update).
# ==============================================================
APTPATH := /etc/apt/sources.list /etc/apt/sources.list.d/*
PKG_REPOS_LIST := $(wildcard $(APTPATH)) /dev/null
.pkg-repolock := flock /etc/apt/sources.list

.addrepo-opt_xenial := -y
.addrepo-opt_bionic := -n -y
.addrepo-opt_focal := -n -y
.addrepo-opt:=$(.addrepo-opt_$(lsb-v))

define pkg-addrepo
	$(call $(if $(2),.pkg-addrepo2,.pkg-addrepo1),$(1),$(2))
	rm -vf $(.pkg-updated) $(log-cmd)
endef
define .pkg-addrepo2
	$(call log-infw,Add repos [$(1):$(2)])
	$(if $(call .pkg-isnorepo,$(2)),$(call .pkg-addrepo,$(.addrepo-opt) $(1):$(2)))
endef
define .pkg-addrepo1
	$(call log-infw,Add repos [$(1)])
	$(if $(call .pkg-isnorepo,$(1)),$(call .pkg-addrepo,$(1)))
endef
define .pkg-isnorepo
	$(shell $(.pkg-repolock) grep -sqF "$(1)" $(PKG_REPOS_LIST) || echo NA)
endef
define .pkg-addrepo
	$(.pkg-repolock) sudo add-apt-repository $(1) $(log-cmd)
endef

# ==============================================================
# Usage:
#   $(call pkg-schedule,PACKAGES)
# Description:
#   Add PACKAGES to installation schedule.
#   Install at preupdate and update.
# ==============================================================
define pkg-schedule
	$(call log-infw,Sched install [$(1)])
	$(.pkg-lock) echo $(1) >> $(.pkg-list)
endef

# ==============================================================
# Usage:
#   $(call pkg-link,SRC,DST)
# Description:
#   Create a symbolic link from DST to SRC. If the realpath are
#   same, it will not be created.
# ==============================================================
define pkg-link
	$(call log-infw,Linked $(2) => $(1))
	$(call .pkg-link-ifneed,$(shell realpath $(1)),$(shell realpath $(2)))
endef
define .pkg-link-ifneed
	$(if $(filter-out $(1),$(2)),$(call .pkg-link,$(1),$(dir $(2)),$(2)))
endef
define .pkg-link
	ln --backup=numbered -nfTs $(call .pkg-rel-path,$(1),$(2)) $(3)
endef
define .pkg-rel-path
	$(shell realpath -s $(1) --relative-to $(2))
endef

# ==============================================================
# Usage:
#   $(call git-clone,<URL>)
# Description:
#   Clone with --depth 1 from <URL> to rule-target.
# ==============================================================
define git-clone
	$(log-pre)
	$(if $(wildcard $@),
		git pull -C $@,
		$(call .git-clone,$(1)))
	$(log-post)
endef
define .git-clone
	$(if $(wildcard $@-tmp),-rm -rf $@-tmp)
	git clone --depth 1 $(1) $@-tmp
	mv -v $@-tmp $@
endef
