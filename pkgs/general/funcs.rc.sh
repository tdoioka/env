#!/bin/bash

if ! type addpath &>/dev/null; then
  function addpath() {
    if [[ ! ' '$(echo $PATH | tr ':' ' ')' ' =~ ' '$1' ' ]]; then
      export PATH="$1:$PATH"
    fi
  }
fi
