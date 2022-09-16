add_library(MathFunctions mysqrt.cxx)

# 说明任何人想链接我们必须包含当前源目录
# 以便查找MathFunctions.h，尽管我们自己不用。
target_include_directories(MathFunctions
          INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
          )

# 安装规则
install(TARGETS MathFunctions DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)
