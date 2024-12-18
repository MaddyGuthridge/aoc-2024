import 'package:day12/farm_mask.dart';
import 'package:day12/position.dart';

/// Map of the farmland
class FarmMap {
  late List<String> _map;
  late FarmMask visited;

  FarmMap(String input) {
    _map = input.trim().split('\n');
    visited = FarmMask(this);
  }

  int height() {
    return _map.length;
  }

  int width() {
    return _map[0].length;
  }

  bool validPosition(Position p) {
    return (0 <= p.row && p.row < height() && 0 <= p.col && p.col < width());
  }

  Iterable<Position> allPositions() sync* {
    for (var row = 0; row < height(); row++) {
      for (var p in positionsInRow(row)) {
        yield p;
      }
    }
  }

  Iterable<Position> positionsInRow(int row) sync* {
    for (var col = 0; col < width(); col++) {
      yield Position(this, row, col);
    }
  }

  Iterable<Position> positionsInCol(int col) sync* {
    for (var row = 0; row < height(); row++) {
      yield Position(this, row, col);
    }
  }

  /// Returns the crop type (letter) at Position p
  String at(Position p) {
    if (!validPosition(p)) {
      return '.';
    }
    return _map[p.row][p.col];
  }
}
