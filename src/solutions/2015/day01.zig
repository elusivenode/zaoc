const std = @import("std");

pub const Solution = struct {
    input: []const u8,

    pub fn init(input_text: []const u8) Solution {
        return Solution{
            .input = input_text,
        };
    }

    pub fn part1(self: *const Solution) i32 {
        const ff: i32 = self.finalFloor();
        return ff;
    }

    pub fn part2(self: *const Solution) i32 {
        const enter_basement: i32 = self.enterBasement();
        return enter_basement;
    }

    fn enterBasement(self: *const Solution) i32 {
        var ct: i32 = 0;
        var cf: i32 = 0;
        for (self.input) |ch| {
            if (ch == '(') {
                cf += 1;
                ct += 1;
            } else if (ch == ')') {
                cf -= 1;
                ct += 1;
            }
            if (cf == -1) {
                return ct;
            }
        }
        return -1; // did not enter the basement
    }

    fn finalFloor(self: *const Solution) i32 {
        var ff: i32 = 0;
        for (self.input) |ch| {
            if (ch == '(') {
                ff += 1;
            } else if (ch == ')') {
                ff -= 1;
            }
        }
        return ff;
    }
};

test "Final floor test 1" {
    const s = Solution.init("()())");
    const t = s.part1();
    try std.testing.expectEqual(@as(i32, -1), t);
}

test "Final floor test 2" {
    const s = Solution.init("()())))))");
    const t = s.part1();
    try std.testing.expectEqual(@as(i32, -5), t);
}

test "Enter basement test 1" {
    const s = Solution.init(")");
    const t = s.part2();
    try std.testing.expectEqual(@as(i32, 1), t);
}

test "Enter basement test 2" {
    const s = Solution.init("(((()))))");
    const t = s.part2();
    try std.testing.expectEqual(@as(i32, 9), t);
}

test "Enter basement test 3" {
    const s = Solution.init("((");
    const t = s.part2();
    try std.testing.expectEqual(@as(i32, -1), t); // never enters basement
}
