cmake_minimum_required(VERSION 3.15)
project(MathFunctionsComponents)

# make cache variables for install destinations
# 为安装目录创建缓存变量
include(GNUInstallDirs)

# specify the C++ standard
# 指定 C++ 标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_subdirectory(Addition)
add_subdirectory(SquareRoot)

# include CMakePackageConfigHelpers macro
include(CMakePackageConfigHelpers)

# set version
# 设置版本
set(version 3.4.1)

# generate the version file for the config file
# 为配置文件生成版本文件
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfigVersion.cmake"
  VERSION "${version}"
  COMPATIBILITY AnyNewerVersion
)

# create config file
# 创建配置文件
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfig.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/MathFunctions
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

# install config files
# 安装配置文件
install(FILES
          "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfig.cmake"
          "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/MathFunctions
)
