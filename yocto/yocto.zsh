alias bb='bitbake'
function bbc() {
    for rr in $@; do
	echo "@@@@ bitbake -c clean $rr"
	bitbake -c clean $rr || break
    done
}
function bbca() {
    for rr in $@; do
	echo "@@@@ bitbake -c cleanall $rr"
	bitbake -c cleanall $rr || break
    done
}
function bbr() {
    echo "@@@@ bitabke -c clean $1 && bitbake $@"
    bitbake -c clean $1 && bitbake $@
}
function bbcr() {
    echo "@@@@ bitabke -c cleanall $1 && bitbake $@"
    bitbake -c cleanall $1 && bitbake $@
}
function rmbuild() {
    if [ -n "${BUILDDIR}" ]; then
	echo "rm -rf ${BUILDDIR}/{tmp,cache}"
    fi
    rm -rf ${BUILDDIR}/{tmp,cache}
}
function bbenv() {
    echo "@@@@ bitbake -e $1 > $1.env.py"
    bitbake -e $1 > $1.env.py
}
alias bbls='bitbake-layers'
alias bbsr='bitbake-layers show-recipes'
