# Advanced CPack configuration for STM32CubeF4 library packaging
# This file provides additional packaging options and generators

# Include the main CPack module
include(CPack)

# Function to add install rules for documentation
function(add_documentation_install)
    # Install README files
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
        install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/README.md"
                DESTINATION ${CMAKE_INSTALL_DOCDIR}
                COMPONENT documentation)
    endif()
    
    # Install license files
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
        install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE"
                DESTINATION ${CMAKE_INSTALL_DOCDIR}
                COMPONENT documentation)
    endif()
    
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.md")
        install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.md"
                DESTINATION ${CMAKE_INSTALL_DOCDIR}
                COMPONENT documentation)
    endif()
    
    # Install release notes
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/CHANGELOG.md")
        install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/CHANGELOG.md"
                DESTINATION ${CMAKE_INSTALL_DOCDIR}
                COMPONENT documentation)
    endif()
    
    # Install any documentation directory
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Documentation" AND IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Documentation")
        install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Documentation/"
                DESTINATION ${CMAKE_INSTALL_DOCDIR}
                COMPONENT documentation
                PATTERN "*.pdf"
                PATTERN "*.html"
                PATTERN "*.md")
    endif()
endfunction()

# Function to add install rules for examples
function(add_examples_install)
    # Check if there are example projects
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Examples" AND IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Examples")
        install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Examples/"
                DESTINATION ${CMAKE_INSTALL_DATADIR}/${CPACK_PACKAGE_NAME}/examples
                COMPONENT examples
                PATTERN "build*" EXCLUDE
                PATTERN ".git*" EXCLUDE)
    endif()
    
    # Install project templates if available
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Projects" AND IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Projects")
        install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Projects/"
                DESTINATION ${CMAKE_INSTALL_DATADIR}/${CPACK_PACKAGE_NAME}/projects
                COMPONENT examples
                PATTERN "build*" EXCLUDE
                PATTERN "_deps*" EXCLUDE
                PATTERN ".git*" EXCLUDE)
    endif()
endfunction()

# Function to create development package
function(add_development_install)
    # Install CMake files for find_package support
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
        install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/cmake/"
                DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${CPACK_PACKAGE_NAME}
                COMPONENT development
                FILES_MATCHING PATTERN "*.cmake")
    endif()
    
    # Install CMake presets for easy configuration
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/CMakePresets.json")
        install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/CMakePresets.json"
                DESTINATION ${CMAKE_INSTALL_DATADIR}/${CPACK_PACKAGE_NAME}
                COMPONENT development)
    endif()
    
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/CMakePresets")
        install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/CMakePresets/"
                DESTINATION ${CMAKE_INSTALL_DATADIR}/${CPACK_PACKAGE_NAME}/CMakePresets
                COMPONENT development
                FILES_MATCHING PATTERN "*.json")
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
add_documentation_install()
add_examples_install()
add_development_install()

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