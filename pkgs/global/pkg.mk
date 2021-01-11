GLOBAL_VERSION ?= 6.6.4

# ================================================================

pkg-bdeps := python general
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

$(pkg-all):
	$(log-pre)
	$(call rcmake,$(SHRC)/python.rc.sh,$(.pkg-all-rcenv))
	$(log-post)

# Download global
.global-src := $(pkg)/global-$(GLOBAL_VERSION)
$(.global-src):
	$(log-pre)
	$(if $(wildcard $(@)),rm -rf $(@)/*,mkdir -p $(@))
	curl -fsSL http://tamacom.com/global/global-$(GLOBAL_VERSION).tar.gz \
		-o - | tar xzf - -C $(@D)
	$(log-post)

# Install pygments
.PHONY: global-pygments
global-pygments:
	pip install pygments $(log-cmd)

# Install global
.pkg-all-rcenv := $(pkg-all)-rcenv
$(.pkg-all-rcenv):| $(.global-src) global-pygments
	$(log-pre)
	(cd $(.global-src) && ./configure) $(log-cmd)
	$(MAKE) -C $(.global-src) $(log-cmd)
	sudo $(MAKE) -C $(.global-src) install $(log-cmd)
	$(MAKE) $(HOME)/.globalrc $(log-cmd)
	$(log-post)
