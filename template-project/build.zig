// pull dependencies, copy .js files, create main.js and index.html, build wasm, copy all to dist folder

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });
    const optimize = .ReleaseSmall;

    const exe = b.addExecutable(.{
        .name = "app",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.addModule("zig-webaudio-direct", b.dependency("zig-webaudio-direct", .{}).module("zig-webaudio-direct"));
    exe.strip = true;

    b.installArtifact(exe);
    b.installFile(b.dependency("zig-webaudio-direct", .{}).path("js/webaudio.js").getPath(b), "dist/webaudio.js");
    b.installFile("web/index.html", "dist/index.html");
    b.installFile("web/main.js", "dist/main.js");

    // STRETCH GOAL, GENERATE MAIN.JS BASED ON DEPENDENCIES
    // // Generate main.js
    // const gen_step = b.addWriteFiles();
    // const main_js = gen_step.add("main.js",
    //     \\import { createAudioContext, decodeAudioData } from './webaudio.js';
    //     \\async function init() {
    //     \\    if (!navigator.gpu) {
    //     \\        console.error('WebGPU not supported');
    //     \\        return;
    //     \\    }
    //     \\    const imports = {
    //     \\        env: {
    //     \\            createAudioContext,
    //     \\            decodeAudioData
    //     \\        }
    //     \\    };
    //     \\    const { instance } = await WebAssembly.instantiateStreaming(fetch('app.wasm'), imports);
    //     \\    instance.exports.main();
    //     \\}
    //     \\init().catch(console.error);
    // );
    // b.installFile(main_js.getOutput(), "dist/main.js");
}
