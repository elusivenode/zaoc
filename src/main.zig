const std = @import("std");
const menu = @import("menu.zig");

pub fn main() !void {
    try menu.showYearMenu();
}
