
DC=dmd
INCDIR=include
LIBDIR=lib
SRCDIR=src/prototype
BINDIR=bin

LDFLAGS=-L-L$(LIBDIR)
#DFLAGS=-release
DFLAGS=-debug

FILES=$(shell echo $(SRCDIR)/*.d)
OBJS=$(FILES,.d=.o)

.PHONY : clean

all:
	$(DC) $(FILES) $(DFLAGS) -I$(INCDIR) -Isrc $(LDFLAGS) -ofprototype
#	$(DC) $(SRCDIR)/main.d $(DFLAGS) -I$(INCDIR) $(LDFLAGS)

run:


clean:
	rm -rf *.o
