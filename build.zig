const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("./app.zig"),
        .target = target,
    });

    exe.addLibraryPath(b.path("./"));
    exe.linkSystemLibrary("xframesshared");
    // Additional configurations can be added here
    b.installArtifact(exe);
}
