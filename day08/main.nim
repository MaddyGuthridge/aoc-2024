import std/sugar
import std/rdstdin
import std/enumerate
import std/sequtils
import std/strutils

iterator nodeSymbols: char =
  for (start, finish) in [
    ('a', 'z'),
    ('A', 'Z'),
    ('0', '9'),
  ]:
    for character in start..finish:
      yield character

type Input = seq[string]

proc readInput(): Input =
  ## Shamelessly stolen from the docs of std/rdstdin
  var line: string
  while true:
    let ok = readLineFromStdin("", line)
    if not ok: break # ctrl-C or ctrl-D will cause a break
    if line.len > 0:
      result.add(line)

type Coordinate = tuple[row, col: int]

proc `-`(a: Coordinate, b: Coordinate): Coordinate =
  result.row = a.row - b.row
  result.col = a.col - b.col

proc `+`(a: Coordinate, b: Coordinate): Coordinate =
  result.row = a.row + b.row
  result.col = a.col + b.col

type MapLayer = object
  layer: seq[seq[bool]]
  character: char

proc newMapLayer(input: Input, character: char): MapLayer =
  ## Turn the input into a map layer for a particular character
  result.character = character
  for line in input:
    let mask_line: seq[bool] = collect(newSeq):
      for c in line: c == character
    result.layer.add(mask_line)

proc newMapLayer(self: MapLayer, character: char = '#'): MapLayer =
  ## Produce a new layer with the same dimensions
  result.character = character
  result.layer = collect(newSeq):
    for line in self.layer:
      collect(newSeq):
        for _ in line: false

proc `[]`(self: MapLayer, coordinate: Coordinate): bool =
  return self.layer[coordinate.row][coordinate.col]

proc `[]=`(self: var MapLayer, coordinate: Coordinate, value: bool) =
  self.layer[coordinate.row][coordinate.col] = value

proc `|=`(self: var MapLayer, b: MapLayer) =
  ## Union `self` with `b`, storing the result in `self`
  for row, b_line in enumerate(b.layer):
    for col, b_cell in enumerate(b_line):
      if b_cell:
        self.layer[row][col] = b_cell

proc numPoints(self: MapLayer): int =
  ## Returns number of points set to `true` in `self`
  return foldl(self.layer,
    a + foldl(b, a + (if b: 1 else: 0), 0),
    0)

proc `$`(self: MapLayer): string =
  ## Convert given MapLayer to a string
  return foldl(self.layer,
    a & "\n" & foldl(b, a & (if b: $self.character else: "."), ""),
    "").strip()

proc coordinateIsInLayer(self: MapLayer, coordinate: Coordinate): bool =
  ## Returns whether the coordinate exists within the given layer's dimensions
  let (row, col) = coordinate
  return row >= 0 and
    col >= 0 and
    row < self.layer.len and
    col < self.layer[0].len

iterator getCoordinatesOfLayer(self: MapLayer): Coordinate =
  ## Returns coordinates where a node is present in a layer
  for row, line in enumerate(self.layer):
    for col, is_node in enumerate(line):
      if is_node:
        yield (row, col)

type AntiNodeIterator = (self: MapLayer, node_1: Coordinate, node_2: Coordinate) -> iterator (): Coordinate
## Function that produces an iterator of anti-nodes

# For some absurd reason, if I want to pass iterators to functions, I must
# turn them into a proc that returns the iterator, rather than just calling the iterator
# https://nim-lang.org/docs/manual.html#iterators-and-the-for-statement-firstminusclass-iterators
proc antiNodesOfPointsPart1(self: MapLayer, node_1: Coordinate, node_2: Coordinate): iterator (): Coordinate =
  result = iterator (): Coordinate =
    ## Given two nodes, return all anti-nodes within the range of the map
    let delta = node_1 - node_2
    if self.coordinateIsInLayer(node_1 + delta):
      yield node_1 + delta
    if self.coordinateIsInLayer(node_2 - delta):
      yield node_2 - delta

proc antiNodesOfPointsPart2(self: MapLayer, node_1: Coordinate, node_2: Coordinate): iterator (): Coordinate =
  result = iterator (): Coordinate =
    let delta = node_1 - node_2
    var anti_node = node_1
    # Moving away from node_1
    while self.coordinateIsInLayer(anti_node):
      yield anti_node
      anti_node = anti_node + delta
    # Moving away from node_2
    anti_node = node_2
    while self.coordinateIsInLayer(anti_node):
      yield anti_node
      anti_node = anti_node - delta

## Returns a new layer representing the anti-nodes
proc getAntiNodes(self: MapLayer, antiNodesOfPoints: AntiNodeIterator): MapLayer =
  var anti_nodes: MapLayer = self.newMapLayer
  for node_1 in self.getCoordinatesOfLayer():
    for node_2 in self.getCoordinatesOfLayer():
      if node_1 == node_2:
        continue
      # Otherwise, calculate the anti-node positions
      for anti_node in antiNodesOfPoints(self, node_1, node_2):
        anti_nodes[(anti_node.row, anti_node.col)] = true
  return anti_nodes

proc part1(input: Input): int =
  # For each character, generate its mask
  var overall = newMapLayer(input, '#')
  for character in nodeSymbols():
    let layer = newMapLayer(input, character)
    let anti_nodes = layer.getAntiNodes(antiNodesOfPointsPart1)
    overall |= anti_nodes

  return overall.numPoints

proc part2(input: Input): int =
  # For each character, generate its mask
  var overall = newMapLayer(input, '#')
  for character in nodeSymbols():
    overall |= newMapLayer(input, character).getAntiNodes(antiNodesOfPointsPart2)

  return overall.numPoints


proc main =
  let input = readInput()

  echo "Part 1: ", part1(input)
  echo "Part 2: ", part2(input)

when isMainModule:
  main()
