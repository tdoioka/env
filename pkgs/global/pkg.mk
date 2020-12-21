GLOBAL_VERSION ?= 6.6.4

# ================================================================

pkg-bdeps := python
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		exuberant-ctags			\
		libncurses5-dev			\
		curl				\
	)
	$(log-post)

.global_srcdir := $(pkg)/global-$(GLOBAL_VERSION)
$(pkg-all):
	$(log-pre)
	$(MAKE) $(.global_srcdir)
	(bash -c "source $(SHRC_LOADER) && \
		pip install pygments && \
		cd $(.global_srcdir) && ./configure") \
		$(log-cmd)
	$(MAKE) -C $(.global_srcdir) $(log-cmd)
	sudo $(MAKE) -C $(.global_srcdir) install $(log-cmd)
	$(MAKE) $(HOME)/.globalrc
	$(log-post)

$(.global_srcdir):
	$(log-pre)
	$(if $(wildcard $(@D)),,mkdir -p $(@D))
	curl -fsSL http://tamacom.com/global/global-$(GLOBAL_VERSION).tar.gz \
		-o - | tar xzf - -C $(@D)
	$(log-post)
