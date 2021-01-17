#!/bin/bash

ssh-agent-start() {
  local ssh=$HOME/.ssh
  local sock=$ssh/sock
  local apidf=$ssh/agent-pid

  # When .ssh is not exists create.
  [[ -d "$ssh" ]] || install -d -m 0700 "$ssh"
  # When apidf is not exists create.
  if [[ ! -f $apidf ]]; then
    touch "$apidf"
    chmod 0700 "$apidf"
  fi
  # Read apid.
  local apid
  apid="$(cat "$apidf")"
  # Check exists agent, and setup.
  if [[ -n "$apid" ]] && kill -0 "$apid" &> /dev/null ; then
    # ssh-agent process exists, configuration environment.
    export SSH_AGENT_PID=$apid
    export SSH_AUTH_SOCK=$sock
  else
    # Start ssh-agent. And then, store PID to agent-pid,
    # create symlink to socket under .ssh.
    eval "$(ssh-agent -s)" &> /dev/null
    flock "$apidf" -c "echo $SSH_AGENT_PID > $apidf"
    ln -snf "$SSH_AUTH_SOCK" "$sock"
    export SSH_AUTH_SOCK="$sock"
  fi
}
ssh-agent-start
