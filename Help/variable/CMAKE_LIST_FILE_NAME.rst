CMAKE_LIST_FILE_NAME
--------------------

.. versionadded:: 4.0

CMake项目文件的名称。它决定了在配置CMake时处理的顶层文件，以及由\ :command:`add_subdirectory`\
命令处理的文件。

By default, this is ``CMakeLists.txt``. If set to anything else,
``CMakeLists.txt`` will be used as a fallback whenever the specified file
cannot be found within a project subdirectory.

This variable reports the value set via the :option:`cmake --project-file`
option. The value of this variable should never be set directly by projects or
users.

.. warning::

  The use of alternate project file names is intended for temporary use by
  developers during an incremental transition and not for publication of a final
  product. CMake will always emit a warning when the project file is anything
  other than ``CMakeLists.txt``.
