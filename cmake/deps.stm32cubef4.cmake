# dependency on the STM32CubeF4 firmware is brought by CPM as a package
CPMAddPackage (
    NAME        STM32CubeF4
    URL         https://github.com/STMicroelectronics/STM32CubeF4/archive/refs/tags/${GITHUB_BRANCH_stm32cubef4}.tar.gz
    URL_HASH    SHA256=c4d121386fc1b0d6566c4ae9e08af14b24eea089250a0e86ff341dcf7ddb256e
)
