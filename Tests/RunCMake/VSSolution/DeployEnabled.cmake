enable_language(CXX)

set(DEPLOY_DIR
   "temp\\foodir"
)

add_library(foo SHARED foo.cpp)

set_target_properties(foo
 PROPERTIES
  VS_SOLUTION_DEPLOY $<NOT:$<CONFIG:Release>>
)

add_custom_target(utility)

set_target_properties(utility
 PROPERTIES
  VS_SOLUTION_DEPLOY TRUE
)
