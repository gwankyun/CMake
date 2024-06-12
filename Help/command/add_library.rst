add_library
-----------

.. only:: html

   .. contents::

使用特定的源文件向项目添加库。

正常库
^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> [<type>] [EXCLUDE_FROM_ALL] <sources>...)
  :target: normal

  添加一个名为\ ``<name>``\ 的库目标，将从命令调用中列出的源文件构建。

  可选的\ ``<type>``\ 指定要创建的库的类型：

  ``STATIC``
    目标文件的存档，用于链接其他目标时使用。

  ``SHARED``
    可以被其他目标链接并在运行时加载的动态库。

  ``MODULE``
    一个插件，它可能不会被其他目标链接，但可以在运行时使用类似于dlopen的功能动态加载。

  如果没有给出\ ``<type>``，则根据\ :variable:`BUILD_SHARED_LIBS`\ 变量的值默认为\
  ``STATIC``\ 或\ ``SHARED``。

  选项有：

  ``EXCLUDE_FROM_ALL``
    自动设置\ :prop_tgt:`EXCLUDE_FROM_ALL`\ 目标属性。有关详细信息，请参阅该目标属性的文档。

``<name>``\ 对应于逻辑目标名称，并且在项目中必须是全局唯一的。构建的库的实际文件名是基于本\
机平台的约定（例如\ ``lib<name>.a``\ 或\ ``<name>.lib``\ ）构建的。

.. versionadded:: 3.1
  ``add_library``\ 的源参数可以使用语法为\ ``$<...>``\ 的“生成器表达式”。有关可用的表达式，\
  请参阅\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 手册。

.. versionadded:: 3.11
  如果稍后使用\ :command:`target_sources`\ 添加源文件，则可以省略它们。

对于\ ``SHARED``\ 和\ ``MODULE``\ 库，\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\
目标属性被自动设置为\ ``ON``。\ ``SHARED``\ 库可以被标记为\ :prop_tgt:`FRAMEWORK`\
目标属性来创建macOS框架。

.. versionadded:: 3.8
  可以用\ :prop_tgt:`FRAMEWORK`\ 目标属性标记\ ``STATIC``\ 库以创建静态框架。

如果库不导出任何符号，则不得将其声明为\ ``SHARED``\ 库。例如，Windows资源DLL或不导出非托\
管符号的托管C++/CLI DLL需要是\ ``MODULE``\ 库。这是因为CMake希望\ ``SHARED``\ 库在\
Windows上总是有一个关联的导入库。

默认情况下，库文件将在调用命令的源树目录对应的构建树目录中创建。要更改此位置，请参阅\
:prop_tgt:`ARCHIVE_OUTPUT_DIRECTORY`、\ :prop_tgt:`LIBRARY_OUTPUT_DIRECTORY`\ 和\
:prop_tgt:`RUNTIME_OUTPUT_DIRECTORY`\ 目标属性的文档。请参阅\ :prop_tgt:`OUTPUT_NAME`\
目标属性的文档以更改最终文件名的\ ``<name>``\ 部分。

有关定义buildsystem属性的更多信息，请参阅\ :manual:`cmake-buildsystem(7)`\ 手册。

如果某些源代码是预处理过的，并且希望在IDE中可以访问到原始源代码，请参见\
:prop_sf:`HEADER_FILE_ONLY` 。

.. versionchanged:: 3.30

  On platforms that do not support shared libraries, ``add_library``
  now fails on calls creating ``SHARED`` libraries instead of
  automatically converting them to ``STATIC`` libraries as before.
  See policy :policy:`CMP0164`.

对象库
^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> OBJECT <sources>...)
  :target: OBJECT

  添加\ :ref:`对象库 <Object Libraries>`\ 以编译源文件，而无需将其对象文件归档或链接到库中。

``add_library``\ 或\ :command:`add_executable`\ 创建的其他目标可以使用表达式引用对象，\
形式为\ :genex:`$\<TARGET_OBJECTS:objlib\> <TARGET_OBJECTS>`\ 作为源，其中\
``objlib``\ 是对象库的名称。例如：

.. code-block:: cmake

  add_library(... $<TARGET_OBJECTS:objlib> ...)
  add_executable(... $<TARGET_OBJECTS:objlib> ...)

