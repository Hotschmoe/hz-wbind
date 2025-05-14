const webaudio = @import("zig-webaudio-direct");

pub fn main() !void {
    const ctx = try webaudio.createAudioContext();
    try playTone(ctx);
}

fn playTone(ctx: webaudio.AudioContext) !void {
    const oscillator = try ctx.createOscillator();
    try oscillator.connect(ctx.destination());
    try oscillator.start(0);
}
