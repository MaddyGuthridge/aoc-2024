# Day 14 - Kotlin

A solution for day 14, written in Kotlin.

## Running

`gradle run --args="101 103" < inputs/input.txt`

## Remarks

One key frustration for me was the poor language support in VS Code. I was
unable to get reasonable editor suggestions, with almost all of my functions
causing VS Code to complain about incorrect compilation versions, and all my
calls to built-in functions and methods (eg `String::toInt` and `println`) were
not found by the language server.

I tried to fix this by setting up a project using the `gradle` build system,
which only caused more issues -- VS Code's gradle extension repeatedly tried to
download Gradle 6.4, rather than using the configured version (8.8), so I was
only able to compile the application from the command-line, and not using VS
Code's run and debug tools.

Additionally, Gradle had some very confusing defaults, with `stdin` not being
forwarded to the process by default, and requiring an `--args` flag to specify
program arguments (rather than just preceding them with a `--` like in most
build systems).

As such, I found working with Kotlin to be extremely frustrating and tedious,
especially compared to how excellent it was to work with Dart (aside from
installing it).

I understand that these issues could be mostly addressed by using a different
editor such as Fleet or IntelliJ, but I do not think that a programming
language can be considered accessible to new developers if it cannot be used
within their preferred development environment. I have spent a lot of time
adjusting VS Code's settings to match my needs, so needing to use an entirely
different IDE just for a one-off language is not something I (or other
developers) would be enthusiastic about.

## Part 2

I was expecting a similar problem to Day 13 (where the number was increased),
so I was thrown off, especially given the imprecise nature of the question.

Eventually, I decided
