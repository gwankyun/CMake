
enable_language(CXX)

add_library(foo empty.cpp)

add_library(alias ALIAS foo)

target_precompile_headers(alias PRIVATE <vector>)
get_target_property(val foo PRECOMPILE_HEADERS)
if(NOT "<vector>" IN_LIST val)
  message(SEND_ERROR "target_precompile_headers(): Target property 'PRECOMPILE_HEADERS' is missing value added to ALIAS 'alias' on aliased target 'foo': '<vector>' not in '${val}'.")
endif()
