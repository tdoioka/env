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

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		build-essential			\
		curl				\
		libbz2-dev			\
		libffi-dev			\
		liblzma-dev			\
		libncurses5-dev			\
		libncursesw5-dev		\
		libreadline-dev			\
		libsqlite3-dev			\
		libssl-dev			\
		llvm				\
		tk-dev				\
		wget				\
		xz-utils			\
		zlib1g-dev			\
		)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE)					\
		$(.pyenv_ver_dirs)		\
		$(.pipenv_bin)			\
		$(.pipenv_shrc)
	$(log-post)

# pyenv
# ================================================================
.pyenv_shrc := $(SHRC)/pyenv.rc.sh

# ================================================================
.pyenv_git  := $(pkg)/pyenv.rc
.pyenv_root := $(HOME)/.pyenv

# Download pyenv source.
define pyenv-clone
	$(if $(wildcard $(@)-tmp),rm -rf $(@)-tmp)
	git clone --depth 1 https://github.com/pyenv/pyenv.git $(@)-tmp
	mv $(@)-tmp $@
endef
$(.pyenv_git):
	$(log-pre)
	$(if $(wildcard $@),			\
		git pull -C $@,			\
		$(call pyenv-clone))
	$(log-post)

# All versions to install.
.pyenv_ins_vers := $(sort $(PYENV_GLOBAL) $(PYENV_EXTRA_VERSIONS))
.pyenv_ver_dirs := $(.pyenv_ins_vers:%=%)

# Build python.
$(.pyenv_ver_dirs):| $(.pyenv_root) $(.pyenv_shrc)
	$(log-pre)
	(bash -c "source $(SHRC_LOADER) && \
		pyenv install -v $(@F) && \
		pyenv global $(PYENV_GLOBAL)") \
		$(log-cmd)
	$(log-post)

# pipenv
# ================================================================
.pipenv_shrc := $(SHRC)/pipenv.rc.sh
.pipenv_bin  := $(HOME)/.local/bin/pipenv

# Install pipenv.
$(.pipenv_bin):| $(.pyenv_ver_dirs)
	$(log-pre)
	(bash -c "source $(SHRC_LOADER) && \
		pip install --upgrade pip && \
		pip install --user --upgrade pipenv") \
		$(log-cmd)
	$(log-post)
