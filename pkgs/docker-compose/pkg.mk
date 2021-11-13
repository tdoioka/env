pkg-bdeps := git python
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,curl)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(.compose_bin)
	$(log-post)

compose-version := v2.1.1

.compose_bin := $(HOME)/bin/docker-compose
$(.compose_bin): $(DIRS)
	curl -L "https://github.com/docker/compose/releases/download/$(compose-version)/docker-compose-$$(uname -s)-$$(uname -m)" -o $@
	chmod a+x $@
