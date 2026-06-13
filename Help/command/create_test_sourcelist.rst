create_test_sourcelist
----------------------

创建一个测试驱动程序，将许多小测试链接到一个可执行文件中。这在使用大型库构建静态可执行文件以\
缩小所需的总大小时非常有用。

.. signature::
  create_test_sourcelist(<sourceListName> <driverName> <test>... <options>...)
  :target: original

  从各个测试源文件列表中生成一个测试驱动源文件，并提供一个可编译成可一个执行文件的源文件列表。

  可用的选项如下：

  ``<sourceListName>``
    用于存储构建测试驱动程序所需的源文件列表的变量名。该列表将包含\ ``<test>...``\ 源文件\
    以及生成的\ ``<driverName>``\ 源文件。

    .. versionchanged:: 3.29

      在构建树中，测试驱动源文件以绝对路径列出。之前仅以\ ``<driverName>``\ 的形式列出。

  ``<driverName>``
    要生成到构建树中的测试驱动源文件的名称。\
    该源文件将包含一个\ ``main()``\ 程序入口点，该入口点会调度到命令行中指定名称的任何测试。

  ``<test>...``
    要添加到驱动程序二进制文件中的测试源文件。每个测试源文件中必须包含一个函数，该函数的名称\
    与去掉扩展名后的文件名相同。例如，一个\ ``foo.cxx``\ 测试源文件可能包含：

    .. code-block:: c++

      int foo(int argc, char** argv)

  ``EXTRA_INCLUDE <header>``
    指定一个头文件，以便在生成的测试驱动源文件中使用\ ``#include``\ 指令包含该头文件。

  ``FUNCTION <function>``
    指定一个函数，该函数将使用指向\ ``argc``\ 和\ ``argv``\ 的指针进行调用。\
    该函数可以在\ ``EXTRA_INCLUDE``\ 头文件中提供：

    .. code-block:: c++

      void function(int* pargc, char*** pargv)

    这可用于为每个测试添加额外的命令行处理。

此外，一些CMake变量会影响测试驱动程序的生成：

.. variable:: CMAKE_TESTDRIVER_BEFORE_TESTMAIN

  在调用每个测试函数之前直接插入的代码。

.. variable:: CMAKE_TESTDRIVER_AFTER_TESTMAIN

  在调用每个测试函数之后直接插入的代码

The generated test driver supports the following command-line arguments:

``<name>``
  Run the test with the exact name ``<name>`` (case-insensitive).

``-R <substr>``
  Run the first test whose name contains ``<substr>`` (case-insensitive).

``-A [<skip_test>...]``
  .. versionadded:: 3.21

    Run all tests and print results in `TAP <https://testanything.org/>`_
    format.

    Any additional arguments after ``-A`` are interpreted as exact test names
    to skip.

``-N``
  .. versionadded:: 4.4

    List all available test names (one per line) and exit.

Example
^^^^^^^

.. code-block:: cmake

  create_test_sourcelist(SRCS main.c test1.c test2.c)
  add_executable(MyTests ${SRCS})
  discover_tests(COMMAND MyTests
    DISCOVERY_ARGS -N
    DISCOVERY_MATCH "^(.+)$"
    TEST_NAME "${PROJECT_NAME}.\\1"
    TEST_ARGS "\\1"
  )

See Also
^^^^^^^^

* :command:`discover_tests`
