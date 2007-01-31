# noexcuses - http://raf.org/noexcuses/
#
# Copyright (C) 2007 raf <raf@raf.org>
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
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or visit http://www.gnu.org/copyleft/gpl.html
#
# 10070131 raf <raf@raf.org>

name := noexcuses
version := 0.1
mansect := 1
id := $(name)-$(version)
prefix := /usr
bindir := $(prefix)/bin
mandir := $(prefix)/man/man$(mansect)
vardir := /var/$(name)
docdir := $(prefix)/share/doc/$(name)
etcdir := /etc
defdir := $(etcdir)/default
conf := $(name).conf
init := $(name).init
initdef := $(init).def

help:
	@echo "This Makefile supports the following targets:"; \
	echo; \
	echo "    help           - show this help (default)"; \
	echo "    install        - install $(name) under $(prefix)"; \
	echo "    uninstall      - uninstall $(name) from $(prefix)"; \
	echo "    install-init   - install the $(init) bootscript"; \
	echo "    uninstall-init - uninstall the $(init) bootscript"; \
	echo "    install-html   - install the manpage as HTML"; \
	echo "    uninstall-html - uninstall the manpage as HTML"; \
	echo "    purge          - uninstall everything including $(vardir)"; \
	echo "    dist           - Create ../$(name)-$(version).tar.gz"; \
	echo

install:
	mkdir -p $(bindir)
	install -m 755 $(name) $(bindir)
	mkdir -p $(mandir)
	./$(name) -r > $(mandir)/$(name).$(mansect)
	mkdir -p $(vardir)
	chmod 1777 $(vardir)
	[ -s $(etcdir)/$(conf) ] || install -m 644 $(conf) $(etcdir)

uninstall:
	rm -f $(bindir)/$(name) $(mandir)/$(name).$(mansect)* $(etcdir)/$(conf)

install-init:
	install -m 755 $(init) /etc/init.d
	for lvl in 2 3 4 5; do [ -d /etc/rc$$lvl.d ] || continue; [ -x /etc/rc$$lvl.d/S99$(init) ] || ln -s ../init.d/$(init) /etc/rc$$lvl.d/S99$(init); done
	install -m 644 $(initdef) $(defdir)/$(init)

uninstall-init:
	rm -f /etc/init.d/$(init) /etc/rc[2-5].d/[SK][0-9][0-9]$(init) $(defdir)/$(init)

install-html:
	mkdir -p $(docdir)/html
	./$(name) -w > $(docdir)/html/$(name).$(mansect).html

uninstall-html:
	rm -rf $(docdir)

purge: uninstall uninstall-init uninstall-html
	rm -rf $(docdir) $(vardir)

dist:
	@src="`basename \`pwd\``"; cd ..; \
	[ "$$src" != "$(id)" -a ! -d "$(id)" ] && ln -s "$$src" "$(id)"; \
	tar chzf "$(id).tar.gz" --exclude=.svn "$(id)"; \
	[ -h "$(id)" ] && rm -f "$(id)"; \
	ls -l "$(id).tar.gz"; \
	tar tzvf "$(id).tar.gz"

# vi:set ts=4 sw=4:
