const std = @import("std");

const Position = struct {
    x: i32,
    y: i32,
};

pub const Solution = struct {
    input: []const u8,

    pub fn init(input_text: []const u8) Solution {
        return Solution{
            .input = input_text,
        };
    }

    pub fn part1(self: *const Solution) !u32 {
        _ = self.input;

        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var visited = std.AutoHashMap(Position, u32).init(allocator);
        defer visited.deinit();

        try self.deliverPresents(&visited);

        const houses_visited = visited.count();
        return houses_visited;
    }

    pub fn part2(self: *const Solution) i32 {
        _ = self.input;
        return -1;
    }

    fn deliverPresents(self: *const Solution, visited: *std.AutoHashMap(Position, u32)) !void {
        var pos = Position{ .x = 0, .y = 0 };
        const curr_pos = &pos;
        try visited.put(curr_pos.*, 1);
        for (self.input) |mv| {
            self.move(curr_pos, mv);
            const next_entry = try visited.getOrPut(curr_pos.*);
            if (!next_entry.found_existing) {
                next_entry.value_ptr.* = 1;
            } else {
                next_entry.value_ptr.* += 1;
            }
        }
    }

    fn move(self: *const Solution, curr_pos: *Position, next_move: u8) void {
        _ = self;
        switch (next_move) {
            '^' => curr_pos.y = curr_pos.y + 1,
            '>' => curr_pos.x = curr_pos.x + 1,
            'v' => curr_pos.y = curr_pos.y - 1,
            '<' => curr_pos.x = curr_pos.x - 1,
            else => std.debug.print("Unknown direction\n", .{}),
        }
    }
};

test "Part 1 test 1" {
    const s = Solution.init(">");
    const t = s.part1();
    try std.testing.expectEqual(t, 2);
}

test "Part 1 test 2" {
    const s = Solution.init("^>v<");
    const t = s.part1();
    try std.testing.expectEqual(t, 4);
}

test "Part 1 test 3" {
    const s = Solution.init("^v^v^v^v^v");
    const t = s.part1();
    try std.testing.expectEqual(t, 2);
}
