#!/usr/bin/env bash

aptinstallifneed curl

mkdir -p ~/bin

curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo

chmod a+x ~/bin/repo
