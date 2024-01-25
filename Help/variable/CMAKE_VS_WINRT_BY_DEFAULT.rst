CMAKE_VS_WINRT_BY_DEFAULT
-------------------------

.. versionadded:: 3.13

通知VS 2010及以上版本的\ :ref:`Visual Studio Generators`\ 目标平台默认启用WinRT编译，\
如果\ ``/ZW``\ 或\ :prop_tgt:`VS_WINRT_COMPONENT`\ 被省略，则需要显式禁用它（而不是在\
存在这些选项中的任何一个时启用它）

This makes cmake configuration consistent in terms of WinRT among
platforms - if you did not enable the WinRT compilation explicitly, it
will be disabled (by either not enabling it or explicitly disabling it)

Note: WinRT compilation is always explicitly disabled for C language
source files, even if it is expliclty enabled for a project

This variable is meant to be set by a
:variable:`toolchain file <CMAKE_TOOLCHAIN_FILE>` for such platforms.
