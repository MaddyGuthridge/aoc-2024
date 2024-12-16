import 'package:day12/position.dart';
import 'package:day12/farm_map.dart';

/// Represents a crop of land within a farm map
class FarmCrop {
  int area = 0;
  int perimeter = 0;
  late String targetCrop;

  FarmCrop(FarmMap map, Position start) {
    targetCrop = map.at(start);
    // Do a flood-fill algorithm to find the perimeter and area
    floodFill(map, start);
  }

  void floodFill(FarmMap map, Position p) {
    // If this position is invalid, or is a different target crop, increase the
    // perimeter by 1
    if (!p.valid() || map.at(p) != targetCrop) {
      perimeter++;
      return;
    }
    // If this square has already been visited, do nothing
    if (p.visited()) {
      return;
    }
    // Otherwise, mark it as visited, and increase the area
    p.mark();
    area++;
    // Then visit each neighbour
    for (final neighbour in p.neighbours()) {
      floodFill(map, neighbour);
    }
  }

  int price() {
    return area * perimeter;
  }
}
