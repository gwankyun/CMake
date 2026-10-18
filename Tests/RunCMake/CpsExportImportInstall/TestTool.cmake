project(TestTool C)

set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../install")

add_executable(tool tool.c)

install(TARGETS tool EXPORT tool)
install(PACKAGE_INFO tool DESTINATION cps EXPORT tool)
