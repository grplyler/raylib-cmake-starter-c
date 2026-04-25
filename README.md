# Raylib CMake Starter for C

This is a starter project for using [Raylib](https://www.raylib.com/) with C and CMake.
It comes packaged with Raylib, RayGUI, and RGLayout for advanced GUI layouts.

## Getting Started

1. Clone this repository
2. Initialize the submodules: `git submodule update --init --recursive`
3. Build `./b`
4. Run `./r`

## ANGLE Branch

This branch is configured to build with Google ANGLE by default.
It links against precompiled ANGLE libraries from the platform-specific folder under `libs/` and does not support building ANGLE from source.

### Build And Run

```bash
./b
./r
```

### Using Your Own ANGLE Libraries

If you want to use different ANGLE libraries:

1. **Get ANGLE libraries from Google Chrome:**

   On macOS:
   ```bash
   cd /Applications/Google\ Chrome.app
   find ./ -name libGLESv2.dylib
   find ./ -name libEGL.dylib
   ```

   On Windows:
   ```bash
   # Look in Chrome installation directory for:
   # libGLESv2.dll
   # libEGL.dll
   ```

2. **Replace the libraries in your platform directory under `libs/`:**

   On macOS, copy your ANGLE libraries to `libs/macos/`, replacing the existing ones.
   On Windows, use `libs/windows/`.

## Build Scripts

- `./b` - Build this branch with precompiled ANGLE libraries
- `./r` - Run the ANGLE build

## CMake Configuration Options

This branch does not expose a source-vs-precompiled ANGLE toggle.
The default manual CMake configuration is:

```bash
cmake -S . -B build
cmake --build build
```

## Platform Support

- **Windows**: Supported with precompiled ANGLE libraries
- **macOS**: Supported with precompiled ANGLE libraries
- **Linux**: Precompiled ANGLE workflow is untested

## Dependencies

- [Raylib](https://www.raylib.com/) - Game development library
- [RayGUI](https://github.com/raysan5/raygui) - Immediate mode GUI for Raylib
- [RGLayout](https://github.com/your-repo/rglayout) - Advanced layout system for RayGUI
- [ANGLE](https://chromium.googlesource.com/angle/angle) - OpenGL ES implementation

## Features

- Cross-platform C development with CMake
- Advanced GUI layouts with RGLayout
- ANGLE-enabled build for better performance on Apple Silicon
- Automatic library detection and platform-specific linking
- Hot-reload friendly development workflow
