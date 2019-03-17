
# store drives to named directory
for ii in /cygdrive/*
do
    # if /cygdrive/c then C=/cygdrive/c
    # it is named path ~C
    eval "${ii:t:u}=${ii}"
done

# explorer
function ex() { explorer $(cygpath -w $1); return $? }

# internet explorer
function ie() {
    if [[ $# -eq 0 ]]
    then
	iexplorer &
    else
	iexplorer $(cygpath -w $1) &
    fi
}

# hamana
function h() {
    hamana.exe $(cygpath -w $1) &
}
