CMAKE_LINK_WHAT_YOU_USE_CHECK
-----------------------------

.. versionadded:: 3.22

Command executed by :prop_tgt:`LINK_WHAT_YOU_USE` after the linker to
check for unnecessarily-linked shared libraries.
定义在链接步骤之后执行的命令，以检查库的使用情况。此检查目前仅在\ ``ELF``\ 值为\
``ldd -u -r``\ 的平台上定义。

See also :variable:`CMAKE_<LANG>_LINK_WHAT_YOU_USE_FLAG` variables.
