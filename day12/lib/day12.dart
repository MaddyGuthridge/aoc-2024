import 'package:day12/farm_crop.dart';
import 'package:day12/farm_map.dart';

int part1(String input) {
  final map = FarmMap(input);

  return map
      .allPositions()
      .map((p) => FarmCrop(map, p).pricePart1())
      .reduce((sum, ele) => sum + ele);
}

int part2(String input) {
  final map = FarmMap(input);

  return map
      .allPositions()
      .map((p) => FarmCrop(map, p).pricePart2())
      .reduce((sum, ele) => sum + ele);
}
