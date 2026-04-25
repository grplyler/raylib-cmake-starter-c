# Raylib CMake Starter for C

This is a starter project for using [Raylib](https://www.raylib.com/) with C and CMake.
It comes packaged with Raylib, RayGUI, and RGLayout for advanced GUI layouts.

## Getting Started

1. Clone this repository
2. Initialize the submodules: `git submodule update --init --recursive`
3. Build `./b`
4. Run `./r`

## ANGLE Support

The `master` branch does not clone, build, or link ANGLE. It is the plain desktop OpenGL starter.

If you want ANGLE support, use the dedicated `angle` branch:

```bash
git fetch origin angle
git switch angle
git submodule update --init --recursive
./ba
./ra
```

If you want to keep your current `master` checkout intact, use a separate worktree:

```bash
git fetch origin angle
git worktree add ../raylib-cmake-starter-c-angle angle
cd ../raylib-cmake-starter-c-angle
git submodule update --init --recursive
./ba
./ra
```

## Build Scripts

- `./b` - Standard build using desktop OpenGL
- `./r` - Run the standard build

## Platform Support

- **Windows**: ✅ Supported
- **macOS**: ✅ Supported
- **Linux**: ✅ Supported

## Dependencies

- [Raylib](https://www.raylib.com/) - Game development library
- [RayGUI](https://github.com/raysan5/raygui) - Immediate mode GUI for Raylib
- [RGLayout](https://github.com/your-repo/rglayout) - Advanced layout system for RayGUI

## Features

- Cross-platform C development with CMake
- Advanced GUI layouts with RGLayout
- Hot-reload friendly development workflow

## TODO

- [ ] Add ENet for Networking
- [ ] Package management with vcpkg/Conan
