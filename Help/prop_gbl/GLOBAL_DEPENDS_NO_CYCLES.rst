GLOBAL_DEPENDS_NO_CYCLES
------------------------

禁止全局目标依赖图循环。

CMake automatically analyzes the global inter-target dependency graph
at the beginning of native build system generation.  It reports an
error if the dependency graph contains a cycle that does not consist
of all STATIC library targets.  This property tells CMake to disallow
all cycles completely, even among static libraries.
