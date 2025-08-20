#!/bin/bash

# Build with ANGLE using pre-compiled libraries (default)
cmake -DUSE_ANGLE=ON -DANGLE_PRECOMPILED=ON -B build_angle
cmake --build build_angle
