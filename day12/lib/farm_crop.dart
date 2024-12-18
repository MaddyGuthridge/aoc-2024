import 'package:day12/farm_mask.dart';
import 'package:day12/position.dart';
import 'package:day12/farm_map.dart';

/// Represents a crop of land within a farm map
class FarmCrop {
  int area = 0;
  int perimeter = 0;
  FarmMap map;
  late String targetCrop;
  late FarmMask cropMask;

  /// Whether any tile has been found in this crop. Used to speed up processing
  /// for part 2.
  bool inUse = false;

  FarmCrop(this.map, Position start) {
    targetCrop = map.at(start);
    cropMask = FarmMask(map);
    // Do a flood-fill algorithm to find the perimeter and area
    floodFill(map, start);
  }

  void floodFill(FarmMap map, Position p) {
    // If this position is invalid, or is a different target crop, increase the
    // perimeter by 1
    if (!map.validPosition(p) || map.at(p) != targetCrop) {
      perimeter++;
      return;
    }
    // If this square has already been visited, do nothing
    if (map.visited.at(p)) {
      return;
    }
    // Otherwise, mark it as visited, and increase the area
    map.visited.mark(p);
    cropMask.mark(p);
    area++;
    inUse = true;
    // Then visit each neighbour
    for (final neighbour in p.neighbours()) {
      floodFill(map, neighbour);
    }
  }

  int pricePart1() {
    return area * perimeter;
  }

  int pricePart2() {
    if (!inUse) {
      return 0;
    }
    var totalSides = 0;
    for (int row = 0; row <= map.height(); row++) {
      var sides = numSides(map.positionsInRow(row), Direction.up);
      totalSides += sides;
    }
    for (int col = 0; col <= map.width(); col++) {
      var sides = numSides(map.positionsInCol(col), Direction.left);
      totalSides += sides;
    }
    return area * totalSides;
  }

  /// Counts the number of sides found in the given iterable of positions.
  ///
  /// A side is classified as a series of positions where the position lies
  /// within the `cropMask` and the offset lies outside of it (or vice-versa)
  int numSides(Iterable<Position> positions, Direction offset) {
    // Comments written assuming each position is within a row, and each offset
    // is upwards. In reality, it could also be a column and downwards, but
    // thinking about it in a simplified way makes it so much less mentally
    // awful

    /// Total number of sides we've found
    int numSides = 0;

    /// Whether we're currently visiting a side of the shape
    bool visitingEdge = false;

    /// Whether the shape is below us
    bool shapeBelow = false;

    for (var p in positions) {
      if (visitingEdge) {
        // Check for change to another side edge case
        if (shapeBelow && !cropMask.at(p) && cropMask.at(p + offset)) {
          // shape below -> shape above
          // For this edge case, swap them and increase the number of sides
          numSides++;
          shapeBelow = false;
        } else if (!shapeBelow && cropMask.at(p) && !cropMask.at(p + offset)) {
          // shape above -> shape below
          numSides++;
          shapeBelow = true;
        }
        // Check for exiting edge
        if (shapeBelow && (cropMask.at(p + offset) || !cropMask.at(p))) {
          visitingEdge = false;
        } else if (!shapeBelow &&
            (cropMask.at(p) || !cropMask.at(p + offset))) {
          visitingEdge = false;
        }
      } else {
        // Detect shape below
        if (cropMask.at(p) && !cropMask.at(p + offset)) {
          visitingEdge = true;
          shapeBelow = true;
          numSides++;
        } else if (!cropMask.at(p) && cropMask.at(p + offset)) {
          // Shape above
          visitingEdge = true;
          shapeBelow = false;
          numSides++;
        }
      }
    }

    return numSides;
  }
}
