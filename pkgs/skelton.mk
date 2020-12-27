pkg-bdeps :=
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(log-post)
