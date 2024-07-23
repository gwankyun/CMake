target_include_directories
--------------------------

将包含目录添加到目标。

.. code-block:: cmake

  target_include_directories(<target> [SYSTEM] [AFTER|BEFORE]
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

指定编译给定目标时要使用的包含目录。命名的\ ``<target>``\ 必须是由\ :command:`add_executable`\
或\ :command:`add_library`\ 等命令创建的，并且不能是\ :ref:`别名目标 <Alias Targets>`。

通过显式地使用\ ``AFTER``\ 或\ ``BEFORE``，你可以在附加和前置之间进行选择，而不依赖于默认值。

``INTERFACE``、\ ``PUBLIC``\ 和\ ``PRIVATE``\ 关键字用于指定下列参数的\
:ref:`作用域 <Target Command Scope>`。\ ``PRIVATE``\ 和\ ``PUBLIC``\ 项将填充\
``<target>``\ 的\ :prop_tgt:`INCLUDE_DIRECTORIES`\ 属性。\ ``PUBLIC``\ 和\
``INTERFACE``\ 项将填充\ ``<target>``\ 的\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\
属性。下列参数指定包含目录。

.. versionadded:: 3.11
  允许在\ :ref:`IMPORTED目标 <Imported Targets>`\ 上设置\ ``INTERFACE``\ 项。

重复调用相同的\ ``<target>``\ 将元素按照调用的顺序添加。

如果指定了\ ``SYSTEM``，编译器将被告知这些目录是指某些平台上的系统包含的目录。这可能会有抑制\
警告或在依赖计算中跳过包含的头信息等效果（参见编译器文档)。此外，会在正常包含目录之后搜索系统\
包含目录，无论指定的顺序如何。

如果\ ``SYSTEM``\ 与\ ``PUBLIC``\ 或\ ``INTERFACE``\ 一起使用，则\
:prop_tgt:`INTERFACE_SYSTEM_INCLUDE_DIRECTORIES`\ 目标属性将填充指定的目录。

.. |command_name| replace:: ``target_include_directories``
.. include:: GENEX_NOTE.txt

指定的包含目录可以是绝对路径或相对路径。相对路径将被解释为相对于当前源目录（即\
:variable:`CMAKE_CURRENT_SOURCE_DIR`\ ），并在存储到相关的目标属性之前转换为绝对路径。\
如果路径以生成器表达式开始，它将始终被假定为绝对路径（下面有一个例外），并且将不加修改地使用。

包括构建树和安装树之间的目录使用要求通常不同。\ :genex:`BUILD_INTERFACE`\ 和\
:genex:`INSTALL_INTERFACE`\ 生成器表达式可用于根据使用位置描述单独的使用需求。\
:genex:`INSTALL_INTERFACE`\ 表达式中允许使用相对路径，并将其解释为相对于安装前缀。\
:genex:`BUILD_INTERFACE`\ 表达式中不应该使用相对路径，因为它们不会被转换为绝对路径。例如：

.. code-block:: cmake

  target_include_directories(mylib PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/mylib>
    $<INSTALL_INTERFACE:include/mylib>  # <prefix>/include/mylib
  )

创建可重定位的包
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. |INTERFACE_PROPERTY_LINK| replace:: :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`
.. include:: /include/INTERFACE_INCLUDE_DIRECTORIES_WARNING.txt

另外参阅
^^^^^^^^

* :command:`include_directories`
* :command:`target_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`
