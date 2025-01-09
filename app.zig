const std = @import("std");

const OnInitCb = *const fn () callconv(.C) void;
const OnTextChangedCb = *const fn (i32, [*:0]const u8) callconv(.C) void;
const OnComboChangedCb = *const fn (i32, i32) callconv(.C) void;
const OnNumericValueChangedCb = *const fn (i32, f32) callconv(.C) void;
const OnBooleanValueChangedCb = *const fn (i32, bool) callconv(.C) void;
const OnMultipleNumericValuesChangedCb = *const fn (i32, *f32, i32) callconv(.C) void;
const OnClickCb = *const fn (i32) callconv(.C) void;

extern "c" fn init(assetsBasePath: [*]const u8, rawFontDefinitions: [*]const u8, rawStyleOverrideDefinitions: [*]const u8, onInit: OnInitCb, onTextChanged: OnTextChangedCb, onComboChanged: OnComboChangedCb, onNumericValueChanged: OnNumericValueChangedCb, onBooleanValueChanged: OnBooleanValueChangedCb, onMultipleNumericValuesChanged: OnMultipleNumericValuesChangedCb, onClick: OnClickCb) callconv(.C) void;

extern "c" fn setElement(elementJson: [*]const u8) callconv(.C) void;

extern "c" fn setChildren(parentId: i32, childrenIdsJson: [*]const u8) callconv(.C) void;

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

fn onInit() callconv(.C) void {
    // std.debug.print("Initialized!\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var rootNodeBuffer = std.ArrayList(u8).init(allocator);
    defer rootNodeBuffer.deinit();

    var unformattedTextBuffer = std.ArrayList(u8).init(allocator);
    defer unformattedTextBuffer.deinit();

    var rootNodeBufferStream = std.json.writeStream(rootNodeBuffer.writer(), .{});
    var unformattedTextBufferStream = std.json.writeStream(unformattedTextBuffer.writer(), .{});

    rootNodeBufferStream.beginObject() catch unreachable;
    rootNodeBufferStream.objectField("id") catch unreachable;
    rootNodeBufferStream.write(0) catch unreachable;
    rootNodeBufferStream.objectField("type") catch unreachable;
    rootNodeBufferStream.write("node") catch unreachable;
    rootNodeBufferStream.endObject() catch unreachable;

    rootNodeBuffer.append(0) catch unreachable;

    const rootNodeCharArray: []const u8 = rootNodeBuffer.items;

    unformattedTextBufferStream.beginObject() catch unreachable;
    unformattedTextBufferStream.objectField("id") catch unreachable;
    unformattedTextBufferStream.write(1) catch unreachable;
    unformattedTextBufferStream.objectField("type") catch unreachable;
    unformattedTextBufferStream.write("unformatted-text") catch unreachable;
    unformattedTextBufferStream.objectField("text") catch unreachable;
    unformattedTextBufferStream.write("Hello, world") catch unreachable;
    unformattedTextBufferStream.endObject() catch unreachable;

    unformattedTextBuffer.append(0) catch unreachable;

    const unformattedTextCharArray: []const u8 = unformattedTextBuffer.items;

    setElement(rootNodeCharArray.ptr);
    setElement(unformattedTextCharArray.ptr);

    var childrenIdsBuffer = std.ArrayList(u8).init(allocator);
    defer childrenIdsBuffer.deinit();

    const children = [1]i32{1};

    std.json.stringify(children, .{}, childrenIdsBuffer.writer()) catch unreachable;

    childrenIdsBuffer.append(0) catch unreachable;

    const childrenIdsCharArray: []const u8 = childrenIdsBuffer.items;

    setChildren(0, childrenIdsCharArray.ptr);
}

fn onTextChanged(id: i32, rawValue: [*:0]const u8) callconv(.C) void {
    const value: [:0]const u8 = std.mem.span(rawValue);

    std.debug.print("Text changed {}: {s}\n", .{ id, value });
}

fn onComboChanged(id: i32, selectedIndex: i32) callconv(.C) void {
    std.debug.print("Combo changed {}: {}\n", .{ id, selectedIndex });
}

fn onNumericValueChanged(id: i32, value: f32) callconv(.C) void {
    std.debug.print("Numeric value changed {}: {}\n", .{ id, value });
}

fn onBooleanValueChanged(id: i32, value: bool) callconv(.C) void {
    std.debug.print("Boolean value changed {}: {}\n", .{ id, value });
}

fn onMultipleNumericValuesChanged(id: i32, _: *f32, numValues: i32) callconv(.C) void {
    std.debug.print("Multiple numeric values changed {}: {}\n", .{ id, numValues });
}

fn onClick(id: i32) callconv(.C) void {
    std.debug.print("Clicked {}\n", .{id});
}

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

    var fontDefBuffer = std.ArrayList(u8).init(allocator);
    defer fontDefBuffer.deinit();

    try std.json.stringify(result, .{}, fontDefBuffer.writer());

    try fontDefBuffer.append(0);

    const fontDefJson: []const u8 = fontDefBuffer.items;

    var themeBuffer = std.ArrayList(u8).init(allocator);
    defer themeBuffer.deinit();

    var stream = std.json.writeStream(themeBuffer.writer(), .{});

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

    try themeBuffer.append(0);

    const themeJsonDef: []const u8 = themeBuffer.items;

    const assetsBasePath = "./assets";

    init(assetsBasePath, fontDefJson.ptr, themeJsonDef.ptr, &onInit, &onTextChanged, &onComboChanged, &onNumericValueChanged, &onBooleanValueChanged, &onMultipleNumericValuesChanged, &onClick);

    const in = std.io.getStdIn();
    var stdinBuf = std.io.bufferedReader(in.reader());

    var r = stdinBuf.reader();

    std.debug.print("Press enter to exit the application\n", .{});
    var msg_buf: [4096]u8 = undefined;
    _ = try r.readUntilDelimiterOrEof(&msg_buf, '\n');
}
