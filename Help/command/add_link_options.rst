add_link_options
----------------

.. versionadded:: 3.13

为调用此命令后添加的当前目录及以下的可执行文件、共享库或者模块库目标的链接步骤添加选项。

.. code-block:: cmake

  add_link_options(<option> ...)

This command can be used to add any link options, but alternative commands
exist to add libraries (:command:`target_link_libraries` or
:command:`link_libraries`).  See documentation of the
:prop_dir:`directory <LINK_OPTIONS>` and
:prop_tgt:`target <LINK_OPTIONS>` ``LINK_OPTIONS`` properties.

.. note::

  This command cannot be used to add options for static library targets,
  since they do not use a linker.  To add archiver or MSVC librarian flags,
  see the :prop_tgt:`STATIC_LIBRARY_OPTIONS` target property.

.. |command_name| replace:: ``add_link_options``
.. include:: GENEX_NOTE.txt

.. include:: DEVICE_LINK_OPTIONS.txt

.. include:: OPTIONS_SHELL.txt

.. include:: LINK_OPTIONS_LINKER.txt

See Also
^^^^^^^^

* :command:`link_libraries`
* :command:`target_link_libraries`
* :command:`target_link_options`
