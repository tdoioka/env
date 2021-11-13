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
	$(MAKE) $(.repo_bin)
	$(log-post)

.repo_bin := $(HOME)/bin/repo
$(.repo_bin): $(DIRS)
	curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo -o $@
	chmod a+x $@
