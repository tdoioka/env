pkg-bdeps :=
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		tmux,				\
	)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(HOME)/.tmux.conf
	$(log-post)
