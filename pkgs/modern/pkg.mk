EXA_VERSION ?= 0.10.1
BAT_VERSION ?= 0.17.1
HEXYL_VERSION ?= 0.8.0
FD_VERSION ?= 8.2.1
PROCS_VERSION ?= 0.10.10

# ================================================================
pkg-bdeps := general
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		curl				\
		unzip				\
		silversearcher-ag		\
	)
	$(log-post)

moderns =
$(pkg-all):
	$(log-pre)
	$(MAKE) $(moderns) $(SHRC)/modern.rc.sh
	$(log-post)

.modern-dl := $(pkg)/dl
DIRS += $(.modern-dl)

#################################################################
# zip download and install.
#################################################################
define install-zip
moderns += $(HOME)/bin/$(1)
$(pkg)/dl/$(notdir $(.$(1)-url)):| $(pkg)/dl
	curl -fsSL $(.$(1)-url) -o $$@ $$(log-cmd)
$(pkg)/dl/$(.$(1)-unzip):$(pkg)/dl/$(notdir $(.$(1)-url))
	unzip -jo $$< -d $$(@D) $$(log-cmd)
$(HOME)/bin/$(1):$(pkg)/dl/$(.$(1)-unzip)
	$$(call pkg-link,$$<,$$@) $$(log-cmd)
endef

# exa
# ================================================================
# binary
.exa-url := https://github.com/ogham/exa/releases/download/v$(EXA_VERSION)/exa-linux-x86_64-v$(EXA_VERSION).zip
.exa-unzip := exa
$(eval $(call install-zip,exa))

# completions
.exa-zshcmp-url := https://raw.githubusercontent.com/ogham/exa/master/completions/zsh/_exa
$(pkg)/_exa.func.zsh:
	curl -fsSL $(.exa-zshcmp-url) -o $@ $(log-cmd)
moderns += $(ZFUNC)/_exa

# procs
# ================================================================
.procs-url := https://github.com/dalance/procs/releases/download/v$(PROCS_VERSION)/procs-v$(PROCS_VERSION)-x86_64-lnx.zip
.procs-unzip := procs
$(eval $(call install-zip,procs))

#################################################################
# dpkgs download and install.
#################################################################
define install-dpkg
moderns += $(pkg-all)-$(1)
$(pkg)/dl/$(notdir $(.$(1)-url)):| $(pkg)/dl
	curl -fsSL $(.$(1)-url) -o $$@ $$(log-cmd)
$(pkg-all)-$(1): $(pkg)/dl/$(notdir $(.$(1)-url))
	flock $(shell which dpkg) sudo dpkg -i $$< $$(log-cmd)
endef

# bat
# ================================================================
.bat-url := https://github.com/sharkdp/bat/releases/download/v$(BAT_VERSION)/bat_$(BAT_VERSION)_amd64.deb
$(eval $(call install-dpkg,bat))

# hexyl
# ================================================================
.hexyl-url := https://github.com/sharkdp/hexyl/releases/download/v$(HEXYL_VERSION)/hexyl_$(HEXYL_VERSION)_amd64.deb
$(eval $(call install-dpkg,hexyl))

# fd
# ================================================================
.fd-url := https://github.com/sharkdp/fd/releases/download/v$(FD_VERSION)/fd_$(FD_VERSION)_amd64.deb
$(eval $(call install-dpkg,fd))
