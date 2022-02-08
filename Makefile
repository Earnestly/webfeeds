.POSIX:
.SUFFIXES:

PREFIX = /usr/local
bindir = /bin
datarootdir = /share
mandir = /man
man1dir = /man1

install:
	install -Dm0755 webfeeds $(DESTDIR)$(PREFIX)$(bindir)/webfeeds
	install -Dm0644 webfeeds.1 $(DESTDIR)$(PREFIX)$(datarootdir)$(mandir)$(man1dir)/webfeeds.1
