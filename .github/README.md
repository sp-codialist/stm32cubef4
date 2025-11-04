# GitHub Actions Workflows

This directory contains automated workflows for the STM32CubeF4 project.

## Workflows

### 🚀 Build and Release (`build-and-release.yml`)
**Triggered by:** Tags starting with `v*`, pushes to `main`/`develop`, pull requests

**Purpose:** 
- Builds static libraries for multiple configurations
- Creates GitHub releases with artifacts
- Packages debug and release builds

**Artifacts:**
- `stm32cubef4-d-gnuarm14.3-static-lib.tar.gz` - Debug build
- `stm32cubef4-r-gnuarm14.3-static-lib.tar.gz` - Release build  
- `stm32cubef4-complete-{version}.tar.gz` - Combined package

### 🔄 Continuous Integration (`ci.yml`)
**Triggered by:** Pushes, pull requests

**Purpose:**
- Runs on every code change
- Performs linting and pre-commit checks
- Builds and tests multiple configurations
- Security scanning for pull requests

### 📚 Documentation (`docs.yml`)
**Triggered by:** Documentation changes, manual dispatch

**Purpose:**
- Generates PDF/HTML from Markdown files
- Deploys documentation to GitHub Pages
- Maintains automated changelog

### 🔐 Dependency Management (`dependencies.yml`)
**Triggered by:** Weekly schedule, dependency file changes

**Purpose:**
- Checks for outdated dependencies
- Scans for security vulnerabilities  
- Creates issues for required updates
- License compliance checking

## Configuration

### Build Presets
The workflows use CMake presets defined in:
- `CMakePresets/StaticLibPresets.json`
- `CMakePresets/VersionPresets.json`

### Supported Configurations
- **Debug**: `stm32cubef4-d-gnuarm14.3`
- **Release**: `stm32cubef4-r-gnuarm14.3`

### Docker Integration
All builds use Docker containers with ARM GCC toolchain for consistent, reproducible builds.

## Creating a Release

1. **Tag a version:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Automatic process:**
   - Builds are triggered for all configurations
   - Static libraries are compiled and packaged
   - GitHub release is created with artifacts
   - Release notes are auto-generated

3. **Manual verification:**
   - Check build logs in Actions tab
   - Verify artifacts are correctly packaged
   - Test downloaded libraries

## Maintenance

### Weekly Tasks (Automated)
- Dependency version checks
- Security vulnerability scans
- License compliance verification
- Issue creation for required updates

### Manual Tasks
- Review and merge dependency update PRs
- Update toolchain versions as needed
- Monitor build performance and optimization

## Troubleshooting

### Build Failures
1. Check CMake configuration in preset files
2. Verify Docker container availability
3. Check dependency versions and checksums
4. Review build logs in workflow artifacts

### Release Issues
1. Ensure tag follows `v*` pattern
2. Verify all build jobs complete successfully
3. Check artifact upload permissions
4. Validate release note generation

### Dependency Problems
1. Review weekly dependency reports
2. Check for breaking changes in updates
3. Verify SHA256 checksums match
4. Test builds after updates

## Security

- All workflows use pinned action versions
- Dependency scanning with Trivy
- SARIF reports uploaded to Security tab
- Automated vulnerability monitoring

## Performance

- Docker layer caching for faster builds
- Parallel job execution where possible
- Artifact cleanup after releases
- Optimized for CI/CD pipeline efficiency