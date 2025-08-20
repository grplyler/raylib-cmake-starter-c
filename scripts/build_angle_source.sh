#!/bin/bash

# Build with ANGLE from source
cmake -DUSE_ANGLE=ON -DANGLE_PRECOMPILED=OFF -B build_angle_source
cmake --build build_angle_source
