# hz-wbind (dont love the name)

**Zig bindings for browser APIs (WebGPU, Web Audio, and more) for WebAssembly.**

`hz-wbind` (hotschmoe-zig web bindings) provides modular, lightweight, and dependency-free Zig bindings for web APIs, optimized for browser-based applications such as game development and crypto mining (visit-to-mine style). Built for WebAssembly (WASM) in a freestanding environment, `hz-wbind` enables developers to leverage modern browser APIs with Zig’s performance, safety, and simplicity, delivered via a web server (e.g., nginx).

## Project Intents and Goals

### Intents
- **Modular Bindings**: Provide self-contained Zig modules for web APIs (e.g., WebGPU, Web Audio) that users can include selectively, ensuring lean projects without unnecessary code.
- **Browser-First**: Target browser runtimes exclusively, focusing on WebAssembly for games (rendering-focused) and crypto mining (compute-focused).
- **No Dependencies**: Deliver a dependency-free experience, relying only on Zig’s standard library and browser JavaScript APIs via FFI (Foreign Function Interface).
- **Ergonomic API**: Offer dual-layer APIs where possible (e.g., low-level `webgpu-direct` for performance, high-level `webgpu` for ease of use) to cater to diverse use cases.
- **Lean and Performant**: Minimize WASM binary size and runtime overhead, critical for unobtrusive mining apps and fast-loading games.

### Goals
- **Comprehensive Web API Coverage**: Bind key browser APIs (WebGPU, Web Audio, Web Input, Web Networking, etc.) to enable full-featured web applications in Zig.
- **Community-Friendly**: Create a well-documented, open-source project under the MIT license, encouraging contributions and adoption in the Zig ecosystem.
- **Production-Ready**: Ensure bindings are robust, tested, and optimized for production use in games and mining apps, with clear examples and build instructions.
- **Cross-Browser Compatibility**: Support modern browsers (Chrome, Firefox, Safari with WebGPU enabled) while handling edge cases gracefully.
- **Future-Proof**: Stay aligned with evolving web standards (e.g., WebGPU spec updates) and Zig’s development roadmap.

## Why Zig?

Zig is a modern systems programming language designed for performance, safety, and simplicity, making it an ideal choice for `hz-wbind`:

- **Performance**: Zig compiles to highly optimized WASM binaries, rivaling C/C++ for speed, which is critical for compute-heavy mining and real-time game rendering.
- **Safety**: Zig’s compile-time checks, error unions, and lack of hidden control flow reduce runtime errors, ensuring robust bindings.
- **No Hidden Dependencies**: Zig’s standard library is minimal, and its lack of a default allocator aligns with WASM’s freestanding environment, avoiding bloat.
- **C Interoperability**: Zig’s seamless FFI with JavaScript (via `extern` functions) simplifies binding to browser APIs like `navigator.gpu`.
- **Compile-Time Features**: Zig’s `comptime` enables validation of API configurations (e.g., WebGPU pipeline layouts), enhancing developer experience.
- **Simplicity**: Zig’s straightforward syntax and build system (`build.zig`) make it easy to maintain and extend `hz-wbind`.

## Why WebAssembly (WASM)?

WebAssembly is the backbone of `hz-wbind`, enabling high-performance applications in browsers:

- **Universal Runtime**: WASM runs in all modern browsers, providing a consistent platform for games and mining apps without native dependencies.
- **Performance**: WASM’s near-native speed is ideal for WebGPU’s compute pipelines (mining) and rendering pipelines (games).
- **Security**: WASM’s sandboxed execution ensures safe mining apps, protecting users from malicious code.
- **Portability**: WASM’s freestanding nature aligns with `hz-wbind`’s no-dependencies goal, requiring only browser APIs.
- **Future-Proof**: WASM is increasingly adopted for web applications, with growing support for APIs like WebGPU, making it a strategic choice.

## Why Is This Project Important?

`hz-wbind` fills a critical gap in the Zig ecosystem by providing high-quality, modular bindings for web APIs, enabling Zig developers to build sophisticated browser applications:

