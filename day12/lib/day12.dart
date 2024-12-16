import 'package:day12/farm_crop.dart';
import 'package:day12/farm_map.dart';

int solve(String input) {
  final map = FarmMap(input);

  return map
      .allPositions()
      .map((p) => FarmCrop(map, p).price())
      .reduce((sum, ele) => sum + ele);
}
