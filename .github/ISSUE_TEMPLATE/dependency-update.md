---
title: Weekly Dependency Update Check
labels: ["dependencies", "maintenance"]
assignees: []
---

## 📦 Dependency Status Report

This issue is automatically created to track the status of project dependencies.

### Current Status
<!-- This will be filled by the automated workflow -->

### Action Items
- [ ] Review dependency report
- [ ] Update outdated dependencies if needed
- [ ] Address any security vulnerabilities
- [ ] Test updated dependencies
- [ ] Update version presets if necessary

### Files to Check
- `CMakePresets/VersionPresets.json` - Version definitions
- `cmake/deps.stm32cubef4.cmake` - STM32CubeF4 dependency
- `cmake/deps.toolchain.cmake` - Toolchain dependencies

### Manual Steps
1. Check the latest STM32CubeF4 releases at: https://github.com/STMicroelectronics/STM32CubeF4/releases
2. Update version numbers in `VersionPresets.json`
3. Verify SHA256 checksums
4. Test build with updated dependencies
5. Update documentation if needed

---
*This issue was created automatically by the dependency management workflow.*