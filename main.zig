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

    var themeColors = std.StringHashMap([]const u8).init(allocator);
    defer themeColors.deinit();

    try themeColors.put("darkestGrey", "#141f2c");
    try themeColors.put("darkerGrey", "#2a2e39");
    try themeColors.put("darkGrey", "#363b4a");
    try themeColors.put("lightGrey", "#5a5a5a");
    try themeColors.put("lighterGrey", "#7A818C");
    try themeColors.put("evenLighterGrey", "#8491a3");
    try themeColors.put("black", "#0A0B0D");
    try themeColors.put("green", "#75f986");
    try themeColors.put("red", "#ff0062");
    try themeColors.put("white", "#fff");

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
