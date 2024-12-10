# Day 6 - Zig

A solution for Day 6, implemented in Zig.

## Running

1. Compile: `zig build-exe -O ReleaseFast main.zig`
2. Run: `./main < inputs/input.txt`

Or (if you want to run in debug mode, simply `zig run main.zig`).

## Remarks

The explicit control over all allocations is very cool, and this definitely
felt like a much more-powerful C as a result, with a few hints of Rust creeping
in. However, the constant need to be explicit, never relying on syntactic sugar
to simplify complex operations made everything feel comparatively verbose.

For projects where such a high level of control over memory is needed (perhaps
an OS kernel or a game engine), Zig looks incredible, but its comparative
complexity makes it feel a little overwhelming for most programming tasks.

One major source of frustration for me was ZLS (Zig Language Server), which was
consistently unreliable, frequently guessing types incorrectly, which caused
huge amounts of confusion, as it would insist that 2D `ArrayList`s were
1-dimensional, meaning I would get values of `unknown` type on the inner loop.
If I want to use Zig for any kind of meaningful project, I will need a better
language server, as the often-incorrect hints were even worse than no hints.

Often, I led myself astray by assuming that the code I was writing was correct,
as the errors were obscured by other (seemingly smaller) errors. For example,
an unused variable in `main` being shown, but an obvious type error not being
detected until the unused variable issue is resolved. Given the poor
language-server support, the Zig compiler needs to show all errors in one pass
if I am to work with it efficiently.

Part of this problem is likely to do with Zig's heavy use of meta-programming,
which is used to implement generics (which are just functions that produce a
`type`). While this is neat, and I am very impressed that such a powerful and
flexible system can exist in a compiled language, far better static analysis is
needed to achieve solid editor support as a result.

Overall though, I think Zig is a language with a lot of potential to be an
excellent low-level programming language. Once I got it to compile, the code
executed quickly, and almost entirely without runtime errors. Perhaps with
better compiler outputs, Zig could give me the same levels of "if it compiles
it works" confidence that Rust does, which is a huge compliment. I'm very
interested to see how Zig develops over time.
