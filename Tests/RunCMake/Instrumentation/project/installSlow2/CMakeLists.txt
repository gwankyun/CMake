# A deliberately slow install step so that a parallel `cmake --install -j 1` has
# scripts still pending when a user interrupt arrives.  The interrupt must stop
# the remaining install scripts from being launched.
install(CODE "execute_process(COMMAND \"${CMAKE_COMMAND}\" -E sleep 10)")
