include(Assertions.cmake)

expect_cached(CMD_UNINITIALIZED IGNORE)

expect_cached(CMD_INSTALL_ABSOLUTE_DESTINATION WARN)
