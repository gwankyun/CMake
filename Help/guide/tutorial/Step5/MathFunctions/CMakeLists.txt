add_library(MathFunctions mysqrt.cxx)

# 说明任何人想链接我们必须包含当前源目录
# 以便查找MathFunctions.h，尽管我们自己不用。
target_include_directories(MathFunctions
          INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
          )

# link our compiler flags interface library
target_link_libraries(MathFunctions tutorial_compiler_flags)

# TODO 1: Create a variable called installable_libs that is a list of all
# libraries we want to install (e.g. MathFunctions and tutorial_compiler_flags)
# Then install the installable libraries to the lib folder.
# Hint: Use the TARGETS and DESTINATION parameters

# TODO 2: Install the library headers to the include folder.
# Hint: Use the FILES and DESTINATION parameters
