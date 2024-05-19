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

By default the library file will be created in the build tree directory
corresponding to the source tree directory in which the command was
invoked.  See documentation of the :prop_tgt:`ARCHIVE_OUTPUT_DIRECTORY`,
:prop_tgt:`LIBRARY_OUTPUT_DIRECTORY`, and
:prop_tgt:`RUNTIME_OUTPUT_DIRECTORY` target properties to change this
location.  See documentation of the :prop_tgt:`OUTPUT_NAME` target
property to change the ``<name>`` part of the final file name.

See the :manual:`cmake-buildsystem(7)` manual for more on defining
buildsystem properties.

See also :prop_sf:`HEADER_FILE_ONLY` on what to do if some sources are
pre-processed, and you want to have the original sources reachable from
within IDE.

对象库
^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> OBJECT <sources>...)
  :target: OBJECT

  添加\ :ref:`对象库 <Object Libraries>`\ 以编译源文件，而无需将其对象文件归档或链接到库中。

Other targets created by ``add_library`` or :command:`add_executable`
may reference the objects using an expression of the
form :genex:`$\<TARGET_OBJECTS:objlib\> <TARGET_OBJECTS>` as a source, where
``objlib`` is the object library name.  For example:

.. code-block:: cmake

  add_library(... $<TARGET_OBJECTS:objlib> ...)
  add_executable(... $<TARGET_OBJECTS:objlib> ...)

will include objlib's object files in a library and an executable
along with those compiled from their own sources.  Object libraries
may contain only sources that compile, header files, and other files
that would not affect linking of a normal library (e.g. ``.txt``).
They may contain custom commands generating such sources, but not
``PRE_BUILD``, ``PRE_LINK``, or ``POST_BUILD`` commands.  Some native build
systems (such as Xcode) may not like targets that have only object files, so
consider adding at least one real source file to any target that references
:genex:`$\<TARGET_OBJECTS:objlib\> <TARGET_OBJECTS>`.

.. versionadded:: 3.12
  Object libraries can be linked to with :command:`target_link_libraries`.

接口库
^^^^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> INTERFACE)
  :target: INTERFACE

  添加一个\ :ref:`接口库 <Interface Libraries>`\ 目标，它可以指定依赖项的使用需求，但\
  不编译源代码，也不会在磁盘上生成库工件。

  An interface library with no source files is not included as a target
  in the generated buildsystem.  However, it may have
  properties set on it and it may be installed and exported.
  Typically, ``INTERFACE_*`` properties are populated on an interface
  target using the commands:

  * :command:`set_property`,
  * :command:`target_link_libraries(INTERFACE)`,
  * :command:`target_link_options(INTERFACE)`,
  * :command:`target_include_directories(INTERFACE)`,
  * :command:`target_compile_options(INTERFACE)`,
  * :command:`target_compile_definitions(INTERFACE)`, and
  * :command:`target_sources(INTERFACE)`,

  and then it is used as an argument to :command:`target_link_libraries`
  like any other target.

  .. versionadded:: 3.15
    An interface library can have :prop_tgt:`PUBLIC_HEADER` and
    :prop_tgt:`PRIVATE_HEADER` properties.  The headers specified by those
    properties can be installed using the :command:`install(TARGETS)` command.

.. signature::
  add_library(<name> INTERFACE [EXCLUDE_FROM_ALL] <sources>...)
  :target: INTERFACE-with-sources

  .. versionadded:: 3.19

  添加带有源文件的\ :ref:`接口库 <Interface Libraries>`\ 目标（除了\
  :command:`上述签名 <add_library(INTERFACE)>`\ 所记录的使用需求和属性之外）。源文件\
  可以直接在\ ``add_library``\ 调用中列出，或者稍后通过使用\ ``PRIVATE``\ 或\
  ``PUBLIC``\ 关键字调用\ :command:`target_sources`\ 添加。

  If an interface library has source files (i.e. the :prop_tgt:`SOURCES`
  target property is set), or header sets (i.e. the :prop_tgt:`HEADER_SETS`
  target property is set), it will appear in the generated buildsystem
  as a build target much like a target defined by the
  :command:`add_custom_target` command.  It does not compile any sources,
  but does contain build rules for custom commands created by the
  :command:`add_custom_command` command.

  The options are:

  ``EXCLUDE_FROM_ALL``
    Set the :prop_tgt:`EXCLUDE_FROM_ALL` target property automatically.
    See documentation of that target property for details.

  .. note::
    In most command signatures where the ``INTERFACE`` keyword appears,
    the items listed after it only become part of that target's usage
    requirements and are not part of the target's own settings.  However,
    in this signature of ``add_library``, the ``INTERFACE`` keyword refers
    to the library type only.  Sources listed after it in the ``add_library``
    call are ``PRIVATE`` to the interface library and do not appear in its
    :prop_tgt:`INTERFACE_SOURCES` target property.

