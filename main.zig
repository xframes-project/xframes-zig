const std = @import("std");

const FontDef = struct {
    name: []const u8,
    size: u8,
};

const FontDefs = struct {
    defs: []const FontDef,
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const sizes = [_]u8{ 16, 18, 20, 24, 28, 32, 36, 48 };

    var defs = try allocator.alloc(FontDef, sizes.len);
    defer allocator.free(defs);

    for (sizes, 0..) |size, i| {
        defs[i] = FontDef{ .name = "roboto-regular", .size = size };
    }

    const result = FontDefs{ .defs = defs };

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();

    try std.json.stringify(result, .{}, buf.writer());

    try std.io.getStdOut().writer().print("{s}\n", .{buf.items});
}
