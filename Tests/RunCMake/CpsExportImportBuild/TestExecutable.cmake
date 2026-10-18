project(TestLibrary C)

set(liba_DIR "${CMAKE_BINARY_DIR}/../TestLibrary-build/cps/liba")
set(libb_DIR "${CMAKE_BINARY_DIR}/../TestLibrary-build/cps/libb")
set(tool_DIR "${CMAKE_BINARY_DIR}/../TestTool-build/cps/tool")

find_package(libb REQUIRED COMPONENTS libb)
find_package(tool REQUIRED COMPONENTS tool)

add_custom_command(
  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/gen.c"
  COMMAND tool::tool "${CMAKE_CURRENT_BINARY_DIR}/gen.c"
  VERBATIM
)

add_executable(app app.c "${CMAKE_CURRENT_BINARY_DIR}/gen.c")

target_link_libraries(app PUBLIC libb::libb)

install(TARGETS app DESTINATION bin)
