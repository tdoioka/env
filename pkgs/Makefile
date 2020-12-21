.DEFAULT_GOAL := all
# DEBUG=y

include base.mk


mk=$(wildcard */pkg.mk)
lnk=$(mk:%/pkg.mk=%.mk)
$(lnk): %.mk: %/pkg.mk
	ln -s $< $@
.PHONY: edit clean.edit
edit: $(lnk)
clean.edit:
	-rm -f $(lnk)
