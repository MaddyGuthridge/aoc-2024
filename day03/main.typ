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
  let part_1 = 0
  let part_2 = 0

  let mul_enabled = true

  let match_pos = input.position(mul_regex);
  while match_pos != none {
    let do_pos = input.position(regex("do\(\)"))
    let dont_pos = input.position(regex("don't\(\)"))

    // Enable or disable
    if (do_pos != none and do_pos < match_pos) {
      mul_enabled = true
    }
    if (dont_pos != none and dont_pos < match_pos) {
      // Only disable if it was earlier than the enable command (if there is
      // one)
      if (do_pos == none or do_pos > dont_pos) {
        mul_enabled = false
      }
    }

    working += [#input.slice(0, match_pos)]
    input = input.slice(match_pos)

    // Full mul expression
    let mul = input.find(mul_regex)

    let n1 = int(mul.find(regex("[0-9]{1,3}")))
    let n2 = int(mul.slice(mul.position(",")).find(regex("[0-9]{1,3}")))

    part_1 += n1 * n2
    if (mul_enabled) {
      part_2 += n1 * n2
      working += text(fill: blue)[*mul(#text(fill: red)[#n1],#text(fill: red)[#n2])*]
    } else {
      working += text(fill: gray)[*mul(#n1,#n2)*]
    }


    // Slice from the remainder
    input = input.slice(mul.len())

    // Update match position before next iteration
    match_pos = input.position(mul_regex)
  }

  [
    Part 1: #part_1 \
    Part 2: #part_2 \
    \
    #working
  ]
}


#{
  let input = read("inputs/input.txt")

  part_1(input)
}
