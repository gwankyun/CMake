add_custom_command(
  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/out.txt"
  COMMAND ${CMAKE_COMMAND} -E echo "Generating out.txt"
  COMMENT "My Custom Command Build Phase Name $<CONFIG>"
)
add_custom_target(drive ALL DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/out.txt")
