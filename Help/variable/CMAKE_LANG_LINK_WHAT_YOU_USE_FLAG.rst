CMAKE_<LANG>_LINK_WHAT_YOU_USE_FLAG
-----------------------------------

.. versionadded:: 3.22

由\ :prop_tgt:`LINK_WHAT_YOU_USE`\ 属性使用的链接器标志，用于告知链接器即使命令行上指定\
的共享库中的符号都不需要，也要将这些共享库全部链接进来。这是一个实现细节，用于让\
:variable:`CMAKE_LINK_WHAT_YOU_USE_CHECK`\ 变量中的命令能够检查二进制文件中是否存在不\
必要链接的共享库。

.. note::

  Do not rely on this abstraction to intentionally link to
  shared libraries whose symbols are not needed.
