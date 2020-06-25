# noexcuses - runs important cronjobs until they succeed
#
# Copyright (C) 2007-2008, 2020 raf <raf@raf.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <https://www.gnu.org/licenses/>.
#
# 20200625 raf <raf@raf.org>

NAME := noexcuses
VERSION := 1.0
DIST := $(NAME)-$(VERSION)
DISTDIR := ../$(DIST)
DISTFILE := ../$(DIST).tar.gz

# PREFIX := $(DESTDIR)/usr
PREFIX := $(DESTDIR)/usr/local
BINDIR := $(PREFIX)/bin
MANDIR := $(shell [ -d $(PREFIX)/share/man ] && echo $(PREFIX)/share/man/man1 || echo $(PREFIX)/man/man1)
VARDIR := $(shell [ -d $(DESTDIR)/var/run ] && echo $(DESTDIR)/var/run/$(NAME) || echo $(DESTDIR)/var/$(NAME))
ifeq ($(PREFIX),$(DESTDIR)/usr/local)
	ETCDIR := $(PREFIX)/etc
else
	ETCDIR := $(DESTDIR)/etc
endif
DEFDIR := $(ETCDIR)/default

BINFILES := $(NAME)
MANFILES := $(NAME).1.gz
HTMLFILES := $(NAME).1.html
CONFFILE := $(NAME).conf
INITFILE := $(NAME).init
INITDEFS := $(NAME).init.def

DISTFILES := \
	README.md CHANGELOG COPYING INSTALL LICENSE Makefile \
	$(BINFILES) $(MANFILES) $(HTMLFILES) \
	$(CONFFILE) $(INITFILE) $(INITDEFS) run-tests

INSTFILES := \
	$(patsubst %, $(BINDIR)/%, $(BINFILES)) \
	$(patsubst %, $(MANDIR)/%, $(MANFILES))

CONF_INSTFILES := \
	$(ETCDIR)/$(CONFFILE) \
	$(VARDIR)

INIT_INSTFILES := \
	$(ETCDIR)/init.d/$(NAME) \
	$(DEFDIR)/$(NAME)

help:
	@echo "This Makefile supports the following targets:"; \
	echo; \
	echo "  help           - Print this help (default)"; \
	echo "  test           - Test $(NAME)"; \
	echo "  install        - Install $(NAME) under $(PREFIX)"; \
	echo "  uninstall      - Uninstall $(NAME) from $(PREFIX)"; \
	echo "  install-init   - Install the sysvinit bootscripts (optional)"; \
	echo "  uninstall-init - Uninstall the sysvinit bootscripts"; \
	echo "  purge          - Uninstall everything including $(VARDIR)"; \
	echo "  list           - List installed files/directories"; \
	echo "  man            - Create the nroff manpage"; \
	echo "  clean-man      - Delete the nroff manpage"; \
	echo "  html           - Create the html manpage"; \
	echo "  clean-html     - Delete the html manpage"; \
	echo "  clean          - Delete the nroff/html manpages"; \
	echo "  clobber        - Same as clean"; \
	echo "  distclean      - Same as clean"; \
	echo "  dist           - Create the distribution tarball $(DISTFILE)"; \
	echo

test:
	./run-tests

check:
	./run-tests

install: $(INSTFILES) $(CONF_INSTFILES)

uninstall:
	rm -rf $(INSTFILES)

install-init: $(INIT_INSTFILES)
	for lvl in 2 3 4 5; do [ -d $(ETCDIR)/rc$$lvl.d ] || continue; [ -x $(ETCDIR)/rc$$lvl.d/S99$(NAME) ] || ln -s ../init.d/$(NAME) /etc/rc$$lvl.d/S99$(NAME); done

uninstall-init:
	rm -f $(INIT_INSTFILES) /etc/rc[2-5].d/[SK][0-9][0-9]$(NAME)

purge: uninstall uninstall-init
	rm -rf $(CONF_INSTFILES)

list:
	ls -laps $(INSTFILES) $(CONF_INSTFILES) $(INIT_INSTFILES)

$(BINDIR)/%: %
	[ -d $(BINDIR) ] || mkdir -m 755 -p $(BINDIR)
	install -m 755 $< $@

$(MANDIR)/%: %
	[ -d $(MANDIR) ] || mkdir -m 755 -p $(MANDIR)
	install -m 644 $< $@

$(VARDIR):
	[ -d $(VARDIR) ] || mkdir -m 1777 -p $(VARDIR)

$(ETCDIR)/%: %
	[ -d $(ETCDIR) ] || mkdir -m 755 -p $(ETCDIR)
	install -m 644 $< $@

$(ETCDIR)/init.d/%: %.init
	[ -d $(ETCDIR)/init.d ] || mkdir -m 755 -p $(ETCDIR)/init.d
	install -m 755 $< $@

$(DEFDIR)/%: %.init.def
	[ -d $(DEFDIR) ] || mkdir -m 755 -p $(DEFDIR)
	install -m 644 $< $@

man: $(MANFILES)

%.1.gz: %
	./$< -r | gzip > $@

clean-man:
	rm -f $(MANFILES)

html: $(HTMLFILES)

%.1.html: %
	./$< -w > $@

clean-html:
	rm -f $(HTMLFILES)

clean: clean-man clean-html

clobber: clean

distclean: clean

dist: man html
	mkdir $(DISTDIR)
	cp -p $(DISTFILES) $(DISTDIR)
	tar czf $(DISTFILE) $(DISTDIR)
	rm -rf $(DISTDIR)
	tar tzvf $(DISTFILE)

# vi:set ts=4 sw=4:
