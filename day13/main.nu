# Main entrypoint to the day 13 solution
def main [file: path] {
    let claws = open $file
    | split row "\n\n"
    | each {parse-claw}
    | flatten
    # I don't know why I needed to flatten this, but for some reason this is
    # producing a list of single-element tables, rather than just one table.

    print $claws

    print $"Part 1: ($claws | part-1)"
    print $"Part 2: ($claws | part-2)"
}

# Solve part 1 given a table of claws
def part-1 [] {
    each {|claw| solve-claw $claw}
    | math sum
}

# Solve part 2 given a table of claws
# Since we solved the linear algebra, our code is just as fast!
def part-2 [] {
    update px {|e| $e.px + 10000000000000}
    | update py {|e| $e.py + 10000000000000}
    | each {|claw| solve-claw $claw}
    | math sum
}

# Parses the input text of a single claw
#
# Returns a record with its data in the form `{ ax, ay, bx, by, px, py }`
def parse-claw [] list -> table {
    parse "Button A: X+{ax}, Y+{ay}\nButton B: X+{bx}, Y+{by}\nPrize: X={px}, Y={py}"
    | update-all {|value| $value | into int }
}

# Update all given entries in a record using the given function
#
# Imo this should probably be built-in but I couldn't find it in the docs
def update-all [fn: closure] table -> table {
    each {|rec|
        $rec | transpose key value
        | each {|entry| { $entry.key: (do $fn $entry.value) } }
        | reduce {|el, acc| { ...$el, ...$acc } }
    }
}

# Returns the cost to win the given claw machine.
#
# In order to reach the prize P, the two button vectors must be applied in some
# combination m*A + n*B = P. This gives us a simultaneous equations:
#
# * $m * Ax + n * Bx = Px$
# * $m * Ay + n * Bx = Px$
#
# Solving for m and n, we get the following:
#
# ```txt
# ⎧    -bx⋅py + by⋅px     ax⋅py - ay⋅px ⎫
# ⎨ m: ──────────────, n: ───────────── ⎬
# ⎩    ax⋅by - ay⋅bx      ax⋅by - ay⋅bx ⎭
# ```
#
# We can use these to calculate the total cost `3 * m + n`
def solve-claw [claw: record] {
    let m = (
        ($claw.by * $claw.px - $claw.bx * $claw.py)
        / ($claw.ax * $claw.by - $claw.ay * $claw.bx)
    )
    let n = (
        ($claw.ax * $claw.py - $claw.ay * $claw.px)
        / ($claw.ax * $claw.by - $claw.ay * $claw.bx)
    )

    # If they don't round evenly, then our result is invalid, as a fractional
    # number of button-pushes would be needed
    if ($m | math round) != $m {
        return null
    }
    if ($n | math round) != $n {
        return null
    }

    # Cost
    3 * $m + $n
}
