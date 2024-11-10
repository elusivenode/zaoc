const std = @import("std");

pub const Solution = struct {
    input: []const u8,

    pub fn init(input_text: []const u8) Solution {
        return Solution{
            .input = input_text,
        };
    }

    pub fn part1(self: *const Solution) u32 {
        const paper_required: u32 = self.totalMaterialRequired("paper");
        return paper_required;
    }

    pub fn part2(self: *const Solution) u32 {
        const ribbon_required: u32 = self.totalMaterialRequired("ribbon");
        return ribbon_required;
    }

    fn totalMaterialRequired(self: *const Solution, material: []const u8) u32 {
        var material_req: u32 = 0;
        var presents = std.mem.tokenizeScalar(u8, self.input, '\n');

        while (presents.next()) |dimensions| {
            var dim_tok = std.mem.tokenizeScalar(u8, dimensions, 'x');

            const l = std.fmt.parseInt(u32, dim_tok.next() orelse "0", 10) catch 0;
            const w = std.fmt.parseInt(u32, dim_tok.next() orelse "0", 10) catch 0;
            const h = std.fmt.parseInt(u32, dim_tok.next() orelse "0", 10) catch 0;

            if (std.mem.eql(u8, material, "paper")) {
                material_req += calcPaperRequired(self, l, w, h);
            } else if (std.mem.eql(u8, material, "ribbon")) {
                material_req += calcRibbonRequired(self, l, w, h);
            }
        }
        return material_req;
    }

    fn calcPaperRequired(self: *const Solution, l: u32, w: u32, h: u32) u32 {
        _ = self.input;
        const lxw: u32 = l * w;
        const lxh: u32 = l * h;
        const wxh: u32 = w * h;

        var paper_req: u32 = 2 * lxw + 2 * wxh + 2 * lxh;
        const smallest_side: u32 = @min(wxh, @min(lxw, lxh));

        paper_req += smallest_side;
        return paper_req;
    }

    fn calcRibbonRequired(self: *const Solution, l: u32, w: u32, h: u32) u32 {
        _ = self.input;
        const smallest_dims = get2SmallestDims(self, l, w, h);
        const ribbon_req: u32 = 2 * smallest_dims[0] + 2 * smallest_dims[1] + l * w * h;

        return ribbon_req;
    }

    fn get2SmallestDims(self: *const Solution, l: u32, w: u32, h: u32) struct { u32, u32 } {
        _ = self.input;
        const min1: u32 = @min(l, @min(w, h));
        var min2: u32 = undefined;

        if (min1 == l) {
            min2 = @min(w, h);
        } else if (min1 == w) {
            min2 = @min(l, h);
        } else {
            min2 = @min(l, w);
        }

        return .{ min1, min2 };
    }
};

test "Test part 1" {
    const s = Solution.init("2x3x4\n1x1x10");
    const t = s.part1();
    try std.testing.expectEqual(@as(u32, 2 * 2 * 3 + 2 * 2 * 4 + 2 * 3 * 4 + 2 * 3 +
        2 * 1 * 1 + 2 * 1 * 10 + 2 * 1 * 10 + 1), t);
}

test "Test part 2" {
    const s = Solution.init("2x3x4\n1x1x10");
    const t = s.part2();
    try std.testing.expectEqual(@as(u32, (2 * 2 + 2 * 3 + 2 * 3 * 4) + (2 * 1 + 2 * 1 + 1 * 1 * 10)), t);
}

test "Test get2SmallestDims" {
    const s = Solution.init("");
    try std.testing.expectEqual(.{ 1, 2 }, s.get2SmallestDims(1, 2, 3));
    try std.testing.expectEqual(.{ 10, 20 }, s.get2SmallestDims(10, 20, 30));
    try std.testing.expectEqual(.{ 1, 1 }, s.get2SmallestDims(1, 1, 3));
    try std.testing.expectEqual(.{ 2, 2 }, s.get2SmallestDims(2, 2, 2));
}
