
NAME=dmise
DC=dmd -I$(SRCDIR) -I$(INCDIR)
INCDIR=include
LIBDIR=lib
SRCDIR=src
BINDIR=bin

LIBS=$(shell echo lib/*.a)
LDFLAGS=-L-L$(LIBDIR) -L-lGL -L-lSDL2 $(patsubst lib/lib%.a,-L-l%,$(LIBS))
#DFLAGS=-release
DFLAGS=-debug -g -gc -version=textQualityHigh -unittest

#FILES=$(shell echo $(SRCDIR)/*.d)
FILES=$(shell find $(SRCDIR) -name \*.d)
OBJS=$(patsubst %.d,%.o,$(FILES))

ARGS=

.PHONY : clean

all : $(NAME)

%.o : %.d
	$(DC) $(DFLAGS) -c $< -of$@

$(NAME) : $(OBJS)
	$(DC) $(DFLAGS) $(LDFLAGS) $^ oglconsole/oglconsole-sdl.o -of$@

run:
	./$(NAME) $(ARGS)

test:
	rdmd -I$(SRCDIR) -I$(INCDIR) test.d src/dmise/util/vector.d src/dmise/util/list.d src/dmise/util/properties.d -unittest

clean:
	rm -rf $(OBJS) $(NAME)

listfiles ::
	@echo $(FILES)

listobjs ::
	@echo $(OBJS)

listlibs ::
	@echo $(LIBS)

showldflags ::
	@echo $(LDFLAGS)
