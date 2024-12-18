import 'package:day12/farm_map.dart';

enum Direction {
  up,
  down,
  left,
  right;

  static List<Direction> all() {
    return [Direction.up, Direction.down, Direction.left, Direction.right];
  }
}

/// Represents a point within the FarmMap
class Position {
  FarmMap map;
  int row;
  int col;

  Position(this.map, this.row, this.col);

  Position operator +(Direction d) {
    switch (d) {
      case Direction.up:
        return Position(map, row - 1, col);
      case Direction.down:
        return Position(map, row + 1, col);
      case Direction.left:
        return Position(map, row, col - 1);
      case Direction.right:
        return Position(map, row, col + 1);
    }
  }

  @override
  String toString() {
    return "($row, $col)";
  }

  /// Yields all neighbouring positions, whether they are valid or not.
  Iterable<Position> neighbours() sync* {
    for (final d in Direction.all()) {
      yield this + d;
    }
  }
}
