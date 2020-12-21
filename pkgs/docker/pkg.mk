pkg-bdeps :=
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(call pkg-schedule,			\
		curl				\
		apt-transport-https		\
		ca-certificates			\
		gnupg-agent			\
		software-properties-common	\
	)
	$(log-post)

docker-gpg := $(pkg)/gpg
$(docker-gpg):
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o $@
	sudo apt-key add $@

$(pkg-update):
	$(log-pre)
	$(MAKE) $(docker-gpg)
	$(call pkg-addrepo,\
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(shell lsb_release -cs) \
		stable")
	$(call pkg-schedule,			\
		docker-ce			\
		docker-ce-cli			\
		containerd.io			\
	)
	$(log-post)

$(pkg-all):
	$(log-pre)
	sudo gpasswd -a $(shell id -un) docker
	$(log-post)
