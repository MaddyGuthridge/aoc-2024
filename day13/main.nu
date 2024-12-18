# Main entrypoint to the day 13 solution
def main [file: path] {
    let claws = open $file
    | split row "\n\n"
    | each {parse-claw}

    print $"Part 1: ($claws | part-1)"
    print $"Part 2: ($claws | part-2)"
}

def part-1 [] {
    each {|claw| solve-claw $claw}
    | math sum
}

def part-2 [] {
    update px {|e| $e.px + 10000000000000}
    | update py {|e| $e.py + 10000000000000}
    | each {|claw| solve-claw $claw}
    | math sum
}

# Parses the input text of a single claw
#
# Returns a record with its data in the form `{ ax, ay, bx, by, px, py }`
def parse-claw [] {
    parse "Button A: X+{ax}, Y+{ay}\nButton B: X+{bx}, Y+{by}\nPrize: X={px}, Y={py}"
    | transpose name value
    | each {|key| { $key.name: ($key.value | into int) } }
    | reduce {|el, acc| { ...$el, ...$acc } }
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
def solve-claw [claw] {
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
