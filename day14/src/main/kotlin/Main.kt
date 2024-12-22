package com.maddyguthridge.aoc2024

val VARIANCE_THRESHOLD = 400
val PART_2_ITERATIONS = 10000

fun part1(box: Position, robots: List<Robot>): Int {
    var quadrants = mutableListOf(0, 0, 0, 0)

    for (robot in robots) {
        var quadrant = robot.atTime(box, 100).quadrant(box)
        if (quadrant >= 0) {
            quadrants[quadrant]++
        }
    }

    // Multiply the quadrant counts
    return quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3]
}

fun part2(box: Position, robots: List<Robot>): Int {
    for (i in 1..PART_2_ITERATIONS) {
        var variance = Position.variance(robots.map { it.atTime(box, i) })
        if (variance.x < 400 && variance.y < VARIANCE_THRESHOLD) {
            return i
        }
    }
    error("No solution found for part 2. Try increasing the VARIANCE_THRESHOLD")
}

fun main(args: Array<String>) {
    var box = Position(args[0].toInt(), args[1].toInt())
    var robots: MutableList<Robot> = mutableListOf()

    try {
        while (true) {
            var line = readln()
            robots.add(Robot.fromString(line))
        }
    } catch (e: RuntimeException) {
        // EOF
    }

    println("Part 1: ${part1(box, robots)}")
    println("Part 2: ${part2(box, robots)}")
}
