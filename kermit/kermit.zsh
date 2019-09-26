function ker_echo()
{
    echo set line $1
    echo set SPEED 115200
    echo set stop-bits 1
    echo set flow-control none
    echo set parity none
    echo set carrier-watch off
    echo c
}
function ker() {
    local _tg="$(/bin/ls /dev/ttyUSB*)"
    if [[ $# -ne 0 ]]
    then
        _tg=/dev/ttyUSB$1
    fi
    if [[ ! -e $_tg ]]
    then
        echo "#### not exist $_tg" >&2
        return 1
    fi
    ker_echo $_tg
    kermit -y =(ker_echo $_tg)
}
