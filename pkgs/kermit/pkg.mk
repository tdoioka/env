pkg-bdeps :=
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		ckermit				\
	)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(SHRC)/kermit.rc.zsh
	sudo gpasswd -a $(shell id -nu) dialout
	$(log-post)
