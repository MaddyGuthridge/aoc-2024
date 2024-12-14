# Day 9 - C

A solution for day 9, written in C.

## Running

Compile using `make`, or `make release` for release mode.

Then run `./main < inputs/input.txt`

## Remarks

As always, C has unparalleled performance, with my comparatively-unoptimised
part 2 solution running in barely 0.2 seconds. As expected, I encountered
extremely frequent memory-safety errors which would not have been possible in a
memory-safe language like Rust. These were comparatively easy to
diagnose and debug by making use of LLVM's sanitizers, but even then, I would
not feel confident writing production code in C, as these types of memory
errors are almost impossible to avoid, even when working far more carefully
than I did. Languages such as Zig and Rust offer a far safer and more-modern
alternative to C, and I would much rather use those.
