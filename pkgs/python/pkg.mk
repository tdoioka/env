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
	python-dev 				\
	python3-dev 				\
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
	$(MAKE) $(.pyenv-root) $(.python-shrc) $(log-cmd)
	$(call rcmake,$(.python-shrc),			\
		$(.pyenv-ver-dirs) $(.pyenv-version)	\
		$(.pipenv-bin) $(.python-tools))
	$(log-post)

# pyenv
# ================================================================
# Environment variable
.python-shrc := $(SHRC)/python.rc.sh
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
.pipenv-bin  := $(HOME)/.local/bin/pipenv

# Install pipenv
$(.pipenv-bin):| $(.pyenv-version)
	$(log-pre)
	pip install --upgrade pip $(log-cmd)
	pip install --user --upgrade pipenv $(log-cmd)
	$(log-post)

# Tools for developments to pyenv.
# ================================================================
# non
.install-python-devtools := $(HOME)/bin/install-python-devtools
$(.install-python-devtools): $(pkg)/install-python-devtools
	$(call pkg-link,$<,$@) $(log-cmd)

.python-tools := $(pkg-all)-tools
$(.python-tools):| $(.pipenv-bin) $(.install-python-devtools)
	$(log-pre)
	bash -c $(.install-python-devtools)
	$(log-post)
