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
		$(HOME)/.shrc			\
		$(HOME)/.bash_profile
	$(log-post)
