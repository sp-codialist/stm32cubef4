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
project (
    stm32cubef4_lib
    VERSION 0.0.0.255
    LANGUAGES CXX C
    DESCRIPTION "STM32CubeF4 library with CMake integration"
)

include (cmake/deps.stm32cubef4.cmake)
set (CMAKE_EXPORT_COMPILE_COMMANDS "ON")

# Extract STM32CubeF4 version from GITHUB_BRANCH_stm32cubef4 for CPack
if(DEFINED GITHUB_BRANCH_stm32cubef4)
    # Remove 'v' prefix from version string (e.g., "v1.28.3" -> "1.28.3")
    string(REPLACE "v" "" STM32CUBEF4_VERSION ${GITHUB_BRANCH_stm32cubef4})
    message(STATUS "Using STM32CubeF4 version: ${STM32CUBEF4_VERSION} from ${GITHUB_BRANCH_stm32cubef4}")
    
    # Parse version components for CPack
    string(REPLACE "." ";" VERSION_LIST ${STM32CUBEF4_VERSION})
    list(LENGTH VERSION_LIST VERSION_LIST_LENGTH)
    list(GET VERSION_LIST 0 STM32CUBEF4_VERSION_MAJOR)
    if(VERSION_LIST_LENGTH GREATER 1)
        list(GET VERSION_LIST 1 STM32CUBEF4_VERSION_MINOR)
    else()
        set(STM32CUBEF4_VERSION_MINOR 0)
    endif()
    if(VERSION_LIST_LENGTH GREATER 2)
        list(GET VERSION_LIST 2 STM32CUBEF4_VERSION_PATCH)
    else()
        set(STM32CUBEF4_VERSION_PATCH 0)
    endif()
else()
    # Fallback to project version if GITHUB_BRANCH_stm32cubef4 is not defined
    set(STM32CUBEF4_VERSION ${PROJECT_VERSION})
    set(STM32CUBEF4_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
    set(STM32CUBEF4_VERSION_MINOR ${PROJECT_VERSION_MINOR})
    set(STM32CUBEF4_VERSION_PATCH ${PROJECT_VERSION_PATCH})
    message(STATUS "Using fallback project version: ${STM32CUBEF4_VERSION}")
endif()

# CPack configuration for packaging
include(GNUInstallDirs)

# Basic package information
set(CPACK_PACKAGE_NAME "STM32CubeF4")
set(CPACK_PACKAGE_VENDOR "STMicroelectronics")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "STM32CubeF4 HAL and LL drivers static library")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/_deps/stm32cubef4-src/LICENSE.md")
set(CPACK_PACKAGE_VERSION_MAJOR ${STM32CUBEF4_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${STM32CUBEF4_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${STM32CUBEF4_VERSION_PATCH})
set(CPACK_PACKAGE_VERSION ${STM32CUBEF4_VERSION})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "STM32CubeF4")

# Contact information
set(CPACK_PACKAGE_CONTACT "STM32CubeF4 Maintainers")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/STMicroelectronics/STM32CubeF4")

# Package file name
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_PROCESSOR}")

# Generator-specific configurations
set(CPACK_GENERATOR "TGZ;ZIP")

# Archive generators (TGZ, ZIP, etc.)
set(CPACK_ARCHIVE_COMPONENT_INSTALL OFF)

# Components configuration - only library (includes headers and cmake files)
set(CPACK_COMPONENTS_ALL library)

# Component descriptions
set(CPACK_COMPONENT_LIBRARY_DISPLAY_NAME "STM32CubeF4 Static Library")
set(CPACK_COMPONENT_LIBRARY_DESCRIPTION 
    "Static libraries, header files, and CMake configuration files for STM32F4 HAL and LL drivers")
set(CPACK_COMPONENT_LIBRARY_REQUIRED TRUE)

# Source package configuration
set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-src")
set(CPACK_SOURCE_IGNORE_FILES
    "/\\.git/"
    "/\\.gitignore"
    "/build/"
    "/_deps/"
    "/\\.vs/"
    "/\\.vscode/"
    "\\.swp$"
    "\\.swo$"
    "~$")

# Include advanced CPack configuration
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack-config.cmake)
