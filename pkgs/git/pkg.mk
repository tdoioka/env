pkg-bdeps :=
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-addrepo,ppa,git-core/ppa)
	$(call pkg-schedule,git)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(HOME)/.gitconfig \
		$(HOME)/.gitconfig.d
	$(log-post)
