#!/bin/bash

set_install_env

aptinstallifneed git

linkifneed ${S}/gitconfig ~/.gitconfig
