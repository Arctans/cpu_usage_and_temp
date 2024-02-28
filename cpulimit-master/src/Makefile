# CC?=gcc
CC_TOOLS?=arm-linux-gnueabihf-gcc
CFLAGS?=-Wall -g -D_GNU_SOURCE
TARGETS=cpulimit
LIBS=list.o process_iterator.o process_group.o

UNAME := $(shell uname)

ifeq ($(UNAME), FreeBSD)
LIBS+=-lkvm
endif

all::	$(TARGETS) $(LIBS)

cpulimit:	cpulimit.c $(LIBS)
	$(CC_TOOLS) -o cpulimit cpulimit.c $(LIBS) $(CFLAGS)

process_iterator.o: process_iterator.c process_iterator.h
	$(CC_TOOLS) -c process_iterator.c $(CFLAGS)

list.o: list.c list.h
	$(CC_TOOLS) -c list.c $(CFLAGS)

process_group.o: process_group.c process_group.h process_iterator.o list.o
	$(CC_TOOLS) -c process_group.c $(CFLAGS)

clean:
	rm -f *~ *.o $(TARGETS)

