# Day 9 Makefile
# Derived from UNSW COMP2521 Makefiles

CC = clang
CFLAGS = -Wall -Wvla -Werror

########################################################################

.PHONY: asan msan nosan release

asan: CFLAGS += -g -fsanitize=address,leak,undefined
asan: all

msan: CFLAGS += -g -fsanitize=memory,undefined -fsanitize-memory-track-origins
msan: all

nosan: all

release: CFLAGS += -O2
release: all

########################################################################

.PHONY: all
all: main.c
	$(CC) $(CFLAGS) main.c -o main

.PHONY: clean
clean:
	rm -f main
