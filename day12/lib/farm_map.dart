import 'package:day12/position.dart';

/// Map of the farmland
class FarmMap {
  late List<String> _map;
  late List<List<bool>> _visitedMap;

  FarmMap(String input) {
    _map = input.trim().split('\n');

    _visitedMap =
        List.generate(_map.length, (_) => List.filled(_map[0].length, false));
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
      for (var col = 0; col < width(); col++) {
        yield Position(this, row, col);
      }
    }
  }

  /// Returns the crop type (letter) at Position p
  String at(Position p) {
    return _map[p.row][p.col];
  }

  /// Returns whether the Position p has been visited
  bool visited(Position p) {
    return _visitedMap[p.row][p.col];
  }

  /// Mark the given Position as visited
  void markVisited(Position p) {
    _visitedMap[p.row][p.col] = true;
  }
}
