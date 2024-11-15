const std = @import("std");

pub const Solution = struct {
    input: []const u8,

    pub fn init(input_text: []const u8) Solution {
        return Solution{
            .input = std.mem.trimRight(u8, input_text, &[_]u8{ '\n', '\r' }),
        };
    }

    pub fn part1(self: *const Solution, start_at: usize) !usize {
        const answer = try self.findIntegerSuffix(start_at, 5);
        return answer;
    }

    pub fn part2(self: *const Solution, start_at: usize) !usize {
        const answer = try self.findIntegerSuffix(start_at, 6);
        return answer;
    }

    fn findIntegerSuffix(self: *const Solution, start_at: usize, n: u32) !usize {
        var i: usize = start_at;

        var buffer: [100]u8 = undefined;
        const input_len = self.input.len;
        @memcpy(buffer[0..input_len], self.input);

        var md5 = std.crypto.hash.Md5.init(.{});
        var result: [std.crypto.hash.Md5.digest_length]u8 = undefined;

        while (true) : (i += 1) {
            // First get the number format result
            const num_len = std.fmt.formatIntBuf(buffer[input_len..], i, 10, .lower, .{});
            const full_len = input_len + num_len;

            md5 = std.crypto.hash.Md5.init(.{});
            md5.update(buffer[0..full_len]);
            md5.final(&result);

            if (startsWithNZeroes(n, &result)) break;
        }
        return i;
    }
};

pub fn startsWithNZeroes(n: u32, hash: []const u8) bool {
    const full_bytes = n / 2;
    const has_half_byte = n % 2 != 0;

    // Check full bytes (each byte represents 2 hex digits)
    for (0..full_bytes) |i| {
        if (hash[i] != 0) return false;
    }

    // Check the half byte if needed
    if (has_half_byte) {
        return hash[full_bytes] < 0x10;
    }

    return true;
}

test "Read" {
    const input: []const u8 = "yzbqklnh";
    const s = Solution.init(input);
    _ = try s.part1();
}

test "Test startsWithNZeroes" {
    var buf: [6]u8 = undefined;
    var h: []const u8 = "000001dbbfa0";
    _ = try std.fmt.hexToBytes(&buf, h);
    var t = startsWithNZeroes(5, &buf);
    try std.testing.expectEqual(t, true);
    @memset(&buf, 0);
    h = "000011dbbfa0";
    _ = try std.fmt.hexToBytes(&buf, h);
    t = startsWithNZeroes(5, &buf);
    try std.testing.expectEqual(t, false);
    @memset(&buf, 0);
    h = "000000dbbfa0";
    _ = try std.fmt.hexToBytes(&buf, h);
    t = startsWithNZeroes(6, &buf);
    try std.testing.expectEqual(t, true);
    @memset(&buf, 0);
    h = "000001dbbfa0";
    _ = try std.fmt.hexToBytes(&buf, h);
    t = startsWithNZeroes(6, &buf);
    try std.testing.expectEqual(t, false);
}

test "Basic hash test" {
    const data = "abcdef609043";

    var md5 = std.crypto.hash.Md5.init(.{});
    md5.update(data);

    var result: [std.crypto.hash.Md5.digest_length]u8 = undefined;
    md5.final(&result);

    std.debug.print("MD5 (hex): ", .{});
    for (result) |byte| {
        std.debug.print("{x:0>2}", .{byte});
    }
    std.debug.print("\n", .{});
}
