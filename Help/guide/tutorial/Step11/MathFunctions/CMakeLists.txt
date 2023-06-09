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

  include(MakeTable.cmake) # generates Table.h

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

  target_link_libraries(SqrtLibrary PUBLIC tutorial_compiler_flags)
  target_link_libraries(MathFunctions PRIVATE SqrtLibrary)
endif()

target_link_libraries(MathFunctions PUBLIC tutorial_compiler_flags)

# 定义当用declspec(dllexport)声明的符号
# 在windows构建时
target_compile_definitions(MathFunctions PRIVATE "EXPORTING_MYMATH")

# install libs
set(installable_libs MathFunctions tutorial_compiler_flags)
if(TARGET SqrtLibrary)
  list(APPEND installable_libs SqrtLibrary)
endif()
install(TARGETS ${installable_libs} DESTINATION lib)
# install include headers
install(FILES MathFunctions.h DESTINATION include)
