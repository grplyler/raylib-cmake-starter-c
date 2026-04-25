cmake_minimum_required(VERSION 3.16)

project(raylib-starter C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Configure raylib to use OpenGL ES via precompiled ANGLE libraries on this branch.
set(OPENGL_VERSION "ES 3.0" CACHE STRING "OpenGL Version to build raylib with" FORCE)
set(GRAPHICS "GRAPHICS_API_OPENGL_ES3" CACHE STRING "Graphics API" FORCE)

if(APPLE)
    set(ANGLE_LIBRARY_DIR "${CMAKE_SOURCE_DIR}/libs/macos")
elseif(WIN32)
    set(ANGLE_LIBRARY_DIR "${CMAKE_SOURCE_DIR}/libs/windows")
else()
    set(ANGLE_LIBRARY_DIR "${CMAKE_SOURCE_DIR}/libs/linux")
endif()

include_directories(vendor/angle/include)

if (NOT EXISTS "${CMAKE_SOURCE_DIR}/vendor/angle/include/GLES3/gl3.h")
    message(FATAL_ERROR "ANGLE headers not found under vendor/angle/include. Initialize the ANGLE submodule for headers only, then rebuild.")
endif()

message(STATUS "Using precompiled ANGLE libraries from ${ANGLE_LIBRARY_DIR}")

add_subdirectory(vendor/raylib)

# Link required system frameworks for macOS
if(APPLE)
    find_library(COCOA_LIBRARY Cocoa)
    # find_library(OPENGL_LIBRARY OpenGL)
    find_library(IOKIT_LIBRARY IOKit)
    find_library(CORE_FOUNDATION_LIBRARY CoreFoundation)
    find_library(CORE_VIDEO_LIBRARY CoreVideo)
endif()

file(GLOB_RECURSE SOURCES "src/*.c" "include/*.h")
add_executable(${PROJECT_NAME} ${SOURCES})

# Add include directories
target_include_directories(${PROJECT_NAME} PRIVATE vendor/raygui/src)
target_include_directories(${PROJECT_NAME} PRIVATE vendor/rglayout/src)

target_link_libraries(${PROJECT_NAME} PRIVATE raylib)

if(WIN32)
    set(ANGLE_GLESV2_NAME "libGLESv2")
    set(ANGLE_EGL_NAME "libEGL")
    set(LIB_EXTENSION ".dll")
    set(LIB_PREFIX "")
elseif(APPLE)
    set(ANGLE_GLESV2_NAME "libGLESv2")
    set(ANGLE_EGL_NAME "libEGL")
    set(LIB_EXTENSION ".dylib")
    set(LIB_PREFIX "")
else()
    set(ANGLE_GLESV2_NAME "GLESv2")
    set(ANGLE_EGL_NAME "EGL")
    set(LIB_EXTENSION ".so")
    set(LIB_PREFIX "lib")
endif()

unset(ANGLE_GLESv2_LIBRARY CACHE)
unset(ANGLE_EGL_LIBRARY CACHE)

find_library(ANGLE_GLESv2_LIBRARY
    NAMES ${ANGLE_GLESV2_NAME} ${LIB_PREFIX}${ANGLE_GLESV2_NAME}${LIB_EXTENSION}
    PATHS ${ANGLE_LIBRARY_DIR}
    NO_DEFAULT_PATH)

find_library(ANGLE_EGL_LIBRARY
    NAMES ${ANGLE_EGL_NAME} ${LIB_PREFIX}${ANGLE_EGL_NAME}${LIB_EXTENSION}
    PATHS ${ANGLE_LIBRARY_DIR}
    NO_DEFAULT_PATH)

if (NOT ANGLE_GLESv2_LIBRARY OR NOT ANGLE_EGL_LIBRARY)
    message(FATAL_ERROR "Precompiled ANGLE libraries not found in ${ANGLE_LIBRARY_DIR}. Looking for ${ANGLE_GLESV2_NAME} and ${ANGLE_EGL_NAME}")
endif()

if(WIN32)
    get_filename_component(ANGLE_GLESV2_DLL "${ANGLE_GLESv2_LIBRARY}" REALPATH)
    get_filename_component(ANGLE_EGL_DLL "${ANGLE_EGL_LIBRARY}" REALPATH)

    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${ANGLE_GLESV2_DLL}"
            "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${ANGLE_EGL_DLL}"
            "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
        COMMENT "Copying ANGLE DLLs to output directory")

    target_link_libraries(${PROJECT_NAME} PRIVATE user32 gdi32 shell32)
elseif(APPLE)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${ANGLE_GLESv2_LIBRARY}"
            "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${ANGLE_EGL_LIBRARY}"
            "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
        COMMENT "Copying ANGLE dylibs to output directory")

    set_target_properties(${PROJECT_NAME} PROPERTIES
        BUILD_RPATH ${ANGLE_LIBRARY_DIR}
        INSTALL_RPATH ${ANGLE_LIBRARY_DIR})
else()
    set_target_properties(${PROJECT_NAME} PROPERTIES
        BUILD_RPATH ${ANGLE_LIBRARY_DIR}
        INSTALL_RPATH ${ANGLE_LIBRARY_DIR})
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE ${ANGLE_GLESv2_LIBRARY} ${ANGLE_EGL_LIBRARY})

message(STATUS "Linked against precompiled ANGLE libraries: ${ANGLE_GLESv2_LIBRARY}, ${ANGLE_EGL_LIBRARY}")
