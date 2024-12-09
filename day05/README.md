# Day 5 - Prolog

This is my day 5 solution, written in Prolog.

## Running

1. Install SWI-Prolog
2. `swipl -s main.pl -- [1|2] [input file]`

## Remarks

Getting the actual logic of the program working was awesome! Just by defining
the list of "before rules", testing the sequences became extremely easy.

The difficulty arose from the string parsing, which was horrifically difficult.

For part 2, a more efficient solution would be to use a "topological sort", but
implementing that in a prologgy kind of way sounded difficult. Instead, you
just need 64GB of RAM and an absurd amount of time to solve part 2.
