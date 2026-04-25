#!/bin/bash

set -e

if [ ! -f vendor/angle/include/GLES3/gl3.h ]; then
	git submodule update --init --depth 1 vendor/angle
fi

cmake -S . -B build -DOPENGL_VERSION="ES 3.0" -DGRAPHICS=GRAPHICS_API_OPENGL_ES3
cmake --build build
