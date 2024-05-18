const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const wofi = b.addExecutable(.{
        .name = "wofi",
        .target = target,
        .optimize = optimize,
    });

    wofi.addIncludePath(b.path("inc"));
    wofi.linkSystemLibrary("gtk+-3");
    wofi.linkSystemLibrary("wayland-client");
    wofi.linkSystemLibrary("gio-unix-2.0");
    wofi.linkSystemLibrary("pthread");

    wofi.linkLibC();

    wofi.addCSourceFiles(.{
        .files = &[_][]const u8{
            "src/config.c",
            "src/main.c",
            "src/map.c",
            "src/match.c",
            "src/property_box.c",
            "src/utils.c",
            "src/utils_g.c",
            "src/widget_builder.c",
            "src/wofi.c",
            "proto/wlr-layer-shell-unstable-v1-protocol.c",
            "proto/xdg-output-unstable-v1-protocol.c",
            "proto/xdg-shell-protocol.c",
            "modes/run.c",
            "modes/drun.c",
            "modes/dmenu.c",
        },
        .flags = &[_][]const u8{
        }
    });

    b.installArtifact(wofi);

    const run = b.addRunArtifact(wofi);
    const ss = b.step("run", "run");
    run.step.dependOn(b.getInstallStep());
    ss.dependOn(&run.step);
}
