const std = @import("std");

pub fn showYearMenu() !void {
    const years = [_]u32{2015};

    while (true) {
        std.debug.print("\nAdvent of Code in Zig - Select a Year:\n", .{});
        for (years, 0..) |year, i| {
            std.debug.print("{d}. Year {d}\n", .{ i + 1, year });
        }
        std.debug.print("0. Exit\n", .{});

        const selection = try getUserInput();
        if (selection == 0) break;

        if (selection > 0 and selection <= years.len) {
            const year = years[selection - 1];
            try showDayMenu(year);
        } else {
            std.debug.print("Invalid selection. Please try again.\n", .{});
        }
    }
}

pub fn showDayMenu(year: u32) !void {
    while (true) {
        std.debug.print("\nAdvent of Code {d} - Select a Day:\n", .{year});
        for (1..26) |day| {
            std.debug.print("{d} Day {d:0>2}\n", .{ day, day });
        }
        std.debug.print("0. Back to Year Selection\n", .{});

        const selection = try getUserInput();
        if (selection == 0) break;

        if (selection > 0 and selection <= 25) {
            try runSolution(year, @intCast(selection));
        } else {
            std.debug.print("Invalid selection. Please try again.\n", .{});
        }
    }
}

fn getUserInput() !u32 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("Enter selection: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |user_input| {
        return std.fmt.parseInt(u32, user_input, 10) catch 999;
    }

    return 999;
}

pub fn runSolution(year: u32, day: u32) !void {
    std.debug.print("\nRunning solution for Year {d} and Day {d}\n", .{ year, day });

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input_path = try std.fmt.allocPrint(allocator, "data/{d}/day{d:0>2}.txt", .{ year, day });
    std.debug.print("Path for input file is {s}\n", .{input_path});
    defer allocator.free(input_path);

    const input = std.fs.cwd().readFileAlloc(allocator, input_path, 1024 * 1024) catch |err| {
        if (err == error.FileNotFound) {
            std.debug.print("Solution not implemented yet!\n", .{});
            return;
        }
        return err;
    };
    defer allocator.free(input);

    switch (year) {
        2015 => switch (day) {
            1 => {
                const day01 = @import("solutions/2015/day01.zig");
                const solution = day01.Solution.init(input);
                const answer1 = solution.part1();
                const answer2 = solution.part2();
                std.debug.print("Part 1: {d}\n", .{answer1});
                std.debug.print("Part 2: {d}\n", .{answer2});
            },
            2 => {
                const day02 = @import("solutions/2015/day02.zig");
                const solution = day02.Solution.init(input);
                const answer1 = solution.part1();
                const answer2 = solution.part2();
                std.debug.print("Part 1: {d}\n", .{answer1});
                std.debug.print("Part 2: {d}\n", .{answer2});
            },
            3 => {
                const day01 = @import("solutions/2015/day03.zig");
                const solution = day01.Solution.init(input);
                const answer1 = try solution.part1();
                const answer2 = try solution.part2();
                std.debug.print("Part 1: {d}\n", .{answer1});
                std.debug.print("Part 2: {d}\n", .{answer2});
            },
            else => {
                std.debug.print("Solution not implemented yet!\n", .{});
            },
        },
        else => {
            std.debug.print("Year {d} not implemented yet!", .{year});
        },
    }
}

test "runSolution basic test" {
    try runSolution(2015, 1);
}
