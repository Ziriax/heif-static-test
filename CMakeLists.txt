cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0091 NEW)
project ("HeifNativeTest")

find_package(Threads REQUIRED)
find_package(libheif REQUIRED)
find_package(libde265 REQUIRED)

add_executable(HeifNativeTest "main.cpp")

find_path(HEIF_INCLUDE_DIR libheif/heif.h)

set_property(TARGET HeifNativeTest PROPERTY
             MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

target_link_libraries(HeifNativeTest PRIVATE heif libde265)
target_include_directories(HeifNativeTest PRIVATE ${HEIF_INCLUDE_DIR})
include_directories(${HEIF_INCLUDE_DIR})


