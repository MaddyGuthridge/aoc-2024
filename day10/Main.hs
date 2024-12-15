import Data.Char (digitToInt)
import Data.Set (fromList, toList)

-- | Remove duplicate elements from a list by converting it to then from a Set.
--
-- Source: https://www.educative.io/answers/how-to-remove-duplicates-from-a-list-in-haskell#zNeBmcH23dlr8p71JfbR2
dedup :: (Eq a, Ord a) => [a] -> [a]
dedup = toList . fromList

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
    validRow = 0 <= r && r < worldHeight w
    validCol = 0 <= c && c < worldWidth w

worldHeight :: World -> Int
worldHeight = length

worldWidth :: World -> Int
worldWidth w = length (head w)

worldCoords :: World -> [Coordinate]
worldCoords w = [(r, c) | r <- [0 .. height - 1], c <- [0 .. width - 1]]
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
slopeNeighbours w c = filter valid $ neighbors c
  where
    valid c1 = validCoord w c1 && validSlope w c c1

-- | Returns all trail ends reachable from the given coordinate
trailEnds :: World -> Coordinate -> [Coordinate]
trailEnds w c
  | elevation == 9 = [c]
  | otherwise = dedup $ concatMap score neighbors
  where
    elevation = worldAt w c
    neighbors = slopeNeighbours w c
    score = trailEnds w

-- | Returns the number of distinct paths to an elevation of 9 from the given
-- point
trailPaths :: World -> Coordinate -> Int
trailPaths w c
  | elevation == 9 = 1
  | otherwise = sum $ map score neighbors
  where
    elevation = worldAt w c
    neighbors = slopeNeighbours w c
    score = trailPaths w

-- | Solve part 1
part1 :: World -> Int
part1 w = length $ concatMap score trailheads
  where
    score = trailEnds w
    trailheads = filter isTrailhead $ worldCoords w
    isTrailhead = coordIsTrailhead w

-- | Solve part 2
part2 :: World -> Int
part2 w = sum $ map score trailheads
  where
    score = trailPaths w
    trailheads = filter isTrailhead $ worldCoords w
    isTrailhead = coordIsTrailhead w

-- | Convert input string into world map
inputToWorld :: String -> World
inputToWorld input = map (map digitToInt) (lines input)

main :: IO ()
main = do
  input <- getContents
  putStrLn "Part 1"
  print $ part1 $ inputToWorld input
  putStrLn "Part 2"
  print $ part2 $ inputToWorld input
