#set document(
  title: [Advent of Code 2024 - Day 3],
  author: "Maddy Guthridge"
)

#align(center, text(24pt)[
  Advent of Code 2024 - Day 3
])


#let part_1(input) = {
  let mul_regex = regex("mul\([0-9]{1,3},[0-9]{1,3}\)")

  let working = []
  let total = 0

  let match_pos = input.position(mul_regex);
  while match_pos != none {
    working += [#input.slice(0, match_pos)]
    input = input.slice(match_pos)

    // Full mul expression
    let mul = input.find(mul_regex)

    let n1 = int(mul.find(regex("[0-9]{1,3}")))
    let n2 = int(mul.slice(mul.position(",")).find(regex("[0-9]{1,3}")))

    total += n1 * n2

    working += text(fill: blue)[*mul(#text(fill: red)[#n1],#text(fill: red)[#n2])*]

    // Slice from the remainder
    input = input.slice(mul.len())

    // Update match position before next iteration
    match_pos = input.position(mul_regex)
  }

  [
    Part 1: #total \
    \
    #working
  ]
}


#{
  let input = read("inputs/input.txt")

  part_1(input)
}
