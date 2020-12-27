pkg-bdeps :=
pkg-rdeps :=
$(eval $(call pkg-rule-task))

DIRS += $(HOME)/bin

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		tree				\
		less				\
		nkf				\
		rsync				\
		)
	$(log-post)

SHRC_LOADER=$(SHRC)/loader.rc.sh
$(HOME)/.bash_profile:| $(SHRC)/loader.rc.sh
	$(call pkg-link,$(firstword $|),$@)
$(HOME)/.shrc:| $(SHRC)
	$(call pkg-link,$(firstword $|),$@)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(SHRC_LOADER)			\
		$(SHRC)/funcs.rc.sh		\
		$(SHRC)/alias.rc.sh		\
		$(HOME)/.shrc			\
		$(HOME)/.bash_profile
	$(log-post)

define rcmake
	$(if $(1),,$(error 'rcmake passed empry args.'))
	$(if $$(wildcard $(SHRC_LOADER)),,$(error 'Not found SHRC_LOADER, add general to pkg-bdeps'))
	$(if $(2),\
		$(call .rcmake,$(1),$(2)),\
		$(call .rcmake,$(SHRC_LOADER),$(1)))
endef
define .rcmake
	+
	bash -c "source $(1) && $(MAKE) $(2)"
endef
