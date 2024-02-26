CMAKE_<LANG>_USING_LINKER_<TYPE>
--------------------------------

.. versionadded:: 3.29

该变量定义了如何为由\ :variable:`CMAKE_LINKER_TYPE`\ 变量或\ :prop_tgt:`LINKER_TYPE`\
目标属性指定的类型指定链接步骤链接器。它可以保存链接步骤的编译器标志，也可以直接保存链接工具。\
数据类型由\ :variable:`CMAKE_<LANG>_USING_LINKER_MODE`\ 变量给出。

For example, to specify the ``LLVM`` linker for ``GNU`` compilers, we have:

.. code-block:: cmake

  set(CMAKE_C_USING_LINKER_LLD "-fuse-ld=lld")

Or on ``Windows`` platform, for ``Clang`` compilers simulating ``MSVC``, we
have:

.. code-block:: cmake

  set(CMAKE_C_USING_LINKER_LLD "-fuse-ld=lld-link")

And for the ``MSVC`` compiler, linker is directly used, so we have:

.. code-block:: cmake

  set(CMAKE_C_USING_LINKER_LLD "/path/to/lld-link.exe")
  set(CMAKE_C_USING_LINKER_MODE TOOL)
