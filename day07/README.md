# Day 7 - HolyC

A solution for Day 8, written in HolyC.

## Running

1. Install the [HolyC Compiler](https://holyc-lang.com/install)
2. `hcc -o bin/main src/main.hc`
3. `./bin/main inputs/input.txt`

## Remarks

This was a significant challenge, not necessarily due to HolyC being a bad
language, but primarily due to poor documentation. The
[compiler I used](https://github.com/Jamesbarford/holyc-lang) was beta software
with numerous poorly-documented features and many inscrutable errors. Of
course, this is completely ok, as it seems to be a hobby project for a solo
developer.

I didn't end up testing on TempleOS like I originally hoped, but I limited
myself to writing most low-level code myself as it appeared that the TempleOS
standard library differed significantly to the HolyC-Lang standard library.

While my experience with this language was relatively poor, especially compared
to Typst (day 3) and Zig (day 6), HolyC and TempleOS is still an incredible
feat of software engineering, and a huge source of inspiration for my to make
my own programming languages in the future.
