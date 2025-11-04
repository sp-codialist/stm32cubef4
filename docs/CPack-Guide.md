# CPack Packaging Guide for STM32CubeF4

This document describes how to create packages for the STM32CubeF4 static library using CMake's CPack utility.

## Overview

The STM32CubeF4 project uses CPack to generate archive packages:

- **TGZ Archives**: Compressed tar archives (.tar.gz)
- **ZIP Archives**: Cross-platform zip files (.zip)

## Quick Start

### Building Packages

```bash
# Configure the project
cmake --preset stm32cubef4-r-gnuarm14.3

# Build the project  
cmake --build --preset stm32cubef4-r-gnuarm14.3

# Create packages
cd build/stm32cubef4-r-gnuarm14.3
cpack
```

### Specifying Package Types

```bash
# Create only TGZ archive
cpack -G TGZ

# Create only ZIP archive
cpack -G ZIP

# Create both formats (default)
cpack -G "TGZ;ZIP"
```

## Package Components

The library is packaged into logical components:

### Library Component (Required)
- Static library files (`.a`)
- Runtime dependencies
- Essential files for linking

### Development Component  
- Header files (`.h`)
- CMake configuration files
- pkg-config files
- Build presets and templates

### Documentation Component
- README files
- API documentation
- License files
- Release notes

### Examples Component
- Sample projects
- Code examples
- Project templates

## Configuration Options

### Basic Settings

```cmake
# Package identification
set(CPACK_PACKAGE_NAME "STM32CubeF4")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_VENDOR "STMicroelectronics")

# Package description
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "STM32CubeF4 HAL and LL drivers static library")
```

### Component Configuration

```cmake
# Define components
set(CPACK_COMPONENTS_ALL library development documentation examples)

# Component properties
set(CPACK_COMPONENT_LIBRARY_REQUIRED TRUE)
set(CPACK_COMPONENT_DEVELOPMENT_DEPENDS library)
```

### Archive Settings

```cmake
# Archive generators (TGZ, ZIP)
set(CPACK_GENERATOR "TGZ;ZIP")
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)

# Source package configuration
set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_SOURCE_IGNORE_FILES "/\\.git/" "/build/" "/_deps/")
```

## Advanced Features

### Build Type Specific Packaging

The configuration automatically adjusts package names based on build type:

- Debug builds: `STM32CubeF4-x.x.x-arch-debug.tar.gz`
- Release builds: `STM32CubeF4-x.x.x-arch-release.tar.gz`

### Toolchain-Specific Naming

Packages include toolchain information when cross-compiling:

- `STM32CubeF4-x.x.x-arm-gnuarm14.3.tar.gz`

### Git Integration

If built from a Git repository, packages include commit SHA:

- `STM32CubeF4-x.x.x-arm-abc1234.tar.gz`

### Source Packages

Create source packages with:

```bash
cpack --config CPackSourceConfig.cmake
```

This creates source archives excluding build directories and temporary files.

## Installation Examples

### Using Archive

```bash
# Extract TGZ archive
tar -xzf STM32CubeF4-*.tar.gz

# Or extract ZIP archive  
unzip STM32CubeF4-*.zip

# Set environment
export CMAKE_PREFIX_PATH="/path/to/extracted/STM32CubeF4:$CMAKE_PREFIX_PATH"

# Use in CMake project
find_package(stm32cubef4 REQUIRED)
target_link_libraries(my_app stm32cubef4::framework)
```

## Customization

### Adding Custom Files

Create custom installation rules:

```cmake
# Install custom documentation
install(FILES custom-guide.pdf 
        DESTINATION ${CMAKE_INSTALL_DOCDIR}
        COMPONENT documentation)

# Install custom examples
install(DIRECTORY my-examples/
        DESTINATION ${CMAKE_INSTALL_DATADIR}/stm32cubef4/examples
        COMPONENT examples)
```

### Custom Archive Options

Customize archive generation in `cmake/cpack-config.cmake`:

```cmake
# Custom compression for TGZ
set(CPACK_ARCHIVE_TGZ_COMPRESSION_LEVEL 9)

# Custom file naming
set(CPACK_ARCHIVE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
```

## Troubleshooting

### Common Issues

1. **Missing License File**
   ```
   Warning: License file not found
   ```
   Solution: Ensure `LICENSE` or `LICENSE.md` exists in project root.

2. **Package Generation Fails**
   ```
   CPack Error: Cannot find the file "..."
   ```
   Solution: Check that all referenced files exist and install rules are correct.

3. **Component Dependencies**
   ```
   Error: Component X depends on Y but Y is not selected
   ```
   Solution: Verify component dependency declarations.

### Debug Information

Enable verbose CPack output:

```bash
cpack --verbose
cpack --debug
```

Check generated package contents:

```bash
# For TGZ packages
tar -tzf package.tar.gz

# For ZIP packages
unzip -l package.zip
```

## CI/CD Integration

The GitHub Actions workflows automatically:

1. Build packages for multiple configurations
2. Test package generation in CI
3. Upload packages as release assets
4. Create combined development packages

### Manual Workflow Trigger

```bash
# Trigger package build
git tag v1.0.0
git push origin v1.0.0
```

This will:
- Build debug and release packages
- Create GitHub release with assets
- Generate combined package with both variants

## Best Practices

1. **Version Management**: Use semantic versioning (x.y.z)
2. **Component Organization**: Keep related files in same component
3. **Dependencies**: Clearly specify package dependencies
4. **Documentation**: Include comprehensive usage instructions
5. **Testing**: Test packages on target platforms before release
6. **Naming**: Use consistent, descriptive package names
7. **Size Optimization**: Exclude unnecessary files from packages

## Further Reading

- [CPack Documentation](https://cmake.org/cmake/help/latest/module/CPack.html)
- [CMake Installation Guide](https://cmake.org/cmake/help/latest/command/install.html)
- [Package Component Documentation](https://cmake.org/cmake/help/latest/module/CPackComponent.html)