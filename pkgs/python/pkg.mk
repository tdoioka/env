# Install python same version as Ubuntu 20.04
PYENV_GLOBAL ?= 3.8.2
# You can specify 1 or more version.
PYENV_EXTRA_VERSIONS ?=

# ================================================================

pkg-bdeps := git general locale
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

python_requirements :=				\
	build-essential				\
	curl					\
	libbz2-dev				\
	libffi-dev				\
	liblzma-dev				\
	libncurses5-dev				\
	libncursesw5-dev			\
	libreadline-dev				\
	libsqlite3-dev				\
	libssl-dev				\
	llvm					\
	python-openssl				\
	tk-dev					\
	wget					\
	xz-utils				\
	zlib1g-dev

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,$(python_requirements))
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE)	$(.pyenv-root) $(.pyenv-shrc) $(log-cmd)
	$(call rcmake,$(.pyenv-shrc),\
		$(.pyenv-ver-dirs) $(.pyenv-version) $(.pipenv-bin))
	$(log-post)

# pyenv
# ================================================================
# Environment variable
.pyenv-shrc := $(SHRC)/pyenv.rc.sh
.pyenv-git  := $(pkg)/pyenv.rc
.pyenv-root := $(HOME)/.pyenv
# All versions to install.
.pyenv-ins-vers := $(sort $(PYENV_GLOBAL) $(PYENV_EXTRA_VERSIONS))
.pyenv-ver-dirs := $(.pyenv-ins-vers:%=$(.pyenv-root)/versions/%)
.pyenv-version  := $(.pyenv-root)/version

# Download pyenv src.
$(.pyenv-git):
	$(call git-clone,https://github.com/pyenv/pyenv.git)

# Build and Install pyenv.
$(.pyenv-ver-dirs):| $(.pyenv-root) $(pyenv-shrc)
	pyenv install -v $(@F) $(log-cmd)

# Set global.
$(.pyenv-version):| $(.pyenv-ver-dirs) $(pyenv-shrc)
	pyenv global system $(PYENV_GLOBAL) $(log-cmd)

# pipenv
# ================================================================
# Environment variable.
.pipenv-shrc := $(SHRC)/pipenv.rc.sh
.pipenv-bin  := $(HOME)/.local/bin/pipenv

# Install pipenv
$(.pipenv-bin):| $(.pyenv-version) $(.pipenv-shrc)
	$(log-pre)
	pip install --upgrade pip $(log-cmd)
	pip install --user --upgrade pipenv $(log-cmd)
	$(log-post)
