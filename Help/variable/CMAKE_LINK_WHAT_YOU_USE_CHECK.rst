CMAKE_LINK_WHAT_YOU_USE_CHECK
-----------------------------

.. versionadded:: 3.22

由\ :prop_tgt:`LINK_WHAT_YOU_USE`\ 在链接器执行之后执行的命令，用于检查是否存在不必要链接的共享库。\
定义在链接步骤之后执行的命令，以检查库的使用情况。此检查目前仅在\ ``ELF``\ 值为\
``ldd -u -r``\ 的平台上定义。

See also :variable:`CMAKE_<LANG>_LINK_WHAT_YOU_USE_FLAG` variables.
