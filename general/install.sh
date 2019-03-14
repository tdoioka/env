#!/bin/bash

sudo ls > /dev/null

source "$(realpath `dirname $0`/../lib/libs.sh)"

aptinstallifneed openssh-server
aptinstallifneed net-tools
aptinstallifneed tree
aptinstallifneed nkf
aptinstallifneed build-essential
