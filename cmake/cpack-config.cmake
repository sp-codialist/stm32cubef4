# Advanced CPack configuration for STM32CubeF4 library packaging
# This file provides additional packaging options and generators

# Include the main CPack module
include(CPack)

# Function to add essential documentation (license only)
function(add_essential_documentation_install)
    # Install only essential license file with the library component
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/_deps/stm32cubef4-src/LICENSE.md")
        install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/_deps/stm32cubef4-src/LICENSE.md"
                DESTINATION ${CMAKE_INSTALL_DOCDIR}
                COMPONENT library)
    endif()
endfunction()

# Archive-only packaging - no platform-specific generators

# Custom package naming for different build types
string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE_LOWER)
if(BUILD_TYPE_LOWER STREQUAL "debug")
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_PROCESSOR}-debug")
elseif(BUILD_TYPE_LOWER STREQUAL "release")
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_PROCESSOR}-release")
endif()

# Toolchain-specific naming
if(DEFINED CMAKE_TOOLCHAIN_FILE)
    get_filename_component(TOOLCHAIN_NAME ${CMAKE_TOOLCHAIN_FILE} NAME_WE)
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_FILE_NAME}-${TOOLCHAIN_NAME}")
endif()

# Add version string with git information if available
find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_SHORT_SHA
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if(GIT_SHORT_SHA)
        set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_FILE_NAME}-${GIT_SHORT_SHA}")
    endif()
endif()

# Call the install functions
add_essential_documentation_install()

# Validate required files exist
if(NOT EXISTS "${CPACK_RESOURCE_FILE_LICENSE}")
    message(WARNING "License file not found: ${CPACK_RESOURCE_FILE_LICENSE}")
    unset(CPACK_RESOURCE_FILE_LICENSE)
endif()

if(NOT EXISTS "${CPACK_PACKAGE_DESCRIPTION_FILE}")
    message(WARNING "Description file not found: ${CPACK_PACKAGE_DESCRIPTION_FILE}")
    unset(CPACK_PACKAGE_DESCRIPTION_FILE)
endif()

# Print packaging information
message(STATUS "CPack configuration:")
message(STATUS "  Package name: ${CPACK_PACKAGE_NAME}")
message(STATUS "  Package version: ${CPACK_PACKAGE_VERSION}")
message(STATUS "  Package file name: ${CPACK_PACKAGE_FILE_NAME}")
message(STATUS "  Generators: ${CPACK_GENERATOR}")
message(STATUS "  Components: ${CPACK_COMPONENTS_ALL}")