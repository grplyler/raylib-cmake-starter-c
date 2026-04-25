cmake_minimum_required(VERSION 3.16)

project(raylib-starter C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(OPENGL_VERSION "3.3" CACHE STRING "OpenGL Version to build raylib with")
set(GRAPHICS "GRAPHICS_API_OPENGL_33" CACHE STRING "Graphics API")

add_subdirectory(vendor/raylib)

file(GLOB_RECURSE SOURCES "src/*.c" "include/*.h")
add_executable(${PROJECT_NAME} ${SOURCES})

# Add include directories
target_include_directories(${PROJECT_NAME} PRIVATE vendor/raygui/src)
target_include_directories(${PROJECT_NAME} PRIVATE vendor/rglayout/src)

target_link_libraries(${PROJECT_NAME} PRIVATE raylib)
