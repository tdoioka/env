# Install go same version as Ubuntu 20.04
GOENV_GLOBAL ?= 1.13.8
# You can specify 1 or more extra vrsions
GOENV_EXTRA_VERSIONS ?= 1.15.6

# ================================================================

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
	$(MAKE) $(.goenv-root) $(.goenv-shrc) $(log-cmd)
	$(call rcmake,$(.goenv-shrc),$(.goenv-ver-dirs) $(.goenv-version))
	$(log-post)

# goenv
# ================================================================
# Environment variable.
.goenv-shrc := $(SHRC)/goenv.rc.sh
.goenv-git  := $(pkg)/goenv.rc
.goenv-root := $(HOME)/.goenv
# All versions to install.
.goenv-ins-vers := $(sort $(GOENV_GLOBAL) $(GOENV_EXTRA_VERSIONS))
.goenv-ver-dirs := $(.goenv-ins-vers:%=$(.goenv-root)/versions/%)
.goenv-version  := $(.goenv-root)/version

# Download goenv src.
$(.goenv-git):
	$(call git-clone,https://github.com/syndbg/goenv.git)

# Build and install goenvs.
$(.goenv-ver-dirs):| $(.goenv-root) $(goenv-shrc)
	goenv install -v $(@F) $(log-cmd)

# Set global.
$(.goenv-version):| $(.goenv-ver-dirs)
	goenv global $(GOENV_GLOBAL) $(log-cmd)