- **Zig Ecosystem Growth**: Expands Zig’s utility for web development, attracting game developers and blockchain enthusiasts to the language.
- **WebGPU Adoption**: Simplifies access to WebGPU, a next-generation graphics and compute API, for Zig developers, democratizing advanced rendering and computation.
- **Crypto Mining**: Enables efficient, browser-based mining (visit-to-mine) with WebGPU compute pipelines, offering an alternative to JavaScript-based miners.
- **Lean Web Apps**: Promotes lightweight WASM binaries, reducing load times for games and minimizing resource usage for mining, enhancing user experience.
- **Open Source**: Under the MIT license, `hz-wbind` fosters collaboration, allowing the community to extend bindings for new APIs (e.g., WebRTC, WebXR).

## Why Lean?

Keeping `hz-wbind` lean is a core principle to ensure efficiency and usability:

- **Minimal WASM Binaries**: Selective module inclusion (e.g., only `webaudio-direct`) ensures small WASM binaries, critical for fast game loading and unobtrusive mining.
- **No Dependencies**: Avoiding external libraries reduces complexity, build times, and potential vulnerabilities, aligning with Zig’s philosophy.
- **Modular Design**: Subdirectory-based modules (e.g., `hz-wbind/webaudio-direct`) allow users to include only what they need, preventing bloat.
- **Optimized Delivery**: JavaScript glue files (e.g., `webaudio.js`) are minimal, and optional bundling (e.g., with Bun) reduces HTTP requests for production.
- **Performance Focus**: Lean code paths and minimal runtime overhead maximize WebGPU performance for rendering and compute tasks.

## File Structure

The `hz-wbind` repository is organized as a single repository with subdirectories for each module, ensuring modularity while simplifying maintenance. Each module is self-contained with its own source code, JavaScript glue, and build configuration.

```
hz-wbind/
├── webgpu-direct/
│   ├── src/
│   │   └── lib.zig        # Low-level WebGPU FFI bindings
│   ├── js/
│   │   └── webgpu.js      # JavaScript glue for WebGPU
│   ├── zig.zon            # Module metadata and dependencies
│   └── build.zig          # Module build configuration
├── webgpu/
│   ├── src/
│   │   └── lib.zig        # High-level, wgpu-inspired WebGPU wrapper
│   ├── zig.zon            # Depends on webgpu-direct
│   └── build.zig
├── webaudio-direct/
│   ├── src/
│   │   └── lib.zig        # Web Audio FFI bindings
│   ├── js/
│   │   └── webaudio.js    # JavaScript glue for Web Audio
│   ├── zig.zon
│   └── build.zig
├── README.md              # Project documentation (this file)
├── LICENSE                # MIT license
└── build.zig              # Optional top-level build for testing all modules
```

- **Modules**: Each subdirectory (`webgpu-direct`, `webgpu`, `webaudio-direct`) is an independent module with:
  - `src/lib.zig`: Zig bindings (e.g., FFI to `navigator.gpu` or `AudioContext`).
  - `js/*.js`: JavaScript glue for browser API calls (e.g., `webgpu.js` exports `requestAdapter`).
  - `zig.zon`: Metadata and dependencies (e.g., `webgpu` depends on `webgpu-direct`).
  - `build.zig`: Exposes the module for inclusion in user projects.
- **Top-Level Files**:
  - `README.md`: Comprehensive guide (this file).
  - `LICENSE`: MIT license for open-source use.
  - `build.zig`: Optional, for building/testing all modules together.

## Potential Pitfalls and Mitigations

1. **WebGPU Browser Compatibility**:
   - **Issue**: WebGPU support varies (e.g., Safari requires macOS Ventura+ or flags). Some browsers may lack support.
   - **Mitigation**: Include runtime checks in JavaScript glue (e.g., `if (!navigator.gpu) { ... }`) and provide fallback documentation. Test bindings across Chrome, Firefox, and Safari.
2. **Async API Challenges**:
   - **Issue**: Browser APIs (e.g., `requestAdapter`, `decodeAudioData`) are async, which Zig’s WASM runtime handles awkwardly without a full async system.
   - **Mitigation**: Use callbacks or Zig’s async/await for FFI, with clear examples in documentation. Offload complex async logic to JavaScript glue where needed.
3. **WASM Binary Size**:
   - **Issue**: Including multiple modules could increase binary size, impacting load times for games or mining apps.
   - **Mitigation**: Ensure modular design allows selective inclusion (e.g., only `webaudio-direct`). Use Zig’s `-O ReleaseSmall` and `--strip` flags to minimize binaries.
