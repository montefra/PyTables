# This Makefile is only intended to prepare for distribution the PyTables
# sources exported from a repository.  For building and installing PyTables,
# please use ``setup.py`` as described in the ``README.txt`` file.

VERSION = $(shell cat VERSION)
SRCDIRS = src doc
PYTHON = python
GENERATED = ANNOUNCE.txt
OPT = PYTHONPATH=$(CURDIR)


.PHONY:		all dist clean distclean html

all:		$(GENERATED)
	$(PYTHON) setup.py build_ext --inplace
	for srcdir in $(SRCDIRS) ; do $(MAKE) -C $$srcdir $(OPT) $@ ; done

dist:		all
	$(PYTHON) setup.py sdist
	cd dist && md5sum tables-$(VERSION).tar.gz > pytables-$(VERSION).md5 && cd -
	cp RELEASE_NOTES.txt dist/RELEASE_NOTES-$(VERSION).txt
	for srcdir in $(SRCDIRS) ; do $(MAKE) -C $$srcdir $(OPT) $@ ; done

clean:
	rm -rf MANIFEST build dist tmp
	rm -f $(GENERATED) tables/*.so a.out
	find . '(' -name '*.py[co]' -o -name '*~' ')' -exec rm '{}' ';'
	for srcdir in $(SRCDIRS) ; do $(MAKE) -C $$srcdir $(OPT) $@ ; done

distclean:	clean
	for srcdir in $(SRCDIRS) ; do $(MAKE) -C $$srcdir $(OPT) $@ ; done
	rm -f tables/_comp_*.c tables/*Extension.c
	#git clean -fdx

html:
	$(PYTHON) setup.py build_ext --inplace
	$(MAKE) -C doc $(OPT) html

%:		%.in VERSION
	cat "$<" | sed -e 's/@VERSION@/$(VERSION)/g' > "$@"
