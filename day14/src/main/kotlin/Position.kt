package com.maddyguthridge.aoc2024

class Position(var x: Int, var y: Int) {
    /**
     * Returns the quadrant that the position belongs to within the given box.
     *
     * 0-3 == a quadrant
     * -1 == not in a quadrant
     */
    fun quadrant(box: Position): Int {
        var midX = box.x / 2
        var midY = box.y / 2

        if (x < midX) {
            if (y < midY) {
                return 0
            } else if (y > midY) {
                return 2
            }
        } else if (x > midX) {
            if (y < midY) {
                return 1
            } else if (y > midY) {
                return 3
            }
        }
        return -1
    }

    fun deviation(average: Position): Position {
        var devX = Math.pow((x - average.x).toDouble(), 2.toDouble()).toInt()
        var devY = Math.pow((y - average.y).toDouble(), 2.toDouble()).toInt()
        return Position(devX, devY)
    }

    override fun toString(): String {
        return "($x,$y)"
    }

    operator fun plus(other: Position): Position {
        return Position(x + other.x, y + other.y)
    }

    operator fun times(scale: Int): Position {
        return Position(x * scale, y * scale)
    }

    operator fun div(scale: Int): Position {
        return Position(x / scale, y / scale)
    }

    operator fun rem(box: Position): Position {
        var newX = x % box.x
        var newY = y % box.y
        return Position(
                // The wrap-around behaviour of the modulo operator is kinda
                // yuck
                if (newX >= 0) newX else newX + box.x,
                if (newY >= 0) newY else newY + box.y
        )
    }

    companion object {
        fun fromString(coord: String): Position {
            var coords = coord.split(",").toTypedArray()
            return Position(coords[0].toInt(), coords[1].toInt())
        }

        fun average(positions: List<Position>): Position {
            var total = Position(0, 0)

            for (pos in positions) {
                total += pos
            }

            return total / positions.size
        }

        fun variance(positions: List<Position>): Position {
            var average = average(positions)

            var total = Position(0, 0)

            for (pos in positions) {
                total += pos.deviation(average)
            }

            return total / positions.size
        }
    }
}
