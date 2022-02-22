.POSIX:
.SUFFIXES:

PREFIX = /usr/local
bindir = /bin
libdir = /lib
datarootdir = /share
mandir = /man
man1dir = /man1

all: webfeeds webfeeds.1

webfeeds: webfeeds.in
webfeeds.1: webfeeds.1.in

install: all
	mkdir -p -- $(DESTDIR)$(PREFIX)$(bindir) $(DESTDIR)$(PREFIX)$(libdir)/webfeeds $(DESTDIR)$(PREFIX)$(datarootdir)$(mandir)$(man1dir)
	cp -- webfeeds $(DESTDIR)$(PREFIX)$(bindir)/webfeeds
	chmod -- +x $(DESTDIR)$(PREFIX)$(bindir)/webfeeds
	cp -- webfeeds.1 $(DESTDIR)$(PREFIX)$(datarootdir)$(mandir)$(man1dir)/webfeeds.1
	cp -- parse.xslt write.xslt $(DESTDIR)$(PREFIX)$(libdir)/webfeeds

clean:
	rm -f -- webfeeds webfeeds.1

.SUFFIXES: .in

.in:
	m4 -D M4_XSLTDIR=$(PREFIX)$(libdir)/webfeeds $< > $@
