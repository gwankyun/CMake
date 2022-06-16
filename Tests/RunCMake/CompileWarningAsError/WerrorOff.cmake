enable_language(CXX)

include(WarningAsErrorOptions.cmake)
get_warning_options(warning_options)

add_executable(WerrorOff warn.cxx)
target_compile_options(WerrorOff PUBLIC "${warning_options}")
set_target_properties(WerrorOff PROPERTIES COMPILE_WARNING_AS_ERROR OFF)
