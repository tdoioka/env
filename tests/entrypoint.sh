#!/bin/bash

# Change user:gropu to same as execution directory.
HOST_UID=${HOST_UID:-$(stat -c %u "$PWD")}
HOST_GID=${HOST_GID:-$(stat -c %g "$PWD")}

[[ $HOST_UID -ne $(id -u user) ]] \
  && usermod -u "$HOST_UID" -o -m user -d /home/user
[[ $HOST_GID -ne $(id -g user) ]] \
  && groupmod -g "$HOST_GID" user

# Copy test environment.
ln -s /work /home/user/lenv
cp -ra /work/ /home/user/env
for test in /work/tests/test*.sh; do
  install -m 755 $test /home/user/$(basename -s ".sh" "$test")
done
cd /home/user || exit

# Launch up new tty for emacsclient connection.
cat << __eof__ > /tmp/runscript
#!$SHELL
script -c 'exec $@' /dev/null
__eof__
chmod a+rx /tmp/runscript

exec /usr/sbin/gosu user /tmp/runscript
