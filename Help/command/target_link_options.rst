target_link_options
-------------------

.. versionadded:: 3.13

向可执行文件、共享库或者模块库目标的链接步骤添加可选项。

.. code-block:: cmake

  target_link_options(<target> [BEFORE]
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

命名的\ ``<target>``\ 必须是由\ :command:`add_executable`\ 或\ :command:`add_library`\
等命令创建的，并且不能是\ :ref:`别名目标 <Alias Targets>`。

这个命令可以用来添加任何链接选项，但也有其他添加库的命令（\
:command:`target_link_libraries`\ 或\ :command:`link_libraries`\ ）。请参阅\
:prop_dir:`目录 <LINK_OPTIONS>`\ 和\ :prop_tgt:`目标 <LINK_OPTIONS>`\
``LINK_OPTIONS``\ 属性的文档。

.. note::

  此命令不能用于为静态库目标添加选项，因为它们不使用链接器。要添加archiver或MSVC库管理标志，\
  请参阅\ :prop_tgt:`STATIC_LIBRARY_OPTIONS`\ 目标属性。

如果指定\ ``BEFORE``，则内容将被添加到属性的前面，而不是被添加到后面。

``INTERFACE``、\ ``PUBLIC`` 和\ ``PRIVATE``\ 关键字用于指定下列参数的\
:ref:`作用域 <Target Command Scope>`。\ ``PRIVATE``\ 和\ ``PUBLIC``\ 项将填充\
``<target>``\ 的\ :prop_tgt:`LINK_OPTIONS`\ 属性。\ ``PUBLIC``\ 和\ ``INTERFACE``\
项将填充\ ``<target>``\ 的\ :prop_tgt:`INTERFACE_LINK_OPTIONS`\ 属性。下列参数指定\
链接选项。重复调用相同的\ ``<target>``\ 将元素按照调用的顺序添加。

.. note::
  :ref:`IMPORTED目标 <Imported Targets>`\ 只支持\ ``INTERFACE``\ 项。

.. |command_name| replace:: ``target_link_options``
.. include:: GENEX_NOTE.txt

.. include:: DEVICE_LINK_OPTIONS.txt

.. include:: OPTIONS_SHELL.txt

.. include:: LINK_OPTIONS_LINKER.txt

另请参阅
^^^^^^^^

* :command:`target_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_precompile_headers`
* :command:`target_sources`

* :variable:`CMAKE_<LANG>_FLAGS`\ 和\ :variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`\
  添加传递给编译器所有调用的语言范围内的标志。这包括驱动编译的调用和驱动链接的调用。
