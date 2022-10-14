# TODO 4: Update the minimum required version to 3.15

cmake_minimum_required(VERSION 3.10)

# 设置工程名及版本号
project(Tutorial VERSION 1.0)

# TODO 1: Replace the following code by:
# * Creating an interface library called tutorial_compiler_flags
#   Hint: use add_library() with the INTERFACE signature
# * Add compiler feature cxx_std_11 to tutorial_compiler_flags
#   Hint: Use target_compile_features()

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# TODO 5: Create helper variables to determine which compiler we are using:
# * Create a new variable gcc_like_cxx that is true if we are using CXX and
#   any of the following compilers: ARMClang, AppleClang, Clang, GNU, LCC
# * Create a new variable msvc_cxx that is true if we are using CXX and MSVC
# Hint: Use set() and COMPILE_LANG_AND_ID

# TODO 6: Add warning flag compile options to the interface library
# tutorial_compiler_flags.
# * For gcc_like_cxx, add flags -Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused
# * For msvc_cxx, add flags -W3
# Hint: Use target_compile_options()

# TODO 7: With nested generator expressions, only use the flags for the
# build-tree
# Hint: Use BUILD_INTERFACE

# should we use our own math functions
option(USE_MYMATH "Use tutorial provided math implementation" ON)

# 配置一个头文件，将一些CMake设置
# 传递到源代码
configure_file(TutorialConfig.h.in TutorialConfig.h)

# 添加MathFunctions库
if(USE_MYMATH)
  add_subdirectory(MathFunctions)
  list(APPEND EXTRA_LIBS MathFunctions)
endif()

# 添加可执行文件
add_executable(Tutorial tutorial.cxx)

# TODO 2: Link to tutorial_compiler_flags

target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS})

# 添加二进制树到引用目录的搜索路径
# 以便找到TutorialConfig.h
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           )
