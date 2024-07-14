target_sources
--------------

.. versionadded:: 3.1

向目标添加源文件。

.. code-block:: cmake

  target_sources(<target>
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

指定在构建目标和/或其依赖项时要使用的源。命名的\ ``<target>``\ 必须是由\
:command:`add_executable`\ 或\ :command:`add_library`\ 或\
:command:`add_custom_target`\ 等命令创建的，并且不能是\
:ref:`别名目标 <Alias Targets>`。\ ``<items>``\ 可以使用\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。

.. versionadded:: 3.20
  ``<target>``\ 可以是自定义目标。

``INTERFACE``、\ ``PUBLIC``\ 和\ ``PRIVATE``\ 关键字需要指定源文件路径的\
:ref:`范围 <Target Command Scope>` （\ ``<items>``\）。\ ``PRIVATE``\ 和\ ``PUBLIC``\
项将填充\ ``<target>``\ 的\ :prop_tgt:`SOURCES`\ 属性，该属性在构建目标本身时使用。\
``PUBLIC``\ 和\ ``INTERFACE``\ 项将填充\ ``<target>``\ 的\
:prop_tgt:`INTERFACE_SOURCES`\ 属性，该属性在构建依赖项时使用。\
:command:`add_custom_target`\ 创建的目标只能有\ ``PRIVATE``\ 作用域。

重复调用相同的\ ``<target>``\ 将元素按照调用的顺序添加。

.. versionadded:: 3.3
  允许使用\ :prop_tgt:`INTERFACE_SOURCES`\ 导出目标。

.. versionadded:: 3.11
  允许在\ :ref:`导入目标 <Imported Targets>`\ 上设置\ ``INTERFACE``\ 项。

.. versionchanged:: 3.13
  相对源文件路径被解释为相对于当前源目录（即\ :variable:`CMAKE_CURRENT_SOURCE_DIR`\ ）。\
  参见策略\ :policy:`CMP0076`。

以生成器表达式开始的路径不会被修改。当目标的\ :prop_tgt:`SOURCE_DIR`\ 属性不同于\
:variable:`CMAKE_CURRENT_SOURCE_DIR`\ 时，在生成器表达式中使用绝对路径来确保源被正确地\
分配给目标。

.. code-block:: cmake

  # WRONG: starts with generator expression, but relative path used
  target_sources(MyTarget PRIVATE "$<$<CONFIG:Debug>:dbgsrc.cpp>")

  # CORRECT: absolute path used inside the generator expression
  target_sources(MyTarget PRIVATE "$<$<CONFIG:Debug>:${CMAKE_CURRENT_SOURCE_DIR}/dbgsrc.cpp>")

有关定义buildsystem属性的更多信息，请参阅\ :manual:`cmake-buildsystem(7)`\ 手册。

.. _`File Sets`:

文件集
^^^^^^^^^

.. versionadded:: 3.23

.. code-block:: cmake

  target_sources(<target>
    [<INTERFACE|PUBLIC|PRIVATE>
     [FILE_SET <set> [TYPE <type>] [BASE_DIRS <dirs>...] [FILES <files>...]]...
    ]...)

将文件集添加到目标，或将文件添加到现有文件集。目标有零个或多个命名文件集。每个文件集都有名称、\
类型、\ ``INTERFACE``\ 、\ ``PUBLIC``\ 或\ ``PRIVATE``\ 范围、一个或多个基本目录以及\
这些目录中的文件。可接受的类型包括：

``HEADERS``

  打算通过语言的\ ``#include``\ 机制使用的源文件。

``CXX_MODULES``
  .. versionadded:: 3.28

  包含C++接口模块或分区单元的源代码（即使用\ ``export``\ 关键字的源代码）。除了\
  ``IMPORTED``\ 目标之外，此文件集类型不能有\ ``INTERFACE``\ 范围。

可选的默认文件集以其类型命名。目标可能不是自定义目标或\ :prop_tgt:`FRAMEWORK`\ 目标。

Files in a ``PRIVATE`` or ``PUBLIC`` file set are marked as source files for
the purposes of IDE integration. Additionally, files in ``HEADERS`` file sets
have their :prop_sf:`HEADER_FILE_ONLY` property set to ``TRUE``. Files in an
``INTERFACE`` or ``PUBLIC`` file set can be installed with the
:command:`install(TARGETS)` command, and exported with the
:command:`install(EXPORT)` and :command:`export` commands.

Each ``target_sources(FILE_SET)`` entry starts with ``INTERFACE``, ``PUBLIC``, or
``PRIVATE`` and accepts the following arguments:

``FILE_SET <set>``

  The name of the file set to create or add to. It must contain only letters,
  numbers and underscores. Names starting with a capital letter are reserved
  for built-in file sets predefined by CMake. The only predefined set names
  are those matching the acceptable types. All other set names must not start
  with a capital letter or
  underscore.

``TYPE <type>``

  Every file set is associated with a particular type of file. Only types
  specified above may be used and it is an error to specify anything else. As
  a special case, if the name of the file set is one of the types, the type
  does not need to be specified and the ``TYPE <type>`` arguments can be
  omitted. For all other file set names, ``TYPE`` is required.

``BASE_DIRS <dirs>...``

  An optional list of base directories of the file set. Any relative path
  is treated as relative to the current source directory
  (i.e. :variable:`CMAKE_CURRENT_SOURCE_DIR`). If no ``BASE_DIRS`` are
  specified when the file set is first created, the value of
  :variable:`CMAKE_CURRENT_SOURCE_DIR` is added. This argument supports
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

  No two base directories for a file set may be sub-directories of each other.
  This requirement must be met across all base directories added to a file set,
  not just those within a single call to ``target_sources()``.

``FILES <files>...``

  An optional list of files to add to the file set. Each file must be in
  one of the base directories, or a subdirectory of one of the base
  directories. This argument supports
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

  If relative paths are specified, they are considered relative to
  :variable:`CMAKE_CURRENT_SOURCE_DIR` at the time ``target_sources()`` is
  called. An exception to this is a path starting with ``$<``. Such paths
  are treated as relative to the target's source directory after evaluation
  of generator expressions.

The following target properties are set by ``target_sources(FILE_SET)``,
but they should not generally be manipulated directly:

对于\ ``HEADERS``\ 类型文件集：

* :prop_tgt:`HEADER_SETS`
* :prop_tgt:`INTERFACE_HEADER_SETS`
* :prop_tgt:`HEADER_SET`
* :prop_tgt:`HEADER_SET_<NAME>`
* :prop_tgt:`HEADER_DIRS`
* :prop_tgt:`HEADER_DIRS_<NAME>`

对于\ ``CXX_MODULES``\ 类型文件集：

* :prop_tgt:`CXX_MODULE_SETS`
* :prop_tgt:`INTERFACE_CXX_MODULE_SETS`
* :prop_tgt:`CXX_MODULE_SET`
* :prop_tgt:`CXX_MODULE_SET_<NAME>`
* :prop_tgt:`CXX_MODULE_DIRS`
* :prop_tgt:`CXX_MODULE_DIRS_<NAME>`

与include目录相关的目标属性也由\ ``target_sources(FILE_SET)``\ 修改，如下所示：

:prop_tgt:`INCLUDE_DIRECTORIES`

  If the ``TYPE`` is ``HEADERS``, and the scope of the file set is ``PRIVATE``
  or ``PUBLIC``, all of the ``BASE_DIRS`` of the file set are wrapped in
  :genex:`$<BUILD_INTERFACE>` and appended to this property.

:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`

  If the ``TYPE`` is ``HEADERS``, and the scope of the file set is
  ``INTERFACE`` or ``PUBLIC``, all of the ``BASE_DIRS`` of the file set are
  wrapped in :genex:`$<BUILD_INTERFACE>` and appended to this property.

另请参阅
^^^^^^^^

* :command:`add_executable`
* :command:`add_library`
* :command:`target_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