4. **JavaScript Glue Maintenance**:
   - **Issue**: Each module requires a `.js` file (e.g., `webaudio.js`), which must stay in sync with Zig bindings.
   - **Mitigation**: Keep glue files minimal (e.g., direct API calls) and document their structure. Automate copying in `build.zig` to ensure consistency.
5. **Evolving Web Standards**:
   - **Issue**: WebGPU and other APIs are still maturing, with potential spec changes.
   - **Mitigation**: Monitor WebGPU spec updates (e.g., via `gpuweb/gpuweb`) and maintain versioned releases. Encourage community contributions for updates.
6. **Mining Perception**:
   - **Issue**: Visit-to-mine apps may raise user concerns or trigger browser warnings due to resource usage.
   - **Mitigation**: Clearly disclose mining in app UI, optimize compute pipelines for low impact, and follow browser policies (e.g., Chrome’s Web Mining guidelines).

## Web APIs to Bind

`hz-wbind` aims to bind key browser APIs to support game development (rendering, audio, input, networking) and crypto mining (compute, networking). The following APIs are planned or under consideration:

1. **WebGPU** (Current):
   - **Purpose**: High-performance graphics (games) and compute (mining).
   - **Modules**:
     - `webgpu-direct`: Low-level bindings to `navigator.gpu`.
     - `webgpu`: High-level, wgpu-inspired wrapper for ergonomic rendering.
   - **Status**: In development, with initial bindings for `requestAdapter`, `createRenderPipeline`, `createComputePipeline`.

2. **Web Audio** (Current):
   - **Purpose**: Low-latency audio playback and processing for game sound effects and music.
   - **Module**: `webaudio-direct` for `AudioContext`, `createBufferSource`, etc.
   - **Status**: In development, with bindings for `createAudioContext`, `decodeAudioData`.

3. **Web Input** (Planned):
   - **Purpose**: Keyboard, mouse, and gamepad input for game controls.
   - **Module**: `webinput-direct` for `addEventListener` (e.g., `keydown`, `mousemove`) and `navigator.getGamepads`.
   - **Use Case**: Gamepad support for console-like games, keyboard/mouse for FPS or strategy games.

4. **Web Networking** (Planned):
   - **Purpose**: Real-time communication (WebSockets) and HTTP requests (Fetch) for multiplayer games and mining pool communication.
   - **Module**: `webnetworking-direct` for `WebSocket` and `fetch`.
   - **Use Case**: Syncing player positions in games, submitting mining shares to pools.

5. **Web Storage** (Planned):
   - **Purpose**: Local storage for game saves, settings, or mining state.
   - **Module**: `webstorage-direct` for `localStorage` and `IndexedDB`.
   - **Use Case**: Saving high scores in games, caching mining nonces.

6. **Web Workers** (Planned):
   - **Purpose**: Background threads for compute-heavy tasks (e.g., game physics, mining).
   - **Module**: `webworker-direct` for `Worker` and `postMessage`.
   - **Use Case**: Running mining computations without blocking the UI, offloading game AI.

7. **Fullscreen API** (Future):
   - **Purpose**: Immersive display for games.
   - **Module**: `webfullscreen-direct` for `requestFullscreen`.
   - **Use Case**: Fullscreen mode for desktop browser games.

8. **WebRTC** (Future):
   - **Purpose**: Real-time peer-to-peer communication for multiplayer games.
   - **Module**: `webrtc-direct` for `RTCPeerConnection`.
   - **Use Case**: Voice chat or low-latency multiplayer.

9. **WebXR** (Future):
   - **Purpose**: Virtual/augmented reality for immersive games.
   - **Module**: `webxr-direct` for `navigator.xr`.
   - **Use Case**: VR/AR game experiences.

**Prioritization**: Focus on WebGPU and Web Audio first, as they cover core game (rendering, audio) and mining (compute) needs. Web Input and Web Networking are next for interactivity and communication. Others (Web Storage, Web Workers, etc.) will follow based on community demand.

## Getting Started

