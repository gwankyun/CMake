configure_file
--------------

.. only:: html

   .. contents::

将文件复制到另一个位置并修改其内容。

.. code-block:: cmake

  configure_file(<input> <output>
                 [NO_SOURCE_PERMISSIONS | USE_SOURCE_PERMISSIONS |
                  FILE_PERMISSIONS <permissions>...]
                 [COPYONLY] [ESCAPE_QUOTES] [@ONLY]
                 [NEWLINE_STYLE [UNIX|DOS|WIN32|LF|CRLF]])

在对输入文件内容进行\ `替换处理`_\ 的同时，将\ ``<input>``\ 文件复制到\
``<output>``\ 文件。

如果输入文件被修改，构建系统将重新运行CMake来重新配置该文件，并再次生成构建系统。\
仅当生成文件的内容发生变化时，后续运行CMake才会修改该文件并更新其时间戳。

选项
^^^^^^^

选项如下：

``<input>``
  输入文件的路径。\
  相对路径会相对于\ :variable:`CMAKE_CURRENT_SOURCE_DIR`\ 变量的值进行处理。\
  输入路径必须是一个文件，而不能是一个目录。

``<output>``
  输出文件或目录的路径。\
  相对路径会相对于\ :variable:`CMAKE_CURRENT_BINARY_DIR`\ 变量的值进行处理。\
  如果该路径指定的是一个已存在的目录，输出文件将被放置在该目录下，并且文件名与\
  输入文件相同。\
  如果该路径包含不存在的目录，这些目录将被创建。

``NO_SOURCE_PERMISSIONS``
  .. versionadded:: 3.19

  不要将输入文件的权限传递给输出文件。\
  复制后的文件权限默认采用标准的644值（-rw-r--r--）。

``USE_SOURCE_PERMISSIONS``
  .. versionadded:: 3.20

  将输入文件的权限传递给输出文件。\
  如果未指定三个与权限相关的关键字（\ ``NO_SOURCE_PERMISSIONS``、\
  ``USE_SOURCE_PERMISSIONS``\ 或\ ``FILE_PERMISSIONS``）中的任何一个，这已经是\
  默认行为。关键字\ ``USE_SOURCE_PERMISSIONS``\ 主要用于在调用处更清晰地表明预期行为。

``FILE_PERMISSIONS <permissions>...``
  .. versionadded:: 3.20

  忽略输入文件的权限，而是为输出文件使用指定的\ ``<permissions>``。

``COPYONLY``
  复制文件时不替换任何变量引用或其他内容。\
  此选项不能与\ ``NEWLINE_STYLE``\ 一起使用。

``ESCAPE_QUOTES``
  使用反斜杠（C风格）对所有替换后的引号进行转义。

``@ONLY``
  将变量替换限制为\ ``@VAR@``\ 格式的引用。\
  这对于配置使用\ ``${VAR}``\ 语法的脚本很有用。

``NEWLINE_STYLE <style>``
  指定输出文件的换行符风格。指定\ ``UNIX``\ 或\ ``LF``\ 表示使用\ ``\n``\ 作为\
  换行符，指定\ ``DOS``、\ ``WIN32``\ 或\ ``CRLF``\ 表示使用\ ``\r\n``\ 作为换行符。\
  此选项不能与\ ``COPYONLY``\ 一起使用。

替换处理
^^^^^^^^^^^^^^^

在输入文件内容里引用的\ :ref:`变量 <CMake Language Variables>`，其形式为\
``@VAR@``、\ ``${VAR}``、\ ``$CACHE{VAR}``，以及引用的\
:ref:`环境变量 <CMake Language Environment Variables>`，其形式为\ ``$ENV{VAR}``，\
都将被替换为变量的当前值，若变量未定义，则替换为空字符串。\
此外，以下格式的输入行

.. code-block:: c

  #cmakedefine VAR ...

将被替换为以下两种之一

.. code-block:: c

  #define VAR ...

或者

.. code-block:: c

  /* #undef VAR */

这取决于在CMake中设置的\ ``VAR``\ 值是否被\ :command:`if`\ 命令视为非假常量。\
变量名后一行中的“...”内容（如果有的话），将按上述方式处理。

与\ ``#cmakedefine VAR ...``\ 形式的行不同，在\ ``#cmakedefine01 VAR``\ 形式的行中，\
``VAR``\ 本身将展开为\ ``VAR 0``\ 或\ ``VAR 1``，而不是被赋值为\ ``...``。\
因此，以下格式的输入行

.. code-block:: c

  #cmakedefine01 VAR

将被替换为以下两者之一

.. code-block:: c

  #define VAR 0

或者

.. code-block:: c

  #define VAR 1

格式为\ ``#cmakedefine01 VAR ...``\ 的输入行将展开为\ ``#cmakedefine01 VAR ... 0``\
或者\ ``#cmakedefine01 VAR ... 1``，这可能会导致未定义行为。

.. versionadded:: 3.10
  结果行（不包括\ ``#undef``\ 注释）可以在\ ``#``\ 字符与\ ``cmakedefine``\ 或\
  ``cmakedefine01``\ 之间使用空格和/或制表符进行缩进。\
  这种空白缩进在输出行中将会被保留：

  .. code-block:: c

    #  cmakedefine VAR
    #  cmakedefine01 VAR

  如果定义了\ ``VAR``，则将被替换为

  .. code-block:: c

    #  define VAR
    #  define VAR 1

示例
^^^^^^^

假设有一个源文件目录，其中包含一个\ ``foo.h.in``\ 文件：

.. code-block:: c

  #cmakedefine FOO_ENABLE
  #cmakedefine FOO_STRING "@FOO_STRING@"

相邻的\ ``CMakeLists.txt``\ 文件可以使用\ ``configure_file``\ 命令来配置该头文件：

.. code-block:: cmake

  option(FOO_ENABLE "Enable Foo" ON)
  if(FOO_ENABLE)
    set(FOO_STRING "foo")
  endif()
  configure_file(foo.h.in foo.h @ONLY)

这会在与该源目录对应的构建目录中创建一个\ ``foo.h``\ 文件。\
如果\ ``FOO_ENABLE``\ 选项处于开启状态，配置后的文件将包含：

.. code-block:: c

  #define FOO_ENABLE
  #define FOO_STRING "foo"

否则，它将包含：

.. code-block:: c

  /* #undef FOO_ENABLE */
  /* #undef FOO_STRING */

然后，用户可以使用\ :command:`target_include_directories`\ 命令将输出目录指定为包含目录：

.. code-block:: cmake

  target_include_directories(<target> [SYSTEM] <INTERFACE|PUBLIC|PRIVATE> "${CMAKE_CURRENT_BINARY_DIR}")

这样源文件就可以使用\ ``#include <foo.h>``\ 来包含该头文件。

另请参阅
^^^^^^^^

* :command:`file(GENERATE)`
