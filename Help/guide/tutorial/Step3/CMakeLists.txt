cmake_minimum_required(VERSION 3.10)

# 设置工程名及版本号
project(Tutorial VERSION 1.0)

# 指定C++标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# 是否使用我们自己的数学函数
option(USE_MYMATH "Use tutorial provided math implementation" ON)

# 配置一个头文件，将一些CMake设置
# 传递到源代码
configure_file(TutorialConfig.h.in TutorialConfig.h)

# TODO 2: Remove EXTRA_INCLUDES list

# add the MathFunctions library
if(USE_MYMATH)
  add_subdirectory(MathFunctions)
  list(APPEND EXTRA_LIBS MathFunctions)
  list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")
endif()

# 添加可执行文件
add_executable(Tutorial tutorial.cxx)

target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS})

# TODO 3: Remove use of EXTRA_INCLUDES

# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           ${EXTRA_INCLUDES}
                           )
