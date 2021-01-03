SHELLCHECK_VERSION ?= 0.7.1


pkg-bdeps :=
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		curl				\
		xz-utils			\
	)
	$(log-post)

.shellcheckdl=$(pkg)/shellcheck-v$(SHELLCHECK_VERSION)/shellcheck
$(.shellcheckdl):
	$(log-pre)
	$(if $(wildcard $(@)),rm -rf $(@D))
	curl -fsSL https://github.com/koalaman/shellcheck/releases/download/v$(SHELLCHECK_VERSION)/shellcheck-v$(SHELLCHECK_VERSION).linux.x86_64.tar.xz \
		-o - | tar xJf - -C $(dir $(@D))
	$(log-post)

.shellcheck = ~/bin/shellcheck
$(.shellcheck): $(.shellcheckdl)
	cp -v $< $@

$(pkg-all):
	$(log-pre)
	$(MAKE) $(.shellcheck)
	$(log-post)
