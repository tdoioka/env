pkg-bdeps :=
pkg-rdeps := general
$(eval $(call pkg-rule-task))

$(pkg-preup) $(pkg-update):
	$(log-pre)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE)					\
		$(SHRC)/libsh.rc.sh		\
		$(HOME)/.libsh
	$(log-post)
