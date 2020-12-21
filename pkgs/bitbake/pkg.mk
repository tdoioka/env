pkg-bdeps := python
pkg-rdeps :=

$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(log-post)

$(pkg-update):
	$(log-pre)
	$(call pkg-schedule,			\
		gawk				\
		wget				\
		git-core			\
		diffstat			\
		unzip				\
		texinfo				\
		gcc-multilib			\
		build-essential			\
		chrpath				\
		socat				\
		cpio				\
		xz-utils			\
	     	debianutils			\
		iputils-ping			\
		libegl1-mesa			\
		libsdl1.2-dev			\
		xterm				\
		python3				\
		python3-pip			\
		python3-pexpect			\
		python3-git			\
		python3-jinja2			\
		pylint3				\
	)
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(SHRC)/bitbake.rc.sh
	$(log-post)
