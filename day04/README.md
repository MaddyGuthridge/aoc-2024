# Day 4 - Julia

An implementation created in the Julia programming language.

## Running

1. Install Julia
2. `julia main.jl inputs/input.txt`

## Remarks

I found Julia's type system quite confusing. Perhaps I was misunderstanding
their documentation, but I simply couldn't find a way to make my functions
cleanly accept a `Vector{AbstractString}` if the strings were of `SubString`.
Perhaps this is due to the `Vector` type having some covariance/contravariance
going on, and I need to use a different type. Either way, the lack of a clear
error for this case was a little frustrating.

Even though my functions still would have worked without type annotations, my
habits from Python (where I type-annotate everything for better suggestions)
have clearly carried over, even though these aren't nearly as useful in Julia
where every function appears in the global scope rather than encapsulated with
their associated objects. Honestly, this global-scoping is quite unpleasant
imo, since it means that the global namespace is incredibly polluted, making it
much harder to find actions that can be done on specific objects. Proper
encapsulation of methods is important for reduced working memory load for
programmers using the language, and as someone who struggles with a limited
working memory, I don't think I plan on learning more Julia.
