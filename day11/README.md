# Day11

A solution for day 11 in Elixir.

## Running

`mix run -- inputs/input.txt [number of iterations]`

Part 1: `mix run -- inputs/input.txt 25`

Part 2: `mix run -- inputs/input.txt 75`

## Remarks

Learning the basics of Elixir was very simple, but faltered somewhat when I
started trying to integrate it with the Mix build system. I struggled massively
with getting my app to start, with my issues compounded by the documentation,
which was unhelpful for helping me address the errors I encountered.

However, once I got the app working, Elixir was very pleasant to work with.
I especially love the `|>` operator, which made it easy to take any value and
put it through a pipeline. I wish I had more opportunity to test out the Beam
VM process system, as my app only really used one process for the main
algorithm and one for the cache.
