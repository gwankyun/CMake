project(TestTool C)

add_executable(tool tool.c)

install(TARGETS tool EXPORT tool)
export(PACKAGE_INFO tool EXPORT tool)
