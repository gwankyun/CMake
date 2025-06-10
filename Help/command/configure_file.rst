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

:ref:`Variables <CMake Language Variables>` referenced in the input
file content as ``@VAR@``, ``${VAR}``, ``$CACHE{VAR}``, and
:ref:`environment variables <CMake Language Environment Variables>`
referenced as ``$ENV{VAR}``, will each be replaced with the current value
of the variable, or the empty string if the variable is not defined.
Furthermore, input lines of the form

.. code-block:: c

  #cmakedefine VAR ...

will be replaced with either

.. code-block:: c

  #define VAR ...

or

.. code-block:: c

  /* #undef VAR */

depending on whether ``VAR`` is set in CMake to any value not considered
a false constant by the :command:`if` command.  The "..." content on the
line after the variable name, if any, is processed as above.

Unlike lines of the form ``#cmakedefine VAR ...``, in lines of the form
``#cmakedefine01 VAR``, ``VAR`` itself will expand to ``VAR 0`` or ``VAR 1``
rather than being assigned the value ``...``. Therefore, input lines of the form

.. code-block:: c

  #cmakedefine01 VAR

will be replaced with either

.. code-block:: c

  #define VAR 0

or

.. code-block:: c

  #define VAR 1

Input lines of the form ``#cmakedefine01 VAR ...`` will expand
as ``#cmakedefine01 VAR ... 0`` or ``#cmakedefine01 VAR ... 1``,
which may lead to undefined behavior.

.. versionadded:: 3.10
  The result lines (with the exception of the ``#undef`` comments) can be
  indented using spaces and/or tabs between the ``#`` character
  and the ``cmakedefine`` or ``cmakedefine01`` words. This whitespace
  indentation will be preserved in the output lines:

  .. code-block:: c

    #  cmakedefine VAR
    #  cmakedefine01 VAR

  will be replaced, if ``VAR`` is defined, with

  .. code-block:: c

    #  define VAR
    #  define VAR 1

Example
^^^^^^^

Consider a source tree containing a ``foo.h.in`` file:

.. code-block:: c

  #cmakedefine FOO_ENABLE
  #cmakedefine FOO_STRING "@FOO_STRING@"

An adjacent ``CMakeLists.txt`` may use ``configure_file`` to
configure the header:

.. code-block:: cmake

  option(FOO_ENABLE "Enable Foo" ON)
  if(FOO_ENABLE)
    set(FOO_STRING "foo")
  endif()
  configure_file(foo.h.in foo.h @ONLY)

This creates a ``foo.h`` in the build directory corresponding to
this source directory.  If the ``FOO_ENABLE`` option is on, the
configured file will contain:

.. code-block:: c

  #define FOO_ENABLE
  #define FOO_STRING "foo"

Otherwise it will contain:

.. code-block:: c

  /* #undef FOO_ENABLE */
  /* #undef FOO_STRING */

One may then use the :command:`target_include_directories` command to
specify the output directory as an include directory:

.. code-block:: cmake

  target_include_directories(<target> [SYSTEM] <INTERFACE|PUBLIC|PRIVATE> "${CMAKE_CURRENT_BINARY_DIR}")

so that sources may include the header as ``#include <foo.h>``.

See Also
^^^^^^^^

* :command:`file(GENERATE)`
