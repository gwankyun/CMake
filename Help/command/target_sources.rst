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

为了集成IDE，\ ``PRIVATE``\ 或\ ``PUBLIC``\ 文件集中的文件被标记为源文件。此外，在\
``HEADERS``\ 文件集中的文件的\ :prop_sf:`HEADER_FILE_ONLY`\ 属性被设置为\ ``TRUE``。\
``INTERFACE``\ 或\ ``PUBLIC``\ 文件集中的文件可以用\ :command:`install(TARGETS)`\
命令安装，也可以用\ :command:`install(EXPORT)`\ 和\ :command:`export`\ 命令导出。

每个\ ``target_sources(FILE_SET)``\ 项都以\ ``INTERFACE``、\ ``PUBLIC``\ 或\
``PRIVATE``\ 开头，接受下列参数：

``FILE_SET <set>``

  要创建或添加到其中的文件集的名称。只能包含字母、数字和下划线。以大写字母开头的名称是为\
  CMake预定义的内置文件集保留的。唯一预定义的集合名称是那些与可接受的类型匹配的。所有其他\
  集合名称不得以大写字母或下划线开头。

``TYPE <type>``

  每个文件集都与特定类型的文件相关联。只有上面指定的类型才能使用，其他类型都是错误的。作为\
  一个特殊情况，如果文件集的名称是类型之一，则不需要指定类型，并且可以省略\ ``TYPE <type>``\
  参数。对于所有其他文件集名称，\ ``TYPE``\ 是必需的。

``BASE_DIRS <dirs>...``

  文件集基本目录的可选列表。任何相对路径都被视为相对于当前源目录（即\
  :variable:`CMAKE_CURRENT_SOURCE_DIR`\ ）。如果在第一次创建文件集时没有指定\
  ``BASE_DIRS``，则添加\ :variable:`CMAKE_CURRENT_SOURCE_DIR`\ 的值。这个参数支持\
  :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

  一个文件集的两个基本目录不能互为子目录。添加到文件集中的所有基本目录都必须满足这个要求，\
  而不仅仅是那些在一次\ ``target_sources()``\ 调用中添加的目录。

``FILES <files>...``

  要添加到文件集的可选文件列表。每个文件必须位于其中一个基目录中，或其中一个基目录的子目录中。\
  这个参数支持\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

  如果指定了相对路径，它们被认为是在调用\ ``target_sources()``\ 时相对于\
  :variable:`CMAKE_CURRENT_SOURCE_DIR`\ 的路径。一个例外是以\ ``$<``\ 开始的路径。\
  在生成器表达式求值之后，这些路径被视为相对于目标的源目录的路径。

下列目标属性由\ ``target_sources(FILE_SET)``\ 设置，但通常不应该直接操作。

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

  如果\ ``TYPE``\ 是\ ``HEADERS``，并且文件集的作用域是\ ``PRIVATE``\ 或\ ``PUBLIC``，\
  则文件集的所有\ ``BASE_DIRS``\ 都包装在\ :genex:`$<BUILD_INTERFACE>`\ 中，并附加到\
  此属性。

:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`

  如果\ ``TYPE``\ 是\ ``HEADERS``，并且文件集的范围是\ ``INTERFACE``\ 或\ ``PUBLIC``，\
  则文件集的所有\ ``BASE_DIRS``\ 都包装在\ :genex:`$<BUILD_INTERFACE>`\ 中，并附加到\
  此属性。

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
