all:      lpc21isp

GLOBAL_DEP  = adprog.h lpc21isp.h lpcprog.h lpcterm.h
CC = gcc

MACHINE = $(shell uname -m)

ifneq ($(findstring(freebsd, $(OSTYPE))),)
CFLAGS+=-D__FREEBSD__
endif

ifeq ($(OSTYPE),)
OSTYPE		= $(shell uname)
endif

ifneq ($(findstring Darwin,$(OSTYPE)),)
CFLAGS+=-D__APPLE__
# Use LLVM on newer Mac OS X
CC = cc
# -static does now longer work (easily) at newer versions of Mac OS X: Use the default (dynamic)
# See e.g. http://stackoverflow.com/questions/844819/how-to-static-link-on-os-x and
# https://developer.apple.com/library/ios/#qa/qa1118/_index.html
else
CFLAGS+=-static
endif

CFLAGS	+= -Wall
ifeq ($(MACHINE),armv6l)
CFLAGS+=-D__raspi__
endif

adprog.o: adprog.c $(GLOBAL_DEP)
	$(CC) $(CDEBUG) $(CFLAGS) -c -o adprog.o adprog.c

lpcprog.o: lpcprog.c $(GLOBAL_DEP)
	$(CC) $(CDEBUG) $(CFLAGS) -c -o lpcprog.o lpcprog.c

lpcterm.o: lpcterm.c $(GLOBAL_DEP)
	$(CC) $(CDEBUG) $(CFLAGS) -c -o lpcterm.o lpcterm.c

lpc21isp: lpc21isp.c adprog.o lpcprog.o lpcterm.o $(GLOBAL_DEP)
	$(CC) $(CDEBUG) $(CFLAGS) -o lpc21isp lpc21isp.c adprog.o lpcprog.o lpcterm.o

clean:
	$(RM) adprog.o lpcprog.o lpcterm.o lpc21isp
