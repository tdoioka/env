.DEFAULT_GOAL := all
# DEBUG=y

include base.mk

# Edit mode
# ................................................................
mkfiles=$(wildcard */pkg.mk)
mklnks=$(mkfiles:%/pkg.mk=%.mk)
$(mklnks): %.mk: %/pkg.mk
	ln -s $< $@

.PHONY: edit clean.edit
edit: $(mklnks)
clean.edit:
	-rm -f $(mklnks)
