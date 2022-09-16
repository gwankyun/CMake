cmake_minimum_required(VERSION 3.10)

# 设置工程名和版本号
project(Tutorial VERSION 1.0)

# 指定C++标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# 配置一个头文件以传递一些CMake设置
# 到源码中
configure_file(TutorialConfig.h.in TutorialConfig.h)

# 添加一个可执行文件
add_executable(Tutorial tutorial.cxx)

# 添加二进制目录到引用文件的搜索路径
# 以便找到TutorialConfig.h
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           )
