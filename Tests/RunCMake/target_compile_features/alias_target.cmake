enable_language(CXX)

add_executable(main empty.cpp)
add_executable(Alias::Main ALIAS main)

if("cxx_delegating_constructors" IN_LIST CMAKE_CXX_COMPILE_FEATURES)
  target_compile_features(Alias::Main PRIVATE cxx_delegating_constructors)
  get_target_property(val main COMPILE_FEATURES)
  if(NOT "cxx_delegating_constructors" IN_LIST val)
    message(SEND_ERROR "target_compile_features(): Target property 'COMPILE_FEATURES' is missing value added to ALIAS 'Alias::Main' on aliased target 'main': 'cxx_delegating_constructors' not in '${val}'.")
  endif()
endif()
