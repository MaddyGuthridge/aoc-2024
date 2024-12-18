import 'package:day12/farm_map.dart';
import 'package:day12/position.dart';

/// A boolean mask for all tiles in the map
///
/// This is used for the visited map, and by `FarmCrop` to determine the
/// region for each crop.
class FarmMask {
  FarmMap map;
  late List<List<bool>> mask;

  FarmMask(this.map) {
    mask = List.generate(map.height(), (_) => List.filled(map.width(), false));
  }

  /// Returns the value at Position p
  bool at(Position p) {
    if (!map.validPosition(p)) {
      return false;
    }
    return mask[p.row][p.col];
  }

  /// Mark the given Position as visited
  void mark(Position p) {
    mask[p.row][p.col] = true;
  }
}
