add_library(foo INTERFACE)
install(TARGETS foo EXPORT foo DESTINATION .)
install(PACKAGE_INFO foo DESTINATION cps EXPORT foo)