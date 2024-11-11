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

        const robo_helping = false;
        try self.deliverPresents(&visited, robo_helping);

        const houses_visited = visited.count();
        return houses_visited;
    }

    pub fn part2(self: *const Solution) !u32 {
        _ = self.input;
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var visited = std.AutoHashMap(Position, u32).init(allocator);
        defer visited.deinit();

        const robo_helping = true;
        try self.deliverPresents(&visited, robo_helping);

        const houses_visited = visited.count();
        return houses_visited;
    }

    fn deliverPresents(self: *const Solution, visited: *std.AutoHashMap(Position, u32), helper: bool) !void {
        var pos = Position{ .x = 0, .y = 0 };
        var robo_pos = Position{ .x = 0, .y = 0 };
        const curr_pos = &pos;
        const curr_robo_pos = &robo_pos;
        try visited.put(curr_pos.*, 1);
        if (helper) {
            try visited.put(curr_robo_pos.*, 1);
        }
        var ct: u32 = 1;
        for (self.input) |mv| {
            if (helper and (ct % 2 == 0)) {
                self.move(curr_robo_pos, mv);
                const next_entry = try visited.getOrPut(curr_robo_pos.*);
                if (!next_entry.found_existing) {
                    next_entry.value_ptr.* = 1;
                } else {
                    next_entry.value_ptr.* += 1;
                }
            } else {
                self.move(curr_pos, mv);
                const next_entry = try visited.getOrPut(curr_pos.*);
                if (!next_entry.found_existing) {
                    next_entry.value_ptr.* = 1;
                } else {
                    next_entry.value_ptr.* += 1;
                }
            }
            ct += 1;
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

test "Part 2 test 1" {
    const s = Solution.init("^v");
    const t = s.part2();
    try std.testing.expectEqual(t, 3);
}

test "Part 2 test 2" {
    const s = Solution.init("^>v<");
    const t = s.part2();
    try std.testing.expectEqual(t, 3);
}

test "Part 2 test 3" {
    const s = Solution.init("^v^v^v^v^v");
    const t = s.part2();
    try std.testing.expectEqual(t, 11);
}
