# minimum cmake version
cmake_minimum_required (VERSION 3.12)
include (CMakePrintHelpers)

# set the location of all fetched dependencies
set (FETCHCONTENT_BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/_deps")
# download cpm.cmake
file (
    DOWNLOAD
    https://github.com/cpm-cmake/CPM.cmake/releases/download/${GITHUB_BRANCH_cpm}/CPM.cmake
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/CPM.cmake"
    EXPECTED_HASH SHA256=${GITHUB_BRANCH_cpm_SHA256}
)

include (cmake/CPM.cmake)
include (cmake/deps.toolchain.cmake)
include (cmake/deps.stm32cubef4.cmake)
include (cmake/stm32cubef4.lib.cmake)
project (
    stm32cubef4_lib
    VERSION 0.0.0.255
    LANGUAGES CXX C
    DESCRIPTION "STM32CubeF4 library with CMake integration"
)

set (CMAKE_EXPORT_COMPILE_COMMANDS "ON")
