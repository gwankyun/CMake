cmake_minimum_required(VERSION 3.24...3.28)
project(cxx_modules_multi_config_consumer CXX)

find_package(importable REQUIRED)

add_executable(consumer main.cxx)
target_link_libraries(consumer PRIVATE CXXModules::importable)
target_compile_features(consumer PRIVATE cxx_std_20)

add_test(NAME consumer COMMAND consumer)
