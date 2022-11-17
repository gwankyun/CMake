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
# to find MathFunctions.h, while we don't.
# state that we depend on Tutorial_BINARY_DIR but consumers don't, as the
# TutorialConfig.h include is an implementation detail
# state that we depend on our binary dir to find Table.h
target_include_directories(MathFunctions
          INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
          PRIVATE   ${CMAKE_CURRENT_BINARY_DIR}
          )

# link our compiler flags interface library
target_link_libraries(MathFunctions tutorial_compiler_flags)

# install libs
set(installable_libs MathFunctions tutorial_compiler_flags)
install(TARGETS ${installable_libs} DESTINATION lib)
# install include headers
install(FILES MathFunctions.h DESTINATION include)
