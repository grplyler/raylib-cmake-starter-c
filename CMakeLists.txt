cmake_minimum_required(VERSION 3.16)

project(raylib-starter C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Define ANGLE usage options
option(USE_ANGLE "Use ANGLE for OpenGL ES support" OFF)
option(ANGLE_PRECOMPILED "Use pre-compiled ANGLE libraries instead of building from source" ON)

if (USE_ANGLE)
    # Configure raylib to use OpenGL ES when using ANGLE
    set(OPENGL_VERSION "ES 3.0" CACHE STRING "OpenGL Version to build raylib with")
    set(GRAPHICS "GRAPHICS_API_OPENGL_ES3" CACHE STRING "Graphics API")

    # Add ANGLE include directories
    include_directories(vendor/angle/include)

    if (ANGLE_PRECOMPILED)
        # Use pre-compiled ANGLE libraries
        set(ANGLE_LIBRARY_DIR "${CMAKE_SOURCE_DIR}/libs/")
        message(STATUS "Using pre-compiled ANGLE libraries from ${ANGLE_LIBRARY_DIR}")
    else()
        # Build ANGLE from source
        add_subdirectory(vendor/angle)
        set(ANGLE_LIBRARY_DIR "${CMAKE_BINARY_DIR}/vendor/angle")
        message(STATUS "Building ANGLE from source")
    endif()
else()
    # Configure raylib to use desktop OpenGL when not using ANGLE
    set(OPENGL_VERSION "3.3" CACHE STRING "OpenGL Version to build raylib with")
    set(GRAPHICS "GRAPHICS_API_OPENGL_33" CACHE STRING "Graphics API")
endif()

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

# Configure ANGLE libraries if using ANGLE
if (USE_ANGLE)
    if (ANGLE_PRECOMPILED)
        # Determine platform-specific library names and extensions
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

        # Find pre-compiled ANGLE libraries
        find_library(ANGLE_GLESv2_LIBRARY
            NAMES ${ANGLE_GLESV2_NAME} ${LIB_PREFIX}${ANGLE_GLESV2_NAME}${LIB_EXTENSION}
            PATHS ${ANGLE_LIBRARY_DIR}
            NO_DEFAULT_PATH)

        find_library(ANGLE_EGL_LIBRARY
            NAMES ${ANGLE_EGL_NAME} ${LIB_PREFIX}${ANGLE_EGL_NAME}${LIB_EXTENSION}
            PATHS ${ANGLE_LIBRARY_DIR}
            NO_DEFAULT_PATH)

        # Check if the libraries were found
        if (NOT ANGLE_GLESv2_LIBRARY OR NOT ANGLE_EGL_LIBRARY)
            message(FATAL_ERROR "Pre-compiled ANGLE libraries not found in ${ANGLE_LIBRARY_DIR}. Looking for ${ANGLE_GLESV2_NAME} and ${ANGLE_EGL_NAME}")
        endif()

        # Set runtime path for ANGLE libraries
        if(WIN32)
            # On Windows, copy DLLs to output directory
            get_filename_component(ANGLE_GLESv2_DLL "${ANGLE_GLESv2_LIBRARY}" REALPATH)
            get_filename_component(ANGLE_EGL_DLL "${ANGLE_EGL_LIBRARY}" REALPATH)

            add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                    "${ANGLE_GLESv2_DLL}"
                    "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                    "${ANGLE_EGL_DLL}"
                    "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
                COMMENT "Copying ANGLE DLLs to output directory")
        else()
            # On macOS/Linux, set runtime path
            set_target_properties(${PROJECT_NAME} PROPERTIES
                BUILD_RPATH ${ANGLE_LIBRARY_DIR}
                INSTALL_RPATH ${ANGLE_LIBRARY_DIR})
        endif()

        # Link against pre-compiled ANGLE libraries
        target_link_libraries(${PROJECT_NAME} PRIVATE ${ANGLE_GLESv2_LIBRARY} ${ANGLE_EGL_LIBRARY})

        # Add Windows-specific system libraries when using ANGLE
        if(WIN32)
            target_link_libraries(${PROJECT_NAME} PRIVATE user32 gdi32 shell32)
        endif()

        message(STATUS "Linked against pre-compiled ANGLE libraries: ${ANGLE_GLESv2_LIBRARY}, ${ANGLE_EGL_LIBRARY}")
    else()
        # Link against ANGLE built from source
        target_link_libraries(${PROJECT_NAME} PRIVATE libGLESv2 libEGL)

        # Add Windows-specific system libraries when using ANGLE
        if(WIN32)
            target_link_libraries(${PROJECT_NAME} PRIVATE user32 gdi32 shell32)
        endif()

        message(STATUS "Linked against ANGLE libraries built from source")
    endif()
endif()