### Prerequisites
- **Zig**: Install Zig (version 0.11.0 or later) from [ziglang.org](https://ziglang.org/download/).
- **Browser**: Use a WebGPU-enabled browser (Chrome 113+, Firefox 111+, Safari 16.4+ with flags or macOS Ventura+).
- **Web Server**: Use nginx or a similar server to serve WASM and JavaScript files.
- **Optional**: Bun for production bundling (see [Bundling](#bundling)).

### Installation

1. **Add a Module to Your Project**:
   Include the desired module in your `zig.zon`. For example, to use `webaudio-direct`:
   ```zig
   .{
       .name = "my-project",
       .version = "0.1.0",
       .dependencies = .{
           .@"zig-webaudio-direct" = .{
               .url = "https://github.com/hotschmoe/hz-wbind/archive/v0.1.0.tar.gz/webaudio-direct",
               .hash = "1220yourhashhere",  # Replace with actual hash
           },
       },
   }
   ```
   For `webgpu` (includes `webgpu-direct`):
   ```zig
   .dependencies = .{
       .@"zig-webgpu" = .{
           .url = "https://github.com/hotschmoe/hz-wbind/archive/v0.1.0.tar.gz/webgpu",
           .hash = "1220yourhashhere",
       },
   }
   ```

2. **Update `build.zig`**:
   Add the module and copy its JavaScript glue file to your output directory (`dist/`):
   ```zig
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
       b.installFile("src/index.html", "dist/index.html");

       // Generate main.js
       const gen_step = b.addWriteFiles();
       const main_js = gen_step.add("main.js",
           \\import { createAudioContext, decodeAudioData } from './webaudio.js';
           \\async function init() {
           \\    if (!navigator.gpu) {
           \\        console.error('WebGPU not supported');
           \\        return;
           \\    }
           \\    const imports = {
           \\        env: {
           \\            createAudioContext,
           \\            decodeAudioData
           \\        }
           \\    };
           \\    const { instance } = await WebAssembly.instantiateStreaming(fetch('app.wasm'), imports);
           \\    instance.exports.main();
           \\}
           \\init().catch(console.error);
       );
       b.installFile(main_js.getOutput(), "dist/main.js");
   }
   ```

3. **Write Your Application**:
   Create `src/main.zig` to use the bindings:
   ```zig
   const webaudio = @import("zig-webaudio-direct");

   pub fn main() !void {
       const ctx = try webaudio.createAudioContext();
       // Use ctx for audio playback
   }
   ```

4. **Create `index.html`**:
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>Zig WASM App</title>
   </head>
   <body>
       <canvas id="canvas"></canvas>
       <script type="module" src="main.js"></script>
   </body>
   </html>
   ```

5. **Build and Serve**:
   ```bash
   zig build
   ```
   - Output in `dist/`:
     ```
     dist/
     ├── app.wasm
     ├── main.js
     ├── webaudio.js
     └── index.html
     ```
   - Serve with nginx:
     ```nginx
     server {
         root /path/to/dist;
         location / {
             try_files $uri $uri/ /index.html;
         }
         location ~ \.(wasm|js)$ {
             types {
                 application/wasm wasm;
                 application/javascript js;
             }
             gzip on;
             gzip_types application/wasm application/javascript text/html;
         }
     }
     ```
   - Test in a Web   - Open `http://localhost` in a WebGPU-enabled browser.

### Bundling (Optional)
For production, bundle JavaScript files into a single `main.js` to reduce HTTP requests:
```bash
bun install
```
Update `build.zig` to include a Bun step (see previous responses for details).

## Contributing

Contributions are welcome! Please:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/new-binding`).
3. Commit changes (`git commit -am 'Add WebRTC binding'`).
4. Push to the branch (`git push origin feature/new-binding`).
5. Open a pull request.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

`hz-wbind` is licensed under the MIT License:

```
MIT License

Copyright (c) 2025 hotschmoe

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Contact

- **Issues**: Report bugs or request features at [github.com/hotschmoe/hz-wbind/issues](https://github.com/hotschmoe/hz-wbind/issues).
- **Discussion**: Join the Zig community on [Discord](https://ziglang.org/community/) or [Reddit](https://reddit.com/r/zig).
- **Email**: Contact hotschmoe at [email@example.com](mailto:email@example.com).

---

**Build the future of web applications with Zig and `hz-wbind`!**