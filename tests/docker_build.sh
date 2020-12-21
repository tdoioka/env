#!/usr/bin/env bash

main() {
  local cmd=${1//*.}
  local name=${1//.*}
  local base=${2}

  case "$cmd" in
    "build" )
      if [[ -z "$(docker image ls -q "$name")" ]]; then
        docker build -q -t "$name" --build-arg BASE_IMAGE="$base" .
      fi
      ;;
    "clean" )
      if [[ -n "$(docker image ls -q "$name")" ]]; then
        docker rmi "$name"
      fi
      ;;
  esac
}
(cd "$(dirname "$0")" && main "$@")
