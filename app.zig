const std = @import("std");

const ImGuiCol = enum {
    Text,
    TextDisabled,
    WindowBg,
    ChildBg,
    PopupBg,
    Border,
    BorderShadow,
    FrameBg,
    FrameBgHovered,
    FrameBgActive,
    TitleBg,
    TitleBgActive,
    TitleBgCollapsed,
    MenuBarBg,
    ScrollbarBg,
    ScrollbarGrab,
    ScrollbarGrabHovered,
    ScrollbarGrabActive,
    CheckMark,
    SliderGrab,
    SliderGrabActive,
    Button,
    ButtonHovered,
    ButtonActive,
    Header,
    HeaderHovered,
    HeaderActive,
    Separator,
    SeparatorHovered,
    SeparatorActive,
    ResizeGrip,
    ResizeGripHovered,
    ResizeGripActive,
    Tab,
    TabHovered,
    TabActive,
    TabUnfocused,
    TabUnfocusedActive,
    PlotLines,
    PlotLinesHovered,
    PlotHistogram,
    PlotHistogramHovered,
    TableHeaderBg,
    TableBorderStrong,
    TableBorderLight,
    TableRowBg,
    TableRowBgAlt,
    TextSelectedBg,
    DragDropTarget,
    NavHighlight,
    NavWindowingHighlight,
    NavWindowingDimBg,
    ModalWindowDimBg,
    COUNT,
};

const ThemeColors = struct {
    darkestGrey: []const u8 = "#141f2c",
    darkerGrey: []const u8 = "#2a2e39",
    darkGrey: []const u8 = "#363b4a",
    lightGrey: []const u8 = "#5a5a5a",
    lighterGrey: []const u8 = "#7A818C",
    evenLighterGrey: []const u8 = "#8491a3",
    black: []const u8 = "#0A0B0D",
    green: []const u8 = "#75f986",
    red: []const u8 = "#ff0062",
    white: []const u8 = "#fff",
};

const HEXA = std.meta.Tuple(&[_]type{ []const u8, f32 });

const FontDef = struct {
    name: []const u8,
    size: u8,
};

const FontDefs = struct {
    defs: []const FontDef,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const theme2Colors = ThemeColors{};

    var map = std.AutoHashMap(ImGuiCol, HEXA).init(allocator);
    defer map.deinit();

    try map.put(ImGuiCol.Text, .{ theme2Colors.white, 1.0 });
    try map.put(ImGuiCol.TextDisabled, .{ theme2Colors.lighterGrey, 1.0 });
    try map.put(ImGuiCol.WindowBg, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.ChildBg, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.PopupBg, .{ theme2Colors.white, 1.0 });
    try map.put(ImGuiCol.Border, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.BorderShadow, .{ theme2Colors.darkestGrey, 1.0 });
    try map.put(ImGuiCol.FrameBg, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.FrameBgHovered, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.FrameBgActive, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.TitleBg, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.TitleBgActive, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.TitleBgCollapsed, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.MenuBarBg, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.ScrollbarBg, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.ScrollbarGrab, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.ScrollbarGrabHovered, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.ScrollbarGrabActive, .{ theme2Colors.darkestGrey, 1.0 });
    try map.put(ImGuiCol.CheckMark, .{ theme2Colors.darkestGrey, 1.0 });
    try map.put(ImGuiCol.SliderGrab, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.SliderGrabActive, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.Button, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.ButtonHovered, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.ButtonActive, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.Header, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.HeaderHovered, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.HeaderActive, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.Separator, .{ theme2Colors.darkestGrey, 1.0 });
    try map.put(ImGuiCol.SeparatorHovered, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.SeparatorActive, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.ResizeGrip, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.ResizeGripHovered, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.ResizeGripActive, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.Tab, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.TabHovered, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.TabActive, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.TabUnfocused, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.TabUnfocusedActive, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.PlotLines, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.PlotLinesHovered, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.PlotHistogram, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.PlotHistogramHovered, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.TableHeaderBg, .{ theme2Colors.black, 1.0 });
    try map.put(ImGuiCol.TableBorderStrong, .{ theme2Colors.lightGrey, 1.0 });
    try map.put(ImGuiCol.TableBorderLight, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.TableRowBg, .{ theme2Colors.darkGrey, 1.0 });
    try map.put(ImGuiCol.TableRowBgAlt, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.TextSelectedBg, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.DragDropTarget, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.NavHighlight, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.NavWindowingHighlight, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.NavWindowingDimBg, .{ theme2Colors.darkerGrey, 1.0 });
    try map.put(ImGuiCol.ModalWindowDimBg, .{ theme2Colors.darkerGrey, 1.0 });

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

    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    var stream = std.json.writeStream(list.writer(), .{});

    try stream.beginObject();
    try stream.objectField("colors");
    try stream.beginObject();

    var iterator = map.iterator();
    while (iterator.next()) |entry| {
        const keyAsEnumValue = entry.key_ptr.*;
        const hexa = entry.value_ptr.*;

        const index_str = try std.fmt.allocPrint(allocator, "{d}", .{@intFromEnum(keyAsEnumValue)});
        defer allocator.free(index_str);

        try stream.objectField(index_str);
        try stream.beginArray();
        try stream.write(hexa[0]);
        try stream.write(hexa[1]);
        try stream.endArray();
    }

    try stream.endObject();
    try stream.endObject();

    const json_string = list.items;
    std.debug.print("JSON: {s}\n", .{json_string});
}
