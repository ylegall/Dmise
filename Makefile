
NAME=prototype
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

ARGS=

.PHONY : clean

all:
	$(DC) $(FILES) $(DFLAGS) -I$(INCDIR) -Isrc $(LDFLAGS) -of$(NAME)
#	$(DC) $(SRCDIR)/main.d $(DFLAGS) -I$(INCDIR) $(LDFLAGS)

run:
	./$(NAME) $(ARGS)

clean:
	rm -rf *.o
