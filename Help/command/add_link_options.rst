add_link_options
----------------

.. versionadded:: 3.13

为调用此命令后添加的当前目录及以下的可执行文件、共享库或者模块库目标的链接步骤添加选项。

.. code-block:: cmake

  add_link_options(<option> ...)

这个命令可以用来添加任何链接选项，但也有其他添加库的命令（\ :command:`target_link_libraries`\
或\ :command:`link_libraries`\ ）。请参阅\ :prop_dir:`directory <LINK_OPTIONS>`\ 和\
:prop_tgt:`target <LINK_OPTIONS>` ``LINK_OPTIONS``\ 属性的文档。

.. note::

  此命令不能用于为静态库目标添加选项，因为它们不使用链接器。要添加archiver或MSVC库标志，\
  请参阅\ :prop_tgt:`STATIC_LIBRARY_OPTIONS`\ 目标属性。

.. |command_name| replace:: ``add_link_options``
.. include:: include/GENEX_NOTE.rst

.. include:: include/DEVICE_LINK_OPTIONS.rst

.. include:: include/OPTIONS_SHELL.rst

.. include:: include/LINK_OPTIONS_LINKER.rst

另外参阅
^^^^^^^^

* :command:`link_libraries`
* :command:`target_link_libraries`
* :command:`target_link_options`

* :variable:`CMAKE_<LANG>_FLAGS`\ 和\ :variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`\
  添加传递给编译器所有调用的语言范围的标志。这包括驱动编译的调用和驱动链接的调用。
