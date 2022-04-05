.POSIX:
.SUFFIXES:

PREFIX = /usr/local

bindir = $(PREFIX)/bin
libdir = $(PREFIX)/lib
datarootdir = $(PREFIX)/share
mandir = $(datarootdir)/man
man1dir = $(mandir)/man1

all: webfeeds webfeeds.1

webfeeds: webfeeds.in
webfeeds.1: webfeeds.1.in

install: all
	mkdir -p -- $(DESTDIR)$(bindir) $(DESTDIR)$(libdir)/webfeeds $(DESTDIR)$(man1dir)
	cp -- webfeeds $(DESTDIR)$(bindir)/webfeeds
	chmod -- +x $(DESTDIR)$(bindir)/webfeeds
	cp -- webfeeds.1 $(DESTDIR)$(man1dir)/webfeeds.1
	cp -- parse.xslt write.xslt $(DESTDIR)$(libdir)/webfeeds

clean:
	rm -f -- webfeeds webfeeds.1

.SUFFIXES: .in

.in:
	m4 -D M4_XSLTDIR=$(libdir)/webfeeds $< > $@
