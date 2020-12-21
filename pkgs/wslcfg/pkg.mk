pkg-bdeps := general
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
	$(MAKE) $(SHRC)/wslcfg.rc.sh
	$(log-post)
