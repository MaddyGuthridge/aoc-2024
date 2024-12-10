const std = @import("std");
const expect = std.testing.expect;

/// Errors when the guard is navigating the map
const NavigationError = error{
    /// The guard got stuck in an infinite loop
    InfiniteLoop,
};

const Direction = enum {
    up,
    down,
    left,
    right,

    fn rotate(self: Direction) Direction {
        return switch (self) {
            .up => .right,
            .right => .down,
            .down => .left,
            .left => .up,
        };
    }
};

const TileVariants = enum {
    empty,
    guard,
    obstacle,
    visited,
};

const Tile = union(TileVariants) {
    empty: void,
    guard: void,
    obstacle: void,
    /// Visited tile, contains a direction for the direction the guard was
    /// moving when they visited this tile
    visited: Direction,

    fn from_char(c: u8) Tile {
        return switch (c) {
            '.' => .empty,
            '^' => .guard,
            '#' => .obstacle,
            // 'X' => .visited,
            else => unreachable,
        };
    }
};

const Map = struct {
    arr: std.ArrayList(std.ArrayList(Tile)),
    rows: i32,
    cols: i32,
    allocator: std.mem.Allocator,

    fn is_out_of_bounds(self: *const Map, pos: Position) bool {
        return pos.row < 0 or pos.col < 0 or pos.row >= self.rows or pos.col >= self.cols;
    }

    fn from_reader(allocator: std.mem.Allocator, file: std.fs.File) !Map {
        var lines = std.ArrayList(std.ArrayList(Tile)).init(allocator);
        // Honestly wish there was a way to iterate over stdin.lines
        while (true) {
            const result = try file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', 1024);
            if (result) |line| {
                // Convert line into tiles
                var tiles = std.ArrayList(Tile).init(allocator);
                for (line) |c| {
                    try tiles.append(Tile.from_char(c));
                }
                try lines.append(tiles);
            } else {
                break;
            }
        }
        return .{
            .arr = lines,
            .rows = @intCast(lines.items.len),
            .cols = @intCast(lines.items[0].items.len),
            .allocator = allocator,
        };
    }

    fn at(self: *const Map, pos: Position) Tile {
        return self.arr.items[@intCast(pos.row)].items[@intCast(pos.col)];
    }

    /// Mark the given position as visited
    fn mark(self: *Map, pos: Position, dir: Direction) void {
        self.arr.items[@intCast(pos.row)].items[@intCast(pos.col)] = Tile{ .visited = dir };
    }

    fn cells_visited(self: *const Map) i32 {
        var visited: i32 = 0;
        for (self.arr.items) |row| {
            for (row.items) |tile| {
                if (tile == Tile.visited) {
                    visited += 1;
                }
            }
        }
        return visited;
    }

    fn deinit(self: Map) void {
        self.arr.deinit();
    }

    /// Clone the given Map using the same allocator
    fn clone(self: *const Map) !Map {
        var new: Map = .{
            .arr = try std.ArrayList(std.ArrayList(Tile)).initCapacity(self.allocator, @intCast(self.rows)),
            .rows = self.rows,
            .cols = self.cols,
            .allocator = self.allocator,
        };
        // Deep copy into new array
        for (self.arr.items) |row| {
            new.arr.appendAssumeCapacity(try row.clone());
        }
        return new;
    }

    /// Returns a clone of the given Map, with the given obstacle added
    fn with_obstruction(self: *const Map, pos: Position) !Map {
        var new = try self.clone();
        // Add the obstacle
        new.arr.items[@intCast(pos.row)].items[@intCast(pos.col)] = Tile.obstacle;
        return new;
    }
};

const Position = struct {
    row: i32,
    col: i32,

    fn add(self: Position, dir: Direction) Position {
        return switch (dir) {
            .up => .{ .row = self.row - 1, .col = self.col },
            .right => .{ .row = self.row, .col = self.col + 1 },
            .down => .{ .row = self.row + 1, .col = self.col },
            .left => .{ .row = self.row, .col = self.col - 1 },
        };
    }
};

fn find_start_pos(map: *const Map) Position {
    for (map.arr.items, 0..) |line, row| {
        for (line.items, 0..) |c, col| {
            if (c == Tile.guard) {
                return .{ .row = @intCast(row), .col = @intCast(col) };
            }
        }
    }
    unreachable;
}

fn part_1(input: Map) NavigationError!i32 {
    // Mild ick
    // https://github.com/ziglang/zig/issues/1714#issuecomment-438358632
    var map = input;
    var pos = find_start_pos(&map);
    var dir = Direction.up;
    // Mark initial cell as visited
    map.mark(pos, dir);
    // This could get stuck in an infinite loop if the guard wanders infinitely
    while (true) {
        const target_pos = pos.add(dir);
        // If target is outside of the map
        if (map.is_out_of_bounds(target_pos)) {
            break;
        }
        switch (map.at(target_pos)) {
            // If target is blocked, spin instead
            .obstacle => {
                dir = dir.rotate();
                continue;
            },
            // If the tile is visited, and we're going in the same direction, we've
            // found an infinite loop
            .visited => |prev_dir| {
                if (dir == prev_dir) {
                    return error.InfiniteLoop;
                }
            },
            // Empty tile
            else => {},
        }
        // Move the guard
        map.mark(target_pos, dir);
        pos = target_pos;
    }
    return map.cells_visited();
}

/// Brute force approach
///
/// Simply try every combination of additional obstacles in part 1, and check
/// for an infinite loop error, counting the number of times one is
/// encountered.
fn part_2(map: Map) !i32 {
    var loops_found: i32 = 0;
    for (0..(@intCast(map.rows))) |row| {
        for (0..(@intCast(map.cols))) |col| {
            const pos: Position = .{ .row = @intCast(row), .col = @intCast(col) };
            switch (map.at(pos)) {
                // Don't attempt to replace the guard or obstacles
                .guard, .obstacle => {
                    continue;
                },
                else => {
                    const map_variant = try map.with_obstruction(pos);
                    _ = part_1(map_variant) catch {
                        loops_found += 1;
                    };
                },
            }
        }
    }
    return loops_found;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var map = try Map.from_reader(allocator, std.io.getStdIn());
    defer map.deinit();
    const map_1 = try map.clone();
    defer map_1.deinit();
    std.debug.print("Part 1: {d}\n", .{try part_1(map_1)});

    const map_2 = try map.clone();
    defer map_2.deinit();
    std.debug.print("Part 2: {d}\n", .{try part_2(map_2)});
}

test "direction rotation" {
    const up: Direction = Direction.up;
    const right: Direction = up.rotate();
    try expect(right == Direction.right);
}
