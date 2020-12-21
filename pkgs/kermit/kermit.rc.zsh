# for zsh
function ker_echo() {
  echo set line $1
  echo set SPEED $2
  echo set stop-bits 1
  echo set flow-control none
  echo set parity none
  echo set carrier-watch off
  echo log session /tmp/kermit.$(date +%y%m%d_%H%M%S)
  echo c
}

function ker_help() {
  echo "ker [-h|<options>]"
  echo "  <options>=[<serialsoptions>][-b <baudrate>][-d]"
  echo "  <serialsoptions>=-s <tty-node> | [-u|-a][-n <num>]"
  echo
  echo "Which serial device node to connect:"
  echo "  -u : connect to /dev/ttyUSB*. (default)"
  echo "  -a : connect to /dev/ttyACM*."
  echo "  -n <num> : Specify node number to connect, if not set, select top of the sort order."
  echo "  -s <tty-node> : Specify tty node directly."
  echo "Other option:"
  echo "  -b <baudrate> : set baud rate to <baudrate>."
  echo "  -d : (dry-run) Show settings only."
  echo "  -h : Show this message."
}

function ker() {
  local ttytype=""
  local serial=""
  while getopts "uan:s:b:dh" opt; do
    case $opt in
      u ) ttytype=ttyUSB ;;
      a ) ttytype=ttyACM ;;
      n ) ttynum=$OPTARG ;;
      s ) serial=$OPTARG ;;
      b ) speed=$OPTARG ;;
      d ) dryrun=1 ;;
      h ) ker_help
	  return 0
	  ;;
    esac
  done
  # set serial
  if [[ -z "$serial" ]] ; then
    [[ -n "$ttytype" ]] || ttytype=ttyUSB
    if [[ -n "$ttynum" ]] ; then
      serial=/dev/$ttytype$ttynum
    else
      serial=$(find /dev/ -name "${ttytype}*" | head -n 1)
    fi
  fi
  if [[ -z "$serial" ]]; then
    echo "Not found tty node : /dev/${ttytype}${ttynum-any}"
    return 2
  else
    ls $serial >& /dev/null || {
      echo "Not foune tty node : $serial"
      return 2
    }
  fi
  # set speed
  if [[ -z "$speed" ]]; then
    speed=115200
  fi
  # connect
  ker_echo "$serial" "$speed"
  if [[ $dryrun != 1 ]]; then
    # If you want to use a different shell. Rewrite this command.
    # (For example, use mktemp and trap commands ...)
    kermit -y =(ker_echo "$serial" "$speed")
  fi
}
