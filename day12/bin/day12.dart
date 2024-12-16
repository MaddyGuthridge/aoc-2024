import 'dart:io';
import 'package:day12/day12.dart';

String fromStdin() {
  var input = "";
  while (true) {
    var line = stdin.readLineSync();
    if (line != null) {
      input += "$line\n";
    } else {
      break;
    }
  }
  return input;
}

String fromFile(String path) {
  return File(path).readAsStringSync();
}

void main(List<String> arguments) {
  var input = arguments.isEmpty ? fromStdin() : fromFile(arguments[0]);
  var part_1 = solve(input);

  print("Part 1: $part_1");
}
