target_sources
--------------

.. versionadded:: 3.1

向目标添加源文件。

.. code-block:: cmake

  target_sources(<target>
    {INTERFACE|PUBLIC|PRIVATE} <source>...
    [{INTERFACE|PUBLIC|PRIVATE} <source>...]...)

指定在构建目标和/或其依赖项时要使用的源。命名的\ ``<target>``\ 必须是由\
:command:`add_executable`\ 或\ :command:`add_library`\ 或\
:command:`add_custom_target`\ 等命令创建的。\ ``<source>``\ 可以使用\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。

.. versionadded:: 3.20
  ``<target>``\ 可以是自定义目标。

.. versionchanged:: 4.5
  If ``<target>`` is an :ref:`Alias Target <Alias Targets>`, the command
  operates on the target which the alias references.

``INTERFACE``、\ ``PUBLIC``\ 和\ ``PRIVATE``\ 关键字需要指定源文件路径的\
:ref:`范围 <Target Command Scope>` （\ ``<source>...``\ ）。\ ``PRIVATE``\ 和\ ``PUBLIC``\
源文件将填充\ ``<target>``\ 的\ :prop_tgt:`SOURCES`\ 属性，该属性在构建目标本身时使用。\
``PUBLIC``\ 和\ ``INTERFACE``\ 源文件将填充\ ``<target>``\ 的\
:prop_tgt:`INTERFACE_SOURCES`\ 属性，该属性在构建依赖项时使用。\
:command:`add_custom_target`\ 创建的目标只能有\ ``PRIVATE``\ 作用域。

重复调用相同的\ ``<target>``\ 将元素按照调用的顺序添加源文件。

.. versionadded:: 3.3
  允许使用\ :prop_tgt:`INTERFACE_SOURCES`\ 导出目标。

.. versionadded:: 3.11
  允许在\ :ref:`导入目标 <Imported Targets>`\ 上设置\ ``INTERFACE``\ 源文件。

.. versionchanged:: 3.13
  相对源文件路径被解释为相对于当前源目录（即\ :variable:`CMAKE_CURRENT_SOURCE_DIR`\ ）。\
  参见策略\ :policy:`CMP0076`。

以生成器表达式开始的路径不会被修改。当目标的\ :prop_tgt:`SOURCE_DIR`\ 属性不同于\
:variable:`CMAKE_CURRENT_SOURCE_DIR`\ 时，在生成器表达式中使用绝对路径来确保源被\
正确地分配给目标。

.. code-block:: cmake

  # 错误：以生成器表达式开头，但使用了相对路径
  target_sources(MyTarget PRIVATE "$<$<CONFIG:Debug>:dbgsrc.cpp>")

  # 正确：在生成器表达式中使用了绝对路径
  target_sources(MyTarget PRIVATE "$<$<CONFIG:Debug>:${CMAKE_CURRENT_SOURCE_DIR}/dbgsrc.cpp>")

有关定义buildsystem属性的更多信息，请参阅\ :manual:`cmake-buildsystem(7)`\ 手册。

文件集
^^^^^^^^^

.. versionadded:: 3.23

.. code-block:: cmake

  target_sources(<target>
    [{INTERFACE|PUBLIC|PRIVATE}
     [FILE_SET <set> [TYPE <type>] [BASE_DIRS <dirs>...] [FILES <files>...]]...
    ]...)

将文件集添加到目标，或将文件添加到现有文件集。目标有零个或多个命名文件集。

See the :manual:`cmake-buildsystem(7)` manual for more on :ref:`File Sets`,
including their types and scope semantics, properties, and installation/export
behavior.

每个\ ``target_sources(FILE_SET)``\ 项都以\ ``INTERFACE``、\ ``PUBLIC``\ 或\
``PRIVATE``\ 开头，接受下列参数：

``FILE_SET <set>``

  要创建或添加到其中的文件集的名称。只能包含字母、数字和下划线。以大写字母开头的\
  名称是为CMake预定义的内置文件集保留的。唯一预定义的集合名称是那些与可接受的类型\
  匹配的。所有其他集合名称不得以大写字母或下划线开头。

``TYPE <type>``

  Every file set is associated with a particular type of file. Only types
  listed under :ref:`File Sets` may be used and it is an error to specify
  anything else. As a special case, if the name of the file set is one of these
  types, the type does not need to be specified and the ``TYPE <type>``
  arguments can be omitted. For all other file set names, ``TYPE`` is required.

  .. versionadded:: 4.5
    ``SYCL`` may be specified as an alias for ``SOURCES``.  It initializes the
    file set's :prop_fs:`LANGUAGE` property to ``SYCL``.

    ``SYCL_HEADERS`` may be specified as an alias for ``HEADERS``.  It also
    initializes :prop_fs:`LANGUAGE` to ``SYCL``.  A target with such a file set
    in its own build specification, or reachable through linked interface
    properties, compiles all of its C++ sources as SYCL.

    The canonical spellings ``FILE_SET SYCL TYPE SOURCES`` and
    ``FILE_SET SYCL_HEADERS TYPE HEADERS`` are also accepted.

    Both aliases are experimental and gated by ``CMAKE_EXPERIMENTAL_SYCL``.

``BASE_DIRS <dirs>...``

  文件集基本目录的可选列表。任何相对路径都被视为相对于当前源目录（即\
  :variable:`CMAKE_CURRENT_SOURCE_DIR`\ ）。如果在第一次创建文件集时没有指定\
  ``BASE_DIRS``，则添加\ :variable:`CMAKE_CURRENT_SOURCE_DIR`\ 的值。这个参数支持\
  :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

  一个文件集的两个基本目录不能互为子目录。添加到文件集中的所有基本目录都必须满足\
  这个要求，而不仅仅是那些在一次\ ``target_sources()``\ 调用中添加的目录。

``FILES <files>...``

  要添加到文件集的可选文件列表。每个文件必须位于其中一个基目录中，或其中一个基\
  目录的子目录中。这个参数支持\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

  如果指定了相对路径，它们被认为是在调用\ ``target_sources()``\ 时相对于\
  :variable:`CMAKE_CURRENT_SOURCE_DIR`\ 的路径。一个例外是以\ ``$<``\ 开始的路径。\
  在生成器表达式求值之后，这些路径被视为相对于目标的源目录的路径。

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
