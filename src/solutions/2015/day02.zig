const std = @import("std");

pub const Solution = struct {
    input: []const u8,

    pub fn init(input_text: []const u8) Solution {
        return Solution{
            .input = input_text,
        };
    }

    pub fn part1(self: *const Solution) u32 {
        const paper_required: u32 = self.totalPaperRequired();
        return paper_required;
    }

    pub fn part2(self: *const Solution) u32 {
        std.debug.print("Input: {s}", .{self.input});
    }

    fn totalPaperRequired(self: *const Solution) u32 {
        var paper_req: u32 = 0;
        var presents = std.mem.tokenizeScalar(u8, self.input, '\n');

        while (presents.next()) |dimensions| {
            var dim_tok = std.mem.tokenizeScalar(u8, dimensions, 'x');

            const l = std.fmt.parseInt(u32, dim_tok.next() orelse "0", 10) catch 0;
            const w = std.fmt.parseInt(u32, dim_tok.next() orelse "0", 10) catch 0;
            const h = std.fmt.parseInt(u32, dim_tok.next() orelse "0", 10) catch 0;

            paper_req += calcPaperRequired(l, w, h);
        }
        return paper_req;
    }

    fn calcPaperRequired(l: u32, w: u32, h: u32) u32 {
        const lxw: u32 = l * w;
        const lxh: u32 = l * h;
        const wxh: u32 = w * h;

        var paper_req: u32 = 2 * lxw + 2 * wxh + 2 * lxh;
        const smallest_side: u32 = @min(wxh, @min(lxw, lxh));

        paper_req += smallest_side;
        return paper_req;
    }
};

test "Test read input" {
    const s = Solution.init("2x3x4\n1x1x10");
    const t = s.part1();
    try std.testing.expectEqual(@as(u32, 2 * 2 * 3 + 2 * 2 * 4 + 2 * 3 * 4 + 2 * 3 +
        2 * 1 * 1 + 2 * 1 * 10 + 2 * 1 * 10 + 1), t);
}
