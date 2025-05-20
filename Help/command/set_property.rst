set_property
------------

在给定的范围内设置命名属性。

.. code-block:: cmake

  set_property(<GLOBAL                      |
                DIRECTORY [<dir>]           |
                TARGET    [<target1> ...]   |
                SOURCE    [<src1> ...]
                          [DIRECTORY <dirs> ...]
                          [TARGET_DIRECTORY <targets> ...] |
                INSTALL   [<file1> ...]     |
                TEST      [<test1> ...]
                          [DIRECTORY <dir>] |
                CACHE     [<entry1> ...]    >
               [APPEND] [APPEND_STRING]
               PROPERTY <name> [<value1> ...])

在某个作用域的零个或多个对象上设置一个属性。

第一个参数决定了属性设置的作用域。\
它必须是以下之一：

``GLOBAL``
  作用域是唯一的，且不接受名称参数。

``DIRECTORY``
  作用域默认是当前目录，但也可以通过完整路径或相对路径指定其他目录（这些目录需\
  已由CMake处理过）。\
  相对路径会被视作相对于当前源目录。\
  另请参阅\ :command:`set_directory_properties`\ 命令。

  .. versionadded:: 3.19
    ``<dir>``\ 可以引用一个二进制目录。

``TARGET``
  作用域可以指定零个或多个已存在的目标。\
  另请参阅\ :command:`set_target_properties`\ 命令。

  :ref:`Alias Targets`\ 不支持设置目标属性。

``SOURCE``
  作用域可以指定零个或多个源文件。\
  默认情况下，源文件属性仅对同一目录（\ ``CMakeLists.txt``\ ）中添加的目标可见。

  .. versionadded:: 3.18
    可以使用以下一个或两个子选项在其他目录作用域中设置可见性：

    ``DIRECTORY <dirs>...``
      源文件属性将在每个\ ``<dirs>``\ 目录的作用域中设置。\
      CMake必须已经知晓这些目录中的每一个，要么是通过调用\ :command:`add_subdirectory`\
      添加的，要么它是顶层源目录。\
      相对路径会被视作相对于当前源目录。

      .. versionadded:: 3.19
        ``<dirs>``\ 可以引用一个二进制目录。

    ``TARGET_DIRECTORY <targets>...``
      源文件属性将在指定的每个\ ``<targets>``\ 被创建的目录作用域中设置（因此\
      ``<targets>``\ 必须已经存在）。

  另请参阅\ :command:`set_source_files_properties`\ 命令。

``INSTALL``
  .. versionadded:: 3.1

  作用域可以指定零个或多个已安装文件的路径。\
  这些信息会提供给CPack，以影响部署过程。

  属性键和属性值都可以使用生成器表达式。\
  特定属性可能适用于已安装的文件和/或目录。

  路径组件必须使用正斜杠分隔，必须经过规范化处理，并且区分大小写。

  To reference the installation prefix itself with a relative path use ``.``.

  Currently installed file properties are only defined for
  the WIX generator where the given paths are relative
  to the installation prefix.

``TEST``
  Scope is limited to the directory the command is called in. It may name zero
  or more existing tests. See also command :command:`set_tests_properties`.

  Test property values may be specified using
  :manual:`generator expressions <cmake-generator-expressions(7)>`
  for tests created by the :command:`add_test(NAME)` signature.

  .. versionadded:: 3.28

    Visibility can be set in other directory scopes using the following sub-option:

    ``DIRECTORY <dir>``
      The test property will be set in the ``<dir>`` directory's scope. CMake must
      already know about this directory, either by having added it through a call
      to :command:`add_subdirectory` or it being the top level source directory.
      Relative paths are treated as relative to the current source directory.
      ``<dir>`` may reference a binary directory.

``CACHE``
  Scope must name zero or more existing cache entries.

The required ``PROPERTY`` option is immediately followed by the name of
the property to set.  Remaining arguments are used to compose the
property value in the form of a semicolon-separated list.

If the ``APPEND`` option is given the list is appended to any existing
property value (except that empty values are ignored and not appended).
If the ``APPEND_STRING`` option is given the string is
appended to any existing property value as string, i.e. it results in a
longer string and not a list of strings.  When using ``APPEND`` or
``APPEND_STRING`` with a property defined to support ``INHERITED``
behavior (see :command:`define_property`), no inheriting occurs when
finding the initial value to append to.  If the property is not already
directly set in the nominated scope, the command will behave as though
``APPEND`` or ``APPEND_STRING`` had not been given.

.. note::

  The :prop_sf:`GENERATED` source file property may be globally visible.
  See its documentation for details.

See Also
^^^^^^^^

* :command:`define_property`
* :command:`get_property`
* The :manual:`cmake-properties(7)` manual for a list of properties
  in each scope.
