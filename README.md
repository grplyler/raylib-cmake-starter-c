# Raylib CMake Starter for C

This is a starter project for using [Raylib](https://www.raylib.com/) with C and CMake.
It comes packaged with Raylib, RayGUI, and RGLayout for advanced GUI layouts.

## Getting Started

1. Clone this repository
2. Initialize the submodules: `git submodule update --init --recursive`
3. Build `./b`
4. Run `./r`

## Building with Google ANGLE (At least double the capable draw calls on Apple Silicone)

ANGLE (Almost Native Graphics Layer Engine) provides better performance on Apple Silicon and cross-platform OpenGL ES compatibility.

### Using Pre-compiled ANGLE Libraries (Included)

The project includes pre-compiled ANGLE libraries in the `libs/` directory for convenience.

**Build with ANGLE:**
```bash
./ba  # Build with ANGLE
./ra  # Run with ANGLE
```

### Building ANGLE from Source

If you want to build ANGLE from source (requires ANGLE submodule):

```bash
./bas  # Build with ANGLE from source
```

### Using Your Own ANGLE Libraries (Optional)

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

2. **Replace the libraries in `libs/` directory:**

   Copy your ANGLE libraries to the `libs/` folder, replacing the existing ones.

## Build Scripts

- `./b` - Standard build using desktop OpenGL
- `./ba` - Build with ANGLE using pre-compiled libraries
- `./bas` - Build with ANGLE from source
- `./r` - Run the standard build
- `./ra` - Run the ANGLE build

## CMake Configuration Options

The project supports several CMake options:

- `USE_ANGLE=OFF` - Use ANGLE for OpenGL ES support (default: OFF)
- `ANGLE_PRECOMPILED=ON` - Use pre-compiled ANGLE libraries vs building from source (default: ON)

Example manual CMake configuration:
```bash
cmake -B build -DUSE_ANGLE=ON -DANGLE_PRECOMPILED=ON
cmake --build build
```

## Platform Support

- **Windows**: ✅ Supported (both standard OpenGL and ANGLE)
- **macOS**: ✅ Supported (both standard OpenGL and ANGLE)
- **Linux**: ✅ Supported (standard OpenGL, ANGLE support untested)

## Dependencies

- [Raylib](https://www.raylib.com/) - Game development library
- [RayGUI](https://github.com/raysan5/raygui) - Immediate mode GUI for Raylib
- [RGLayout](https://github.com/your-repo/rglayout) - Advanced layout system for RayGUI
- [ANGLE](https://chromium.googlesource.com/angle/angle) (Optional) - OpenGL ES implementation

## Features

- Cross-platform C development with CMake
- Advanced GUI layouts with RGLayout
- Optional ANGLE support for better performance on Apple Silicon
- Automatic library detection and platform-specific linking
- Hot-reload friendly development workflow

## TODO

- [x] Support for ANGLE on Windows and macOS
- [x] Cross-platform CMake configuration
- [x] Automatic ANGLE library detection
- [x] Build script for ANGLE from source
- [ ] Linux ANGLE support testing
- [ ] Add ENet for Networking
- [ ] Package management with vcpkg/Conan
