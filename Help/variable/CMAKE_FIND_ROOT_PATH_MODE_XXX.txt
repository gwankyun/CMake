这个变量控制\ :variable:`CMAKE_FIND_ROOT_PATH`\ 和\ :variable:`CMAKE_SYSROOT`\
是否被\ |FIND_XXX|\ 使用。

If set to ``ONLY``, then only the roots in :variable:`CMAKE_FIND_ROOT_PATH`
will be searched. If set to ``NEVER``, then the roots in
:variable:`CMAKE_FIND_ROOT_PATH` will be ignored and only the host system
root will be used. If set to ``BOTH``, then the host system paths and the
paths in :variable:`CMAKE_FIND_ROOT_PATH` will be searched.
