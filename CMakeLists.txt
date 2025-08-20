cmake_minimum_required(VERSION 3.16)

project(raylib-starter C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_subdirectory(vendor/raylib)

file(GLOB_RECURSE SOURCES "src/*.c" "include/*.h")
add_executable(${PROJECT_NAME} ${SOURCES})
target_link_libraries(${PROJECT_NAME} PRIVATE raylib)

# Add raylib include directory
target_include_directories(${PROJECT_NAME} PRIVATE vendor/raylib/src)

# Add rglayout include directory (header-only; do NOT add_subdirectory)
target_include_directories(${PROJECT_NAME} PRIVATE vendor/rglayout/src)

# Add raygui include directory
target_include_directories(${PROJECT_NAME} PRIVATE vendor/raygui/src)
