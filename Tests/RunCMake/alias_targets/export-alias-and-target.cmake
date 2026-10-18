
enable_language(CXX)

add_library(foo empty.cpp)

add_library(alias ALIAS foo)

export(TARGETS foo alias FILE anotherFile.cmake)
