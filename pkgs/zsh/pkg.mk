pkg-bdeps := git general locale
pkg-rdeps := fzf
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		zsh				\
	)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(.zplug) $(HOME)/.zshrc.d $(HOME)/.zshrc
	sudo chsh -s /bin/zsh $(shell id -un)
	zsh <<< "ZPLUG_INSTALL=y; source ~/.zshrc" $(log-cmd)
	$(log-post)

.zplug := $(pkg)/zshrc.d.rc/zplug
$(.zplug):
	$(call git-clone,https://github.com/zplug/zplug)

$(pkg)/zshrc.rc:| $(pkg)/zshrc.d.rc/zshrc
	$(call pkg-link,$(firstword $|),$@)