将包含一个库中的objlib的目标文件和一个可执行文件，以及那些从他们自己的源编译的可执行文件。\
对象库可能只包含编译源、头文件和其他文件，这些文件不会影响普通库的链接（例如\ ``.txt``）。\
它们可能包含生成此类源的自定义命令，但不包括\ ``PRE_BUILD``、\ ``PRE_LINK``\ 或\
``POST_BUILD``\ 命令。一些原生的构建系统（例如Xcode）可能不喜欢只有目标文件的目标，所以\
考虑向任何引用\ :genex:`$\<TARGET_OBJECTS:objlib\> <TARGET_OBJECTS>`\ 的目标添加至\
少一个真正的源文件。

.. versionadded:: 3.12
  目标库可以通过\ :command:`target_link_libraries`\ 链接。

接口库
^^^^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> INTERFACE)
  :target: INTERFACE

  添加一个\ :ref:`接口库 <Interface Libraries>`\ 目标，它可以指定依赖项的使用需求，但\
  不编译源代码，也不会在磁盘上生成库工件。

  没有源文件的接口库不会作为目标包含在生成的构建系统中。但是，它可以被设置属性，并且可以被\
  安装和导出。通常，使用以下命令将\ ``INTERFACE_*``\ 属性填充到接口目标：

  * :command:`set_property`,
  * :command:`target_link_libraries(INTERFACE)`,
  * :command:`target_link_options(INTERFACE)`,
  * :command:`target_include_directories(INTERFACE)`,
  * :command:`target_compile_options(INTERFACE)`,
  * :command:`target_compile_definitions(INTERFACE)`, and
  * :command:`target_sources(INTERFACE)`,

  然后像其他目标一样，它被用作\ :command:`target_link_libraries`\ 的参数。

  .. versionadded:: 3.15
    接口库可以有\ :prop_tgt:`PUBLIC_HEADER`\ 和\ :prop_tgt:`PRIVATE_HEADER`\ 属性。\
    由这些属性指定的标头可以使用\ :command:`install(TARGETS)`\ 命令安装。

.. signature::
  add_library(<name> INTERFACE [EXCLUDE_FROM_ALL] <sources>...)
  :target: INTERFACE-with-sources

  .. versionadded:: 3.19

  添加带有源文件的\ :ref:`接口库 <Interface Libraries>`\ 目标（除了\
  :command:`上述签名 <add_library(INTERFACE)>`\ 所记录的使用需求和属性之外）。源文件\
  可以直接在\ ``add_library``\ 调用中列出，或者稍后通过使用\ ``PRIVATE``\ 或\
  ``PUBLIC``\ 关键字调用\ :command:`target_sources`\ 添加。

  如果接口库有源文件（即设置了\ :prop_tgt:`SOURCES`\ 目标属性），或头集（即设置了\
  :prop_tgt:`HEADER_SETS`\ 目标属性），它将作为构建目标出现在生成的构建系统中，非常像\
  :command:`add_custom_target`\ 命令定义的目标。它不编译任何源代码，但包含由\
  :command:`add_custom_command`\ 命令创建的自定义命令的构建规则。

  选项有：

  ``EXCLUDE_FROM_ALL``
    自动设置目标属性\ :prop_tgt:`EXCLUDE_FROM_ALL`。详情请参阅目标属性的文档。

  .. note::
    在大多数出现\ ``INTERFACE``\ 关键字的命令签名中，在它之后列出的项目只成为目标使用需求\
    的一部分，而不是目标自己设置的一部分。不过，在\ ``add_library``\ 的签名中，\
    ``INTERFACE``\ 关键字只表示库的类型。在\ ``add_library``\ 调用中，在它后面列出的源\
    是接口库\ ``PRIVATE``\ 的，不会出现在它的\ :prop_tgt:`INTERFACE_SOURCES`\ 目标属性中。

.. _`add_library imported libraries`:

