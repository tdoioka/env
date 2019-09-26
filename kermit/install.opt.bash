#!/usr/bin/env bash

aptinstallifneed ckermit
sudo usermod -a -G dialout $(whoami)

linkifneed "${S}/kermit.zsh" ~/.shrc.d/kermit.zsh
