
# Remove the first character from GITHUB_BRANCH_stm32cubef4 and store in versionxx
string(SUBSTRING ${GITHUB_BRANCH_stm32cubef4} 1 -1 versionxx)

set (GITHUB_BRANCH_stm32cubexx ${versionxx} CACHE STRING "GitHub branch for stm32cubexx")

set (GITHUB_BRANCH_stm32cubexx_SHA ${GITHUB_BRANCH_stm32cubef4_SHA256} CACHE STRING "GitHub branch SHA256 for stm32cubexx")

include (${cmake_scripts_SOURCE_DIR}/silicon/st/stm32cubexx.cmake)