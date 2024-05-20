add_executable
--------------

.. only:: html

  .. contents::

使用指定的源文件向项目添加可执行文件。

正常可执行文件
^^^^^^^^^^^^^^^^^^

.. signature::
  add_executable(<name> <options>... <sources>...)
  :target: normal

  添加一个名为\ ``<name>``\ 的可执行目标，以便从命令调用中列出的源文件构建。

  选项有：

  ``WIN32``
    自动设置\ :prop_tgt:`WIN32_EXECUTABLE`\ 目标属性。有关详细信息，请参阅该目标属性的文档。

  ``MACOSX_BUNDLE``
    自动设置\ :prop_tgt:`MACOSX_BUNDLE`\ 目标属性。有关详细信息，请参阅该目标属性的文档。

  ``EXCLUDE_FROM_ALL``
    自动设置\ :prop_tgt:`EXCLUDE_FROM_ALL`\ 目标属性。有关详细信息，请参阅该目标属性的文档。

``<name>``\ 对应于逻辑目标名称，并且在项目中必须是全局唯一的。构建的可执行文件的实际文件名\
是基于本地平台的约定构建的（例如\ ``<name>.exe``\ 或只是\ ``<name>``）。

.. versionadded:: 3.1
  ``add_executable``\ 的源参数可以使用语法为\ ``$<...>``\ 的“生成器表达式”。有关可用的\
  表达式，请参阅\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 手册。

.. versionadded:: 3.11
  如果稍后使用\ :command:`target_sources`\ 添加源文件，则可以省略它们。

默认情况下，将在与调用命令的源树目录相对应的构建树目录中创建可执行文件。请参阅\
:prop_tgt:`RUNTIME_OUTPUT_DIRECTORY`\ 目标属性的文档来更改此位置。请参阅\
:prop_tgt:`OUTPUT_NAME`\ 目标属性的文档，以更改最终文件名的\ ``<name>``\ 部分。

有关定义buildsystem属性的更多信息，请参阅\ :manual:`cmake-buildsystem(7)`\ 手册。

另请参阅\ :prop_sf:`HEADER_FILE_ONLY`，了解如果对某些源进行了预处理，并且希望从IDE中访\
问原始源该怎么办。

导入的可执行文件
^^^^^^^^^^^^^^^^^^^^

.. signature::
  add_executable(<name> IMPORTED [GLOBAL])
  :target: IMPORTED

  添加\ :ref:`IMPORTED可执行目标 <Imported Targets>` ，以引用位于项目外部的可执行文件。\
  目标名称可以像在项目中构建的任何目标一样被引用，除了默认情况下它只在创建它的目录中可见之外。

  选项有：

  ``GLOBAL``
    使目标名称全局可见。

不会生成任何规则来构建导入的目标，并且\ :prop_tgt:`IMPORTED`\ 目标属性为\ ``True``。\
导入的可执行文件对于方便地从\ :command:`add_custom_command`\ 等命令引用非常有用。

导入的可执行文件的详细信息通过设置名称以\ ``IMPORTED_``\ 开头的属性来指定。这类属性中最重\
要的是\ :prop_tgt:`IMPORTED_LOCATION`\（以及它的每个配置版本\
:prop_tgt:`IMPORTED_LOCATION_<CONFIG>`），它指定了主可执行文件在磁盘上的位置。有关更多\
信息，请参阅\ ``IMPORTED_*``\ 属性的文档。

可执行文件别名
^^^^^^^^^^^^^^^^^

.. signature::
  add_executable(<name> ALIAS <target>)
  :target: ALIAS

  创建一个\ :ref:`Alias Target <Alias Targets>`，这样\ ``<name>``\ 就可以用来在后续\
  命令中引用\ ``<target>``。\ ``<name>``\ 不会作为make目标出现在生成的构建系统中。\
  ``<target>``\ 不能是\ ``ALIAS``。

.. versionadded:: 3.11
  ``ALIAS``\ 可以针对\ ``GLOBAL``\ :ref:`导入目标 <Imported Targets>`

.. versionadded:: 3.18
  ``ALIAS`` 可以针对非\ ``GLOBAL``\ 导入的目标。这样的别名的作用域是创建它的目录和子目录。\
  :prop_tgt:`ALIAS_GLOBAL`\ 目标属性可用于检查别名是否是全局的。

``ALIAS``\ 目标可以用作目标来读取自定义命令和自定义目标的可执行文件的属性。还可以使用常规\
:command:`if(TARGET)`\ 子命令测试它们是否存在。\ ``<name>``\ 不能用于修改\ ``<target>``\
的属性，即不能作为\ :command:`set_property`、\ :command:`set_target_properties`、\
:command:`target_link_libraries`\ 等的操作数。\ ``ALIAS``\ 目标不能安装或导出。

另请参阅
^^^^^^^^

* :command:`add_library`
