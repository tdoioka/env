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
	$(log-post)


.PHONY: zplug-install
zplug-install: $(pkg-all)
	declare > ~/tmp
	zsh <<< "ZPLUG_INSTALL=y; source ~/.zshrc" $(log-cmd)
$(pkg): zplug-install

.zplug := $(pkg)/zshrc.d.rc/zplug
$(.zplug):
	$(log-pre)
	git clone --depth 1 https://github.com/zplug/zplug $@
	$(log-post)

$(pkg)/zshrc.rc:| $(pkg)/zshrc.d.rc/zshrc
	$(call pkg-link,$(firstword $|),$@)
