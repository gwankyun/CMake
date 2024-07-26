target_precompile_headers
-------------------------

.. versionadded:: 3.16

添加要预编译的头文件列表。

预编译头文件可以通过创建某些头文件的部分处理版本来加快编译速度，然后在编译期间使用该版本，而\
不是重复解析原始头文件。

主要形式
^^^^^^^^^

.. code-block:: cmake

  target_precompile_headers(<target>
    <INTERFACE|PUBLIC|PRIVATE> [header1...]
    [<INTERFACE|PUBLIC|PRIVATE> [header2...] ...])

该命令将头文件添加到\ ``<target>``\ 的\ :prop_tgt:`PRECOMPILE_HEADERS`\ 和/或\
:prop_tgt:`INTERFACE_PRECOMPILE_HEADERS`\ 目标属性中。命名\ ``<target>``\ 必须是由\
:command:`add_executable`\ 或\ :command:`add_library`\ 等命令创建的，并且不能是\
:ref:`别名目标 <Alias Targets>`。

``INTERFACE``、\ ``PUBLIC``\ 和\ ``PRIVATE``\ 关键字用于指定下列参数的\
:ref:`作用域 <Target Command Scope>`。\ ``PRIVATE``\ 和\ ``PUBLIC``\ 项将填充\
``<target>``\ 的\ :prop_tgt:`PRECOMPILE_HEADERS`\ 属性。\ ``PUBLIC``\ 和\
``INTERFACE`` 项将填充\ ``<target>``\ 的\ :prop_tgt:`INTERFACE_PRECOMPILE_HEADERS`\
属性（:ref:`导入目标 <Imported Targets>`\ 只支持\ ``INTERFACE``\ 项）。重复调用相同的\
``<target>``\ 会按照调用的顺序添加元素。

项目通常应该避免使用\ ``PUBLIC``\ 或\ ``INTERFACE``\ 来\
:command:`导出 <install(EXPORT)>`\ 目标，或者至少应该使用\
:genex:`$<BUILD_INTERFACE:...>`\ 生成器表达式，以防止预编译头出现在已安装的导出目标中。\
目标的消费者通常应该控制他们使用的预编译头，而不是被消费的目标强制使用预编译头（因为预编译头\
通常不是使用要求）。一个明显的例外是，创建\ :ref:`接口库 <Interface Libraries>`\ 时在一个\
地方定义一组常用的预编译头，然后其他目标私有地链接到该接口库。在这种情况下，接口库的存在是为了\
将预编译头信息传播给它的使用者，而使用者实际上仍然处于控制之中，因为它可以决定是否链接到接口库。

头文件列表用于生成一个名为\ ``cmake_pch.h|xx``\ 的头文件，该文件用于生成预编译头文件（\
``.pch``、\ ``.gch``、\ ``.pchi``）工件。\ ``cmake_pch.h|xx``\ 头文件将强制包含（\
``-include``\ 对于GCC， \ ``/FI``\ 对于MSVC）到所有源文件中，因此源文件不需要\
``#include "pch.h"``。

用尖括号指定的头文件名（例如\ ``<unordered_map>``\ ）或显式的双引号（针对\
:manual:`cmake-language(7)`\ 进行转义，例如\ ``[["other_header.h"]]``\ ）将被视为\
原样，并且编译器必须能够找到它们的include目录。其他头文件名（例如\ ``project_header.h``\
）被解释为相对于当前源目录（例如\ :variable:`CMAKE_CURRENT_SOURCE_DIR`\ ），并包含在\
绝对路径中。例如：

.. code-block:: cmake

  target_precompile_headers(myTarget
    PUBLIC
      project_header.h
    PRIVATE
      [["other_header.h"]]
      <unordered_map>
  )

.. |command_name| replace:: ``target_precompile_headers``
.. |more_see_also| replace:: The :genex:`$<COMPILE_LANGUAGE:...>` generator
   expression is particularly useful for specifying a language-specific header
   to precompile for only one language (e.g. ``CXX`` and not ``C``).  In this
   case, header file names that are not explicitly in double quotes or angle
   brackets must be specified by absolute path.  Also, when specifying angle
   brackets inside a generator expression, be sure to encode the closing
   ``>`` as :genex:`$<ANGLE-R>`.  For example:
.. include:: GENEX_NOTE.txt
   :start-line: 1

.. code-block:: cmake

  target_precompile_headers(mylib PRIVATE
    "$<$<COMPILE_LANGUAGE:CXX>:${CMAKE_CURRENT_SOURCE_DIR}/cxx_only.h>"
    "$<$<COMPILE_LANGUAGE:C>:<stddef.h$<ANGLE-R>>"
    "$<$<COMPILE_LANGUAGE:CXX>:<cstddef$<ANGLE-R>>"
  )


Reusing Precompile Headers
^^^^^^^^^^^^^^^^^^^^^^^^^^

The command also supports a second signature which can be used to specify that
one target reuses a precompiled header file artifact from another target
instead of generating its own:

.. code-block:: cmake

  target_precompile_headers(<target> REUSE_FROM <other_target>)

This form sets the :prop_tgt:`PRECOMPILE_HEADERS_REUSE_FROM` property to
``<other_target>`` and adds a dependency such that ``<target>`` will depend
on ``<other_target>``.  CMake will halt with an error if the
:prop_tgt:`PRECOMPILE_HEADERS` property of ``<target>`` is already set when
the ``REUSE_FROM`` form is used.

.. note::

  The ``REUSE_FROM`` form requires the same set of compiler options,
  compiler flags and compiler definitions for both ``<target>`` and
  ``<other_target>``.  Some compilers (e.g. GCC) may issue a warning if the
  precompiled header file cannot be used (``-Winvalid-pch``).

See Also
^^^^^^^^

* To disable precompile headers for specific targets, see the
  :prop_tgt:`DISABLE_PRECOMPILE_HEADERS` target property.

* To prevent precompile headers from being used when compiling a specific
  source file, see the :prop_sf:`SKIP_PRECOMPILE_HEADERS` source file property.

* :command:`target_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_sources`
