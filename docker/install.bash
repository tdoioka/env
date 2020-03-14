#!/bin/bash

set_install_env

# see also: https://docs.docker.com/install/linux/docker-ce/ubuntu/

type -p docker >& /dev/null || {
    sudo groupadd docker
    sudo gpasswd -a $USER docker

    aptinstallifneed apt-transport-https \
		     ca-certificates \
		     curl \
		     gnupg-agent \
		     software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    [[ -n "$(uname -a | grep x86_64)" ]] && {
	sudo add-apt-repository \
	     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	     $(lsb_release -cs) \
 	     stable"
    }
    sudo apt update

    aptinstallifneed docker-ce \
		     docker-ce-cli \
		     containerd.io
}