.. _`add_library imported libraries`:

导入库
^^^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> <type> IMPORTED [GLOBAL])
  :target: IMPORTED

  添加一个名为\ ``<name>``\ 的\ :ref:`IMPORTED库目录<Imported Targets>` 。目标名称\
  可以像在项目中构建的任何目标一样被引用，除了默认情况下它只在创建它的目录中可见之外。

  The ``<type>`` must be one of:

  ``STATIC``, ``SHARED``, ``MODULE``, ``UNKNOWN``
    References a library file located outside the project.  The
    :prop_tgt:`IMPORTED_LOCATION` target property (or its per-configuration
    variant :prop_tgt:`IMPORTED_LOCATION_<CONFIG>`) specifies the
    location of the main library file on disk:

    * For a ``SHARED`` library on most non-Windows platforms, the main library
      file is the ``.so`` or ``.dylib`` file used by both linkers and dynamic
      loaders.  If the referenced library file has a ``SONAME`` (or on macOS,
      has a ``LC_ID_DYLIB`` starting in ``@rpath/``), the value of that field
      should be set in the :prop_tgt:`IMPORTED_SONAME` target property.
      If the referenced library file does not have a ``SONAME``, but the
      platform supports it, then  the :prop_tgt:`IMPORTED_NO_SONAME` target
      property should be set.

    * For a ``SHARED`` library on Windows, the :prop_tgt:`IMPORTED_IMPLIB`
      target property (or its per-configuration variant
      :prop_tgt:`IMPORTED_IMPLIB_<CONFIG>`) specifies the location of the
      DLL import library file (``.lib`` or ``.dll.a``) on disk, and the
      ``IMPORTED_LOCATION`` is the location of the ``.dll`` runtime
      library (and is optional, but needed by the :genex:`TARGET_RUNTIME_DLLS`
      generator expression).

    Additional usage requirements may be specified in ``INTERFACE_*``
    properties.

    An ``UNKNOWN`` library type is typically only used in the implementation
    of :ref:`Find Modules`.  It allows the path to an imported library
    (often found using the :command:`find_library` command) to be used
    without having to know what type of library it is.  This is especially
    useful on Windows where a static library and a DLL's import library
    both have the same file extension.

  ``OBJECT``
    References a set of object files located outside the project.
    The :prop_tgt:`IMPORTED_OBJECTS` target property (or its per-configuration
    variant :prop_tgt:`IMPORTED_OBJECTS_<CONFIG>`) specifies the locations of
    object files on disk.
    Additional usage requirements may be specified in ``INTERFACE_*``
    properties.

  ``INTERFACE``
    Does not reference any library or object files on disk, but may
    specify usage requirements in ``INTERFACE_*`` properties.

  The options are:

  ``GLOBAL``
    Make the target name globally visible.

No rules are generated to build imported targets, and the :prop_tgt:`IMPORTED`
target property is ``True``.  Imported libraries are useful for convenient
reference from commands like :command:`target_link_libraries`.

Details about the imported library are specified by setting properties whose
names begin in ``IMPORTED_`` and ``INTERFACE_``.  See documentation of
such properties for more information.

别名库
^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> ALIAS <target>)
  :target: ALIAS

  创建一个\ :ref:`别名目标 <Alias Targets>`，这样\ ``<name>``\ 就可以用来在后续命令中\
  引用\ ``<target>``。\ ``<name>``\ 不会作为make目标出现在生成的构建系统中。\
  ``<target>``\ 不能是\ ``ALIAS``。

.. versionadded:: 3.11
  An ``ALIAS`` can target a ``GLOBAL`` :ref:`Imported Target <Imported Targets>`

.. versionadded:: 3.18
  An ``ALIAS`` can target a non-``GLOBAL`` Imported Target. Such alias is
  scoped to the directory in which it is created and below.
  The :prop_tgt:`ALIAS_GLOBAL` target property can be used to check if the
  alias is global or not.

``ALIAS`` targets can be used as linkable targets and as targets to
read properties from.  They can also be tested for existence with the
regular :command:`if(TARGET)` subcommand.  The ``<name>`` may not be used
to modify properties of ``<target>``, that is, it may not be used as the
operand of :command:`set_property`, :command:`set_target_properties`,
:command:`target_link_libraries` etc.  An ``ALIAS`` target may not be
installed or exported.

另外参阅
^^^^^^^^

* :command:`add_executable`
