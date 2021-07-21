# 添加运行的库
add_library(MathFunctions MathFunctions.cxx)

# 声明链接到我们的人都需要包含当前的源目录来查找MathFunctions.h
# 我们自己除外。
target_include_directories(MathFunctions
                           INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
                           )

# 是否使用自己的数学函数
option(USE_MYMATH "Use tutorial provided math implementation" ON)
if(USE_MYMATH)

  target_compile_definitions(MathFunctions PRIVATE "USE_MYMATH")

  # 首先添加生成表的可执行文件
  add_executable(MakeTable MakeTable.cxx)

  # 添加生成源代码的命令
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Table.h
    COMMAND MakeTable ${CMAKE_CURRENT_BINARY_DIR}/Table.h
    DEPENDS MakeTable
    )

  # 只包含sqrt的库
  add_library(SqrtLibrary STATIC
              mysqrt.cxx
              ${CMAKE_CURRENT_BINARY_DIR}/Table.h
              )

  # 说明依赖于二进制目录查找Table.h
  target_include_directories(SqrtLibrary PRIVATE
                             ${CMAKE_CURRENT_BINARY_DIR}
                             )

  # 说明当默认是共享库时，SqrtLibrary需要PIC
  set_target_properties(SqrtLibrary PROPERTIES
                        POSITION_INDEPENDENT_CODE ${BUILD_SHARED_LIBS}
                        )

  target_link_libraries(MathFunctions PRIVATE SqrtLibrary)
endif()

# 定义在windows构建时
# 使用使用declspec(dllexport)声明的符号
target_compile_definitions(MathFunctions PRIVATE "EXPORTING_MYMATH")

# 安装规则
set(installable_libs MathFunctions)
if(TARGET SqrtLibrary)
  list(APPEND installable_libs SqrtLibrary)
endif()
install(TARGETS ${installable_libs} DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)
