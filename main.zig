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

    const themeColors = ThemeColors{};

    try std.io.getStdOut().writer().print("{s}\n", .{themeColors.white});

    var map = std.AutoHashMap(ImGuiCol, HEXA).init(allocator);
    defer map.deinit();

    try map.put(ImGuiCol.Text, .{ themeColors.white, 1.0 });

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
