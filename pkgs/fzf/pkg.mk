pkg-bdeps := git general locale
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		curl				\
	)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(HOME)/.fzf $(SHRC)/fzf.rc.bash $(SHRC)/fzf.rc.zsh
	$(HOME)/.fzf/install --all --no-update-rc $(log-cmd)
	$(log-post)

define fzf-clone
	$(if $(wildcard $(@)-tmp),rm -rf $(@)-tmp)
	git clone --depth 1 https://github.com/junegunn/fzf.git $(@)-tmp
	mv $(@)-tmp $@
endef
$(pkg)/fzf.rc:
	$(log-pre)
	$(if $(wildcard $@),			\
		git pull -C $@,			\
		$(call fzf-clone))
	$(log-post)
