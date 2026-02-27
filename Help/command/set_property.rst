set_property
------------

在给定的范围内设置命名属性。

.. code-block:: cmake

  set_property({GLOBAL                                    |
                DIRECTORY [<dir>]                         |
                TARGET    <target>...                     |
                FILE_SET  <file_set>... TARGET <target>   |
                SOURCE    <source>...
                          [DIRECTORY <dirs> ...]
                          [TARGET_DIRECTORY <targets>...] |
                INSTALL   <file>...                       |
                TEST      <test>...
                          [DIRECTORY <dir>]               |
                CACHE     <entry>...}
               [APPEND] [APPEND_STRING]
               PROPERTY <name> [<value>...])

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

``FILE_SET``
  .. versionadded:: 4.3

  Scope may name zero or more existing file sets.

  The following option is required:

  ``TARGET <target>``
    The target to which the file set is attached.

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

  若要使用相对路径引用安装前缀本身，请使用\ ``.``。

  当前已安装文件的属性仅针对WIX生成器进行了定义，在该生成器中，给定的路径是相对于\
  安装前缀的。

``TEST``
  作用域仅限于调用该命令所在的目录。\
  它可以指定零个或多个已存在的测试。\
  另请参阅\ :command:`set_tests_properties`\ 命令。

  对于通过\ :command:`add_test(NAME)`\ 形式创建的测试，其测试属性值可以使用\
  :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 来指定。

  .. versionadded:: 3.28

    可以使用以下子选项在其他目录作用域中设置可见性：

    ``DIRECTORY <dir>``
      测试属性将在\ ``<dir>``\ 目录的作用域中设置。\
      CMake必须已经知晓这个目录，要么是通过调用\ :command:`add_subdirectory`\
      添加的，要么它是顶层源目录。\
      相对路径会被视作相对于当前源目录。\
      ``<dir>``\ 可以引用一个二进制目录。

``CACHE``
  作用域必须指定零个或多个已存在的缓存条目。

必需的\ ``PROPERTY``\ 选项后面需紧跟要设置的属性名称。\
其余参数用于以分号分隔的列表形式构成属性值。

如果指定了\ ``APPEND``\ 选项，则会将列表追加到任何现有属性值之后（空值会被忽略，\
不会被追加）。\
如果指定了\ ``APPEND_STRING``\ 选项，该字符串将以字符串形式追加到任何现有属性值之后，\
即最终会得到一个更长的字符串，而非字符串列表。\
当对定义为支持\ ``INHERITED``\ 行为的属性使用\ ``APPEND``\ 或\ ``APPEND_STRING``\
选项时（参见\ :command:`define_property`\ ），在查找要追加的初始值时不会发生继承操作。\
如果该属性在指定作用域中尚未直接设置，则此命令的行为将如同未指定\ ``APPEND``\ 或\
``APPEND_STRING``\ 选项一样。

.. note::

  :prop_sf:`GENERATED`\ 源文件属性可能具有全局可见性。\
  详情请参阅其文档。

另请参阅
^^^^^^^^

* :command:`define_property`
* :command:`get_property`
* 有关每个作用域中的属性列表，请参阅\ :manual:`cmake-properties(7)`\ 手册。
