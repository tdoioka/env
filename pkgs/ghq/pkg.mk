pkg-bdeps := go git general
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
	$(call rcmake,$(SHRC)/goenv.rc.sh,install-ghq)
	$(log-post)

# Install ghq
.PHONY: install-ghq
install-ghq:
	go get github.com/motemen/ghq
