# Day 8 - Nim

A solution for Day 8, written in Nim.

## Running

`nim r main.nim < inputs/input.txt`

To compile in release mode:

`nim c -d:release main.nim`, then run with `./main < inputs/input.txt`

## Remarks

Overall, I enjoyed working in Nim. It has an excellent system for operator
overloading, which felt extremely intuitive to me, especially with the
functions being named with the actual operators. There were also a ton of
quality-of-life operators like `$` for stringifying things, which made me very
happy.

Additionally, the tutorials specifically tailored to users of other languages
(eg *Nim for Python Programmers*) were exceptional for getting up-and-running
quickly. More languages need onboarding documentation like this, although it
may have been easier to navigate if it were on a proper documentation site,
rather than a GitHub wiki.

Unfortunately there are a few downsides to working with Nim.

When you do something wrong, the error messages can be very unhelpful. I found
first-class iterators to be especially annoying, as calling them multiple times
behaved differently to when I accessed them from the global scope.

Additionally, I don't really enjoy the importing, which feels very implicit,
with imports feeling like they affect random built-in types (eg needing to
`import std/strutils` to access methods such as `.strip()` on strings). This
feels pretty implicit -- why can't those methods just be a part of the type by
default, since the compiler trims out unused methods anyway? Even still, this
is much better than having everything already be in the global scope like in
Julia.

The biggest gripe for me was the poor intellisense, which meant I had to
constantly task-switch to a web-browser to find documentation for things.

Honestly though, I really like how easy it was to produce a performant program
using Nim using high-level and extremely readable syntax such as Python-like
generator functions, and other goodies.

I may consider using Nim for projects where I want a reasonably-performant
language with high-level features, especially for comparatively quick tasks
where I don't want/need the insane levels of compiler checks in languages like
Rust.
