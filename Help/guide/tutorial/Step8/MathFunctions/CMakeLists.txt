# 首先添加一个可执行文件用以生成表
add_executable(MakeTable MakeTable.cxx)

# 添加命令以生成源码
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Table.h
  COMMAND MakeTable ${CMAKE_CURRENT_BINARY_DIR}/Table.h
  DEPENDS MakeTable
  )

# 添加主库
add_library(MathFunctions
            mysqrt.cxx
            ${CMAKE_CURRENT_BINARY_DIR}/Table.h
            )

# 说明任何人想链接我们必须包含当前源目录
# 以便查找MathFunctions.h，尽管我们自己不用
# 说明我们依赖Tutorial_BINARY_DIR而客户不需要，因为
# TutorialConfig.h包含作为实现细节
# 说明我们依赖我们的二进制目录以找到Table.h
target_include_directories(MathFunctions
          INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
          PRIVATE ${CMAKE_CURRENT_BINARY_DIR}
          )

# 安装规则
install(TARGETS MathFunctions DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)