导入库
^^^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> <type> IMPORTED [GLOBAL])
  :target: IMPORTED

  添加一个名为\ ``<name>``\ 的\ :ref:`IMPORTED库目录<Imported Targets>` 。目标名称\
  可以像在项目中构建的任何目标一样被引用，除了默认情况下它只在创建它的目录中可见之外。

  ``<type>``\ 必须是：

  ``STATIC``, ``SHARED``, ``MODULE``, ``UNKNOWN``
    引用位于项目外部的库文件。\ :prop_tgt:`IMPORTED_LOCATION`\ 目标属性（或其对应的配置\
    变体\ :prop_tgt:`IMPORTED_LOCATION_<CONFIG>`\ ）指定了主库文件在磁盘上的位置：

    * 对于大多数非Windows平台上的\ ``SHARED``\ 库，主库文件是链接器和动态加载器都使用的\
      ``.so``\ 或\ ``.dylib``\ 文件。如果引用的库文件有一个\ ``SONAME``\（或者在macOS\
      上，在\ ``@rpath/``\ 中有一个\ ``LC_ID_DYLIB``\ ），该字段的值应该设置在\
      :prop_tgt:`IMPORTED_SONAME`\ 目标属性中。如果引用的库文件没有\ ``SONAME``，但平\
      台支持它，那么应该设置\ :prop_tgt:`IMPORTED_NO_SONAME`\ 目标属性。

    * 对于Windows上的\ ``SHARED``\ 库，\ :prop_tgt:`IMPORTED_IMPLIB`\ 目标属性（\
      或其每个配置的变体\ :prop_tgt:`IMPORTED_IMPLIB_<CONFIG>`\ ）指定了DLL导入库文件\
      （\ ``.lib``\ 或\ ``.dll.a``\ ）在磁盘上的位置，\ ``IMPORTED_LOCATION``\ 是\
      ``.dll``\ 运行库的位置（并且是可选的，但\ :genex:`TARGET_RUNTIME_DLLS`\ 生成器\
      表达式需要）。

    其他使用要求可以在\ ``INTERFACE_*``\ 属性中指定。

    ``UNKNOWN``\ 库类型通常只在\ :ref:`Find Modules`\ 的实现中使用。它允许使用导入库的\
    路径（通常使用\ :command:`find_library`\ 命令找到），而不必知道它是什么类型的库。\
    这在Windows上特别有用，因为静态库和DLL的导入库都具有相同的文件扩展名。

  ``OBJECT``
    引用一组位于项目外部的目标文件。\ :prop_tgt:`IMPORTED_OBJECTS`\ 目标属性（或它的每\
    个配置变体\ :prop_tgt:`IMPORTED_OBJECTS_<CONFIG>`\ ）指定了对象文件在磁盘上的位置。\
    其他使用要求可以在\ ``INTERFACE_*``\ 属性中指定。

  ``INTERFACE``
    不引用磁盘上的任何库或目标文件，但可以在\ ``INTERFACE_*``\ 属性中指定使用要求。

  选项有：

  ``GLOBAL``
    使目标名称全局可见。

不会生成任何规则来构建导入的目标，并且\ :prop_tgt:`IMPORTED`\ 的目标属性为 ``True``。\
导入的库对于从\ :command:`target_link_libraries`\ 等命令中方便地引用非常有用。

通过设置名称以\ ``IMPORTED_``\ 和\ ``INTERFACE_``\ 开头的属性来指定导入库的详细信息。\
有关更多信息，请参阅此类属性的文档。

别名库
^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> ALIAS <target>)
  :target: ALIAS

  创建一个\ :ref:`别名目标 <Alias Targets>`，这样\ ``<name>``\ 就可以用来在后续命令中\
  引用\ ``<target>``。\ ``<name>``\ 不会作为make目标出现在生成的构建系统中。\
  ``<target>``\ 不能是\ ``ALIAS``。

.. versionadded:: 3.11
  ``ALIAS``\ 可以针对\ ``GLOBAL``\ :ref:`导入目标 <Imported Targets>`

.. versionadded:: 3.18
  ``ALIAS``\ 可以针对非\ ``GLOBAL``\ 导入的目标。这样的别名的作用域是创建它的目录及以下\
  目录。\ :prop_tgt:`ALIAS_GLOBAL`\ 目标属性可用于检查别名是否是全局的。

``ALIAS``\ 目标可以用作可链接的目标，也可以用作从中读取属性的目标。还可以使用常规\
:command:`if(TARGET)`\ 子命令测试它们是否存在。\ ``<name>``\ 不能用于修改\ ``<target>``\
的属性，即不能作为\ :command:`set_property`、\ :command:`set_target_properties`、\
:command:`target_link_libraries`\ 等的操作数。\ ``ALIAS``\ 目标不能安装或导出。

另外参阅
^^^^^^^^

* :command:`add_executable`
