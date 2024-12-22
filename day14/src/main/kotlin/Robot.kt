package com.maddyguthridge.aoc2024

class Robot(var start: Position, var velocity: Position) {
    fun atTime(box: Position, t: Int): Position {
        return (start + velocity * t) % box
    }

    companion object {
        fun fromString(line: String): Robot {
            var sections = line.split(" ")
            var position = Position.fromString(sections[0].replace("p=", ""))
            var velocity = Position.fromString(sections[1].replace("v=", ""))
            return Robot(position, velocity)
        }
    }
}
