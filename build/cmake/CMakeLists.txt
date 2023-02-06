cmake_minimum_required(VERSION 3.24)
project(iptables LANGUAGES C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)

set(CMAKE_C_FLAGS "")
set(CMAKE_CXX_FLAGS "")

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# File options
add_definitions("-DNDEBUG")

# Compile flags
set(GLOBAL_CFLAGS
	"-Os"
	"-fdata-sections"
	"-ffunction-sections"
	"-funwind-tables"
	"-fstack-protector-strong"
	"-D_FORTIFY_SOURCE=2"
	"-no-canonical-prefixes"
	"-fvisibility=hidden"
	"-fvisibility-inlines-hidden"
	"-fno-exceptions"
	"-fno-rtti"
)

# Linker flags
set(GLOBAL_LDFLAGS
	"-fstack-protector-strong"
	"-Wl,--fatal-warnings"
	"-Qunused-arguments"
	"-Wl,--no-undefined"
	"-Wl,--gc-sections"
	"-static"
	"-s"
)

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
	list(APPEND GLOBAL_CFLAGS "-fdiagnostics-color=always")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	list(APPEND GLOBAL_CFLAGS "-fcolor-diagnostics")
endif()

if (CMAKE_SYSTEM_NAME MATCHES "Android")
	list(APPEND GLOBAL_CFLAGS "-mllvm" "-polly")
	list(APPEND GLOBAL_LDFLAGS "-Wl,--build-id=none")
endif()

add_compile_options("$<$<COMPILE_LANGUAGE:C>:${GLOBAL_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${GLOBAL_CFLAGS}>")
add_link_options("$<$<LINK_LANGUAGE:C>:${GLOBAL_LDFLAGS}>" "$<$<LINK_LANGUAGE:CXX>:${GLOBAL_LDFLAGS}>")

# Git submodule
execute_process(COMMAND git submodule init)
execute_process(COMMAND git submodule update)

set(SRC_DIR "${PROJECT_SOURCE_DIR}/../../src")

# Project headers
include(headers.cmake)

set(iptables_default_cflags
	"-D_LARGEFILE_SOURCE=1"
	"-D_LARGE_FILES"
	"-D_FILE_OFFSET_BITS=64"
	"-D_REENTRANT"
	"-DENABLE_IPV4"
	"-DENABLE_IPV6"
	"-Wall"
	"-Werror"
	"-Wno-pointer-arith"
	"-Wno-sign-compare"
	"-Wno-unused-parameter"
)

# Start building
add_subdirectory(lib)
add_subdirectory(iptables)
