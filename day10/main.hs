import Data.Char (digitToInt)

-- | A coordinate within the world, in the form (row, col)
type Coordinate = (Int, Int)

-- | Returns neighbours of given coordinate, without checking their validity
neighbors :: Coordinate -> [Coordinate]
neighbors (r, c) = [(r + 1, c), (r, c + 1), (r - 1, c), (r, c - 1)]

-- | The world map within the puzzle. The `Int` at each coordinate represents
-- the elevation from `0` (lowest) to `9` (highest)
type World = [[Int]]

-- | Whether the coordinate is valid within the given world
validCoord :: World -> Coordinate -> Bool
validCoord w (r, c) = validRow && validCol
  where
    validRow = 0 <= r && r < length w
    validCol = 0 <= c && c < length (w !! r)

worldHeight :: World -> Int
worldHeight = length

worldWidth :: World -> Int
worldWidth w = length (head w)

worldCoords :: World -> [Coordinate]
worldCoords w = [(r, c) | r <- [0 .. height], c <- [0 .. width]]
  where
    height = worldHeight w
    width = worldWidth w

-- | Elevation at given coordinate in the world
worldAt :: World -> Coordinate -> Int
worldAt w (r, c) = w !! r !! c

-- | Whether the given coordinate is a trailhead (meaning paths can start from
-- it)
coordIsTrailhead :: World -> Coordinate -> Bool
coordIsTrailhead w c = worldAt w c == 0

-- | Whether the slope between two coordinates is valid, meaning that y is 1
-- step above x.
validSlope :: World -> Coordinate -> Coordinate -> Bool
validSlope w x y = at y - at x == 1
  where
    at = worldAt w

-- | Returns the neighbours of the given coordinate which have a valid slope
slopeNeighbours :: World -> Coordinate -> [Coordinate]
slopeNeighbours w c = filter valid (neighbors c)
  where
    valid c1 = validCoord w c1 && validSlope w c c1

-- | Returns the number of distinct paths to an elevation of 9 from the given
-- point
trailScore :: World -> Coordinate -> Int
-- I remember there's a way to apply `sum` to the result in a pipeline-sorta
-- way but I can't remember the operator for it
trailScore w c = sum (map score neighbors)
  where
    neighbors = slopeNeighbours w c
    score = trailScore w

-- | Solve part 1
part1 :: World -> Int
part1 w = sum (map score trailheads)
  where
    score = trailScore w
    trailheads = filter isTrailhead (worldCoords w)
    isTrailhead = coordIsTrailhead w

-- | Convert input string into world map
inputToWorld :: String -> World
inputToWorld input = map (map digitToInt) (lines input)

main :: IO ()
main = do
  input <- getContents
  print (part1 (inputToWorld input))
