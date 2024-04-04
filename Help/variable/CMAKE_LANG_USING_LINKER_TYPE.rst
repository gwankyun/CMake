CMAKE_<LANG>_USING_LINKER_<TYPE>
--------------------------------

.. versionadded:: 3.29

该变量定义了如何为链接步骤指定\ ``<TYPE>``\ 链接器，由\ :variable:`CMAKE_LINKER_TYPE`\
变量或\ :prop_tgt:`LINKER_TYPE`\ 目标属性控制。根据\
:variable:`CMAKE_<LANG>_USING_LINKER_MODE`\ 变量的值，\
``CMAKE_<LANG>_USING_LINKER_<TYPE>``\ 可以保存用于链接步骤的编译器标志，或者直接提供给\
链接器工具的标志。

.. note::

  The specified linker tool is generally expected to be accessible through
  the ``PATH`` environment variable.

For example, the ``LLD`` linker for ``GNU`` compilers is defined like so:

.. code-block:: cmake

  set(CMAKE_C_USING_LINKER_LLD "-fuse-ld=lld")

On the ``Windows`` platform with ``Clang`` compilers simulating ``MSVC``:

.. code-block:: cmake

  set(CMAKE_C_USING_LINKER_LLD "-fuse-ld=lld-link")

And for the ``MSVC`` compiler, the linker is invoked directly, not via the
compiler frontend:

.. code-block:: cmake

  set(CMAKE_C_USING_LINKER_LLD "/path/to/lld-link.exe")
  set(CMAKE_C_USING_LINKER_MODE TOOL)

A custom linker type can also be defined, usually in a toolchain file:

.. code-block:: cmake

  set(CMAKE_LINKER_TYPE lld_launcher)
  set(CMAKE_C_USING_LINKER_lld_launcher "-fuse-ld=/path/to/lld-launcher.sh")
  set(CMAKE_C_USING_LINKER_MODE FLAG)
