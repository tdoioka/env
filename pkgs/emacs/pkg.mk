pkg-bdeps := general libsh
pkg-rdeps := git
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-addrepo,ppa,kelleyk/emacs)
	$(call pkg-schedule,			\
		emacs27				\
		emacs-mozc			\
		cmigemo				\
	)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(SHRC)/emacs.rc.sh $(HOME)/.emacs.d
	bash -c "source $(SHRC)/emacs.rc.sh" $(log-cmd)
	$(log-post)
