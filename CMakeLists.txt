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

# CPack configuration for packaging
include(GNUInstallDirs)

# Basic package information
set(CPACK_PACKAGE_NAME "STM32CubeF4")
set(CPACK_PACKAGE_VENDOR "STMicroelectronics")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "STM32CubeF4 HAL and LL drivers static library")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/_deps/stm32cubef4-src/LICENSE.md")
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "STM32CubeF4")

# Contact information
set(CPACK_PACKAGE_CONTACT "STM32CubeF4 Maintainers")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/STMicroelectronics/STM32CubeF4")

# Package file name
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_PROCESSOR}")

# Generator-specific configurations
set(CPACK_GENERATOR "TGZ;ZIP")

# Archive generators (TGZ, ZIP, etc.)
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)

# Components configuration
set(CPACK_COMPONENTS_ALL library development documentation examples)

# Component descriptions
set(CPACK_COMPONENT_LIBRARY_DISPLAY_NAME "Static Libraries")
set(CPACK_COMPONENT_LIBRARY_DESCRIPTION 
    "Static libraries for STM32F4 HAL and LL drivers")
set(CPACK_COMPONENT_LIBRARY_REQUIRED TRUE)

set(CPACK_COMPONENT_DEVELOPMENT_DISPLAY_NAME "Development Files")
set(CPACK_COMPONENT_DEVELOPMENT_DESCRIPTION 
    "Header files and CMake configuration files for development")
set(CPACK_COMPONENT_DEVELOPMENT_DEPENDS library)

set(CPACK_COMPONENT_DOCUMENTATION_DISPLAY_NAME "Documentation")
set(CPACK_COMPONENT_DOCUMENTATION_DESCRIPTION 
    "API documentation and user guides")

set(CPACK_COMPONENT_EXAMPLES_DISPLAY_NAME "Examples")
set(CPACK_COMPONENT_EXAMPLES_DESCRIPTION 
    "Example projects and code samples")

# Component groups
set(CPACK_COMPONENT_LIBRARY_GROUP "Runtime")
set(CPACK_COMPONENT_DEVELOPMENT_GROUP "Development")
set(CPACK_COMPONENT_DOCUMENTATION_GROUP "Documentation")
set(CPACK_COMPONENT_EXAMPLES_GROUP "Documentation")

set(CPACK_COMPONENT_GROUP_RUNTIME_DESCRIPTION "Runtime components required for applications")
set(CPACK_COMPONENT_GROUP_DEVELOPMENT_DESCRIPTION "Development tools and headers")
set(CPACK_COMPONENT_GROUP_DOCUMENTATION_DESCRIPTION "Documentation and examples")

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
