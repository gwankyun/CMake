.. cmake-manual-description: CMake Buildsystem Reference

cmake-buildsystem(7)
********************

.. only:: html

   .. contents::

引言
============

基于CMake的构建系统被组织为一组高级逻辑目标。每个目标对应于一个可执行文件或库，或者是包含自\
定义命令的自定义目标。目标之间的依赖关系在构建系统中表示，以确定构建顺序和响应更改的重新生成规则。

二进制目标
==============

可执行文件和库使用\ :command:`add_executable`\ 和\ :command:`add_library`\ 命令定义。\
生成的二进制文件具有针对平台的适当\ :prop_tgt:`PREFIX`、:prop_tgt:`SUFFIX`\ 和扩展名。\
二进制目标之间的依赖关系使用\ :command:`target_link_libraries`\ 命令表示：

.. code-block:: cmake

  add_library(archive archive.cpp zip.cpp lzma.cpp)
  add_executable(zipapp zipapp.cpp)
  target_link_libraries(zipapp archive)

``archive``\ 被定义为一个\ ``STATIC``\ 库——一个包含\ ``archive.cpp``、\ ``zip.cpp``\
和\ ``lzma.cpp``\ 编译对象的存档。\ ``zipapp``\ 被定义为通过编译和链接\ ``zipapp.cpp``\
而形成的可执行文件。当链接\ ``zipapp``\ 可执行文件时，\ ``archive``\ 静态库会被链接到。

.. _`Binary Executables`:

二进制可执行文件
------------------

:command:`add_executable`\ 命令定义了一个可执行目标：

.. code-block:: cmake

  add_executable(mytool mytool.cpp)

像\ :command:`add_custom_command`\ 这样的命令，它生成要在构建时运行的规则，\
可以透明地将\ :prop_tgt:`EXECUTABLE <TYPE>`\ 目标作为可执行\ ``COMMAND``\ 文件使用。\
构建系统规则将确保在尝试运行命令之前构建可执行文件。

二进制库类型
--------------------

.. _`Normal Libraries`:

普通库
^^^^^^^^^^^^^^^^

默认情况下，:command:`add_library`\ 命令定义了一个\ ``STATIC``\ 库，除非指定了类型。\
使用这个命令时，可以指定一个类型：

.. code-block:: cmake

  add_library(archive SHARED archive.cpp zip.cpp lzma.cpp)

.. code-block:: cmake

  add_library(archive STATIC archive.cpp zip.cpp lzma.cpp)

可以启用\ :variable:`BUILD_SHARED_LIBS`\ 变量来改变\ :command:`add_library`\ 的行为，\
默认情况下构建共享库。

在整个构建系统定义的上下语境中，特定的库是\ ``SHARED``\ 还是\ ``STATIC``\ 在很大程度上是\
无关紧要的——不管库的类型如何，命令、依赖规范和其他API的工作方式都是类似的。\ ``MODULE``\
库类型的不同之处在于，它通常不会被链接到——它不会在\ :command:`target_link_libraries`\
命令的右侧被使用。它是一个使用运行时技术作为插件加载的类型。如果库不导出任何非托管符号\
（例如Windows资源DLL, C++/CLI DLL），则要求库不是\ ``SHARED``\ 库，因为CMake希望\
``SHARED``\ 库至少导出一个符号。

.. code-block:: cmake

  add_library(archive MODULE 7z.cpp)

.. _`Apple Frameworks`:

苹果框架
""""""""""""""""

一个\ ``SHARED``\ 库可以被标记为\ :prop_tgt:`FRAMEWORK`\ 目标属性来创建一个macOS或iOS\
框架Bundle。带有\ ``FRAMEWORK``\ 目标属性的库还应该设置\ :prop_tgt:`FRAMEWORK_VERSION`\
目标属性。根据macOS约定，该属性通常设置为“A”。\ ``MACOSX_FRAMEWORK_IDENTIFIER``\ 设置为\
``CFBundleIdentifier``\ 键，它用作bundle的唯一标识。

.. code-block:: cmake

  add_library(MyFramework SHARED MyFramework.cpp)
  set_target_properties(MyFramework PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A # Version "A" is macOS convention
    MACOSX_FRAMEWORK_IDENTIFIER org.cmake.MyFramework
  )

.. _`Object Libraries`:

目标库
^^^^^^^^^^^^^^^^

``OBJECT``\ 库类型定义了由编译给定源文件产生的目标文件的非归档集合。\
通过使用语法\ :genex:`$<TARGET_OBJECTS:name>`，对象文件集合可以用作其他目标的源输入。\
这是一个\ :manual:`generator expression <cmake-generator-expressions(7)>`，\
可以用来向其他目标提供\ ``OBJECT``\ 库内容：

.. code-block:: cmake

  add_library(archive OBJECT archive.cpp zip.cpp lzma.cpp)

  add_library(archiveExtras STATIC $<TARGET_OBJECTS:archive> extras.cpp)

  add_executable(test_exe $<TARGET_OBJECTS:archive> test.cpp)

这些其他目标的链接（或归档）步骤将使用对象文件集合以及它们自己的源文件。

或者，对象库可以链接到其他目标：

.. code-block:: cmake

  add_library(archive OBJECT archive.cpp zip.cpp lzma.cpp)

  add_library(archiveExtras STATIC extras.cpp)
  target_link_libraries(archiveExtras PUBLIC archive)

  add_executable(test_exe test.cpp)
  target_link_libraries(test_exe archive)

其他目标的链接（或归档）步骤将\ *直接*\ 链接的\ ``OBJECT``\ 库中的对象文件。\
此外，当在其他目标中编译源代码时，``OBJECT``\ 库的使用需求将得到满足。\
此外，这些使用需求将传递到那些其他目标的依赖项。

在使用\ :command:`add_custom_command(TARGET)`\ 命令签名时，对象库不能用作\ ``TARGET``。\
但是，对象列表可以通过\ :command:`add_custom_command(OUTPUT)`\ 或\
:command:`file(GENERATE)`\ 使用\ ``$<TARGET_OBJECTS:objlib>``。

构建规范和使用要求
==========================================

Targets build according to their own
`build specification <Target Build Specification_>`_ in combination with
`usage requirements <Target Usage Requirements_>`_ propagated from their
link dependencies.  Both may be specified using target-specific
`commands <Target Commands_>`_.

For example:

.. code-block:: cmake

  add_library(archive SHARED archive.cpp zip.cpp)

  if (LZMA_FOUND)
    # Add a source implementing support for lzma.
    target_sources(archive PRIVATE lzma.cpp)

    # Compile the 'archive' library sources with '-DBUILDING_WITH_LZMA'.
    target_compile_definitions(archive PRIVATE BUILDING_WITH_LZMA)
  endif()

  target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

  add_executable(consumer consumer.cpp)

  # Link 'consumer' to 'archive'.  This also consumes its usage requirements,
  # so 'consumer.cpp' is compiled with '-DUSING_ARCHIVE_LIB'.
  target_link_libraries(consumer archive)


Target Commands
---------------

Target-specific commands populate the
`build specification <Target Build Specification_>`_ of `二进制目标`_ and
`usage requirements <Target Usage Requirements_>`_ of `二进制目标`_,
`Interface Libraries`_, and `Imported Targets`_.

.. _`Target Command Scope`:

Invocations must specify scope keywords, each affecting the visibility
of arguments following it.  The scopes are:

``PUBLIC``
  Populates both properties for `building <Target Build Specification_>`_
  and properties for `using <Target Usage Requirements_>`_ a target.

``PRIVATE``
  Populates only properties for `building <Target Build Specification_>`_
  a target.

``INTERFACE``
  Populates only properties for `using <Target Usage Requirements_>`_
  a target.

The commands are:

:command:`target_compile_definitions`
  Populates the :prop_tgt:`COMPILE_DEFINITIONS` build specification and
  :prop_tgt:`INTERFACE_COMPILE_DEFINITIONS` usage requirement properties.

  For example, the call

  .. code-block:: cmake

    target_compile_definitions(archive
      PRIVATE   BUILDING_WITH_LZMA
      INTERFACE USING_ARCHIVE_LIB
    )

  appends ``BUILDING_WITH_LZMA`` to the target's ``COMPILE_DEFINITIONS``
  property and appends ``USING_ARCHIVE_LIB`` to the target's
  ``INTERFACE_COMPILE_DEFINITIONS`` property.

:command:`target_compile_options`
  Populates the :prop_tgt:`COMPILE_OPTIONS` build specification and
  :prop_tgt:`INTERFACE_COMPILE_OPTIONS` usage requirement properties.

:command:`target_compile_features`
  .. versionadded:: 3.1

  Populates the :prop_tgt:`COMPILE_FEATURES` build specification and
  :prop_tgt:`INTERFACE_COMPILE_FEATURES` usage requirement properties.

:command:`target_include_directories`
  Populates the :prop_tgt:`INCLUDE_DIRECTORIES` build specification
  and :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` usage requirement
  properties.  With the ``SYSTEM`` option, it also populates the
  :prop_tgt:`INTERFACE_SYSTEM_INCLUDE_DIRECTORIES` usage requirement.

  For convenience, the :variable:`CMAKE_INCLUDE_CURRENT_DIR` variable
  may be enabled to add the source directory and corresponding build
  directory as ``INCLUDE_DIRECTORIES`` on all targets.  Similarly,
  the :variable:`CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE` variable may
  be enabled to add them as ``INTERFACE_INCLUDE_DIRECTORIES`` on all
  targets.

:command:`target_sources`
  .. versionadded:: 3.1

  Populates the :prop_tgt:`SOURCES` build specification and
  :prop_tgt:`INTERFACE_SOURCES` usage requirement properties.

  It also supports specifying :ref:`File Sets`, which can add C++ module
  sources and headers not listed in the ``SOURCES`` and ``INTERFACE_SOURCES``
  properties.  File sets may also populate the :prop_tgt:`INCLUDE_DIRECTORIES`
  build specification and :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` usage
  requirement properties with the include directories containing the headers.

:command:`target_precompile_headers`
  .. versionadded:: 3.16

  Populates the :prop_tgt:`PRECOMPILE_HEADERS` build specification and
  :prop_tgt:`INTERFACE_PRECOMPILE_HEADERS` usage requirement properties.

:command:`target_link_libraries`
  Populates the :prop_tgt:`LINK_LIBRARIES` build specification
  and :prop_tgt:`INTERFACE_LINK_LIBRARIES` usage requirement properties.

  This is the primary mechanism by which link dependencies and their
  `usage requirements <Target Usage Requirements_>`_ are transitively
  propagated to affect compilation and linking of a target.

:command:`target_link_directories`
  .. versionadded:: 3.13

  Populates the :prop_tgt:`LINK_DIRECTORIES` build specification and
  :prop_tgt:`INTERFACE_LINK_DIRECTORIES` usage requirement properties.

:command:`target_link_options`
  .. versionadded:: 3.13

  Populates the :prop_tgt:`LINK_OPTIONS` build specification and
  :prop_tgt:`INTERFACE_LINK_OPTIONS` usage requirement properties.

.. _`Target Build Specification`:

Target Build Specification
--------------------------

The build specification of `二进制目标`_ is represented by target
properties.  For each of the following `compile <Target Compile Properties_>`_
and `link <Target Link Properties_>`_ properties, compilation and linking
of the target is affected both by its own value and by the corresponding
`usage requirement <Target Usage Requirements_>`_ property, named with
an ``INTERFACE_`` prefix, collected from the transitive closure of link
dependencies.

.. _`Target Compile Properties`:

Target Compile Properties
^^^^^^^^^^^^^^^^^^^^^^^^^

These represent the `build specification <Target Build Specification_>`_
for compiling a target.

:prop_tgt:`COMPILE_DEFINITIONS`
  List of compile definitions for compiling sources in the target.
  These are passed to the compiler with ``-D`` flags, or equivalent,
  in an unspecified order.

  The :prop_tgt:`DEFINE_SYMBOL` target property is also used
  as a compile definition as a special convenience case for
  ``SHARED`` and ``MODULE`` library targets.

:prop_tgt:`COMPILE_OPTIONS`
  List of compile options for compiling sources in the target.
  These are passed to the compiler as flags, in the order of appearance.

  Compile options are automatically escaped for the shell.

  Some compile options are best specified via dedicated settings,
  such as the :prop_tgt:`POSITION_INDEPENDENT_CODE` target property.

:prop_tgt:`COMPILE_FEATURES`
  .. versionadded:: 3.1

  List of :manual:`compile features <cmake-compile-features(7)>` needed
  for compiling sources in the target.  Typically these ensure the
  target's sources are compiled using a sufficient language standard level.

:prop_tgt:`INCLUDE_DIRECTORIES`
  List of include directories for compiling sources in the target.
  These are passed to the compiler with ``-I`` or ``-isystem`` flags,
  or equivalent, in the order of appearance.

  For convenience, the :variable:`CMAKE_INCLUDE_CURRENT_DIR` variable
  may be enabled to add the source directory and corresponding build
  directory as ``INCLUDE_DIRECTORIES`` on all targets.

:prop_tgt:`SOURCES`
  List of source files associated with the target.  This includes sources
  specified when the target was created by the :command:`add_executable`,
  :command:`add_library`, or :command:`add_custom_target` command.
  It also includes sources added by the :command:`target_sources` command,
  but does not include :ref:`File Sets`.

:prop_tgt:`PRECOMPILE_HEADERS`
  .. versionadded:: 3.16

  List of header files to precompile and include when compiling
  sources in the target.

:prop_tgt:`AUTOMOC_MACRO_NAMES`
  .. versionadded:: 3.10

  List of macro names used by :prop_tgt:`AUTOMOC` to determine if a
  C++ source in the target needs to be processed by ``moc``.

:prop_tgt:`AUTOUIC_OPTIONS`
  .. versionadded:: 3.0

  List of options used by :prop_tgt:`AUTOUIC` when invoking ``uic``
  for the target.

.. _`Target Link Properties`:

Target Link Properties
^^^^^^^^^^^^^^^^^^^^^^

These represent the `build specification <Target Build Specification_>`_
for linking a target.

:prop_tgt:`LINK_LIBRARIES`
  List of link libraries for linking the target, if it is an executable,
  shared library, or module library.  Entries for `Normal Libraries`_ are
  passed to the linker either via paths to their link artifacts, or
  with ``-l`` flags or equivalent.  Entries for `Object Libraries`_ are
  passed to the linker via paths to their object files.

  Additionally, for compiling and linking the target itself,
  `usage requirements <Target Usage Requirements_>`_ are propagated from
  ``LINK_LIBRARIES`` entries naming `Normal Libraries`_,
  `Interface Libraries`_, `Object Libraries`_, and `Imported Targets`_,
  collected over the transitive closure of their
  :prop_tgt:`INTERFACE_LINK_LIBRARIES` properties.

:prop_tgt:`LINK_DIRECTORIES`
  .. versionadded:: 3.13

  List of link directories for linking the target, if it is an executable,
  shared library, or module library.  The directories are passed to the
  linker with ``-L`` flags, or equivalent.

:prop_tgt:`LINK_OPTIONS`
  .. versionadded:: 3.13

  List of link options for linking the target, if it is an executable,
  shared library, or module library.  The options are passed to the
  linker as flags, in the order of appearance.

  Link options are automatically escaped for the shell.

:prop_tgt:`LINK_DEPENDS`
  List of files on which linking the target depends, if it is an executable,
  shared library, or module library.  For example, linker scripts specified
  via :prop_tgt:`LINK_OPTIONS` may be listed here such that changing them
  causes binaries to be linked again.

.. _`Target Usage Requirements`:

Target Usage Requirements
-------------------------

The *usage requirements* of a target are settings that propagate to consumers,
which link to the target via :command:`target_link_libraries`, in order to
correctly compile and link with it.  They are represented by transitive
`compile <Transitive Compile Properties_>`_ and
`link <Transitive Link Properties_>`_ properties.

Note that usage requirements are not designed as a way to make downstreams
use particular :prop_tgt:`COMPILE_OPTIONS`, :prop_tgt:`COMPILE_DEFINITIONS`,
etc. for convenience only.  The contents of the properties must be
**requirements**, not merely recommendations.

See the :ref:`Creating Relocatable Packages` section of the
:manual:`cmake-packages(7)` manual for discussion of additional care
that must be taken when specifying usage requirements while creating
packages for redistribution.

The usage requirements of a target can transitively propagate to the dependents.
The :command:`target_link_libraries` command has ``PRIVATE``,
``INTERFACE`` and ``PUBLIC`` keywords to control the propagation.

目标的使用需求可以传递到依赖项。:command:`target_link_libraries`\ 命令具有\
``PRIVATE``、\ ``INTERFACE``\ 和\ ``PUBLIC``\ 关键字来控制传播。

.. code-block:: cmake

  add_library(archive archive.cpp)
  target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

  add_library(serialization serialization.cpp)
  target_compile_definitions(serialization INTERFACE USING_SERIALIZATION_LIB)

  add_library(archiveExtras extras.cpp)
  target_link_libraries(archiveExtras PUBLIC archive)
  target_link_libraries(archiveExtras PRIVATE serialization)
  # archiveExtras is compiled with -DUSING_ARCHIVE_LIB
  # and -DUSING_SERIALIZATION_LIB

  add_executable(consumer consumer.cpp)
  # consumer is compiled with -DUSING_ARCHIVE_LIB
  target_link_libraries(consumer archiveExtras)

因为\ ``archive``\ 是\ ``archiveExtras``\ 的\ ``PUBLIC``\ 依赖项，所以它的使用需求也\
会传播给\ ``consumer``。

因为\ ``serialization``\ 是\ ``archiveExtras``\ 的\ ``PRIVATE``\ 依赖项，所以它的使\
用需求不会传播给\ ``consumer``。

通常，如果依赖项只在库的实现，而不是头文件中使用，则应该使用\
:command:`target_link_libraries`\ 和\ ``PRIVATE``\ 关键字指定依赖项。如果一个依赖在库\
的头文件中被额外使用（例如用于类继承），那么它应该被指定为\ ``PUBLIC``\ 依赖。一个库的实现\
中没有使用的依赖项，只有它的头文件才使用它，则应该被指定为一个\ ``INTERFACE``\ 依赖项。\
:command:`target_link_libraries`\ 命令可以对每个关键字进行多次调用：

.. code-block:: cmake

  target_link_libraries(archiveExtras
    PUBLIC archive
    PRIVATE serialization
  )

使用要求是通过从依赖项中读取目标属性的\ ``INTERFACE_``\ 变量并将值附加到操作数的非\
``INTERFACE_``\ 变量来传播的。例如，读取依赖关系的\
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 并将其附加到操作数的\
:prop_tgt:`INCLUDE_DIRECTORIES`\ 中。如果顺序是相关的且被维护，并且\
:command:`target_link_libraries`\ 调用产生的顺序不允许正确的编译，则可以使用适当的命令\
直接设置属性来更新顺序。

例如，如果一个目标的链接库必须按照\ ``lib1`` ``lib2`` ``lib3``\ 的顺序指定，\
但是包含目录必须按照\ ``lib3`` ``lib1`` ``lib2``\ 的顺序指定：

.. code-block:: cmake

  target_link_libraries(myExe lib1 lib2 lib3)
  target_include_directories(myExe
    PRIVATE $<TARGET_PROPERTY:lib3,INTERFACE_INCLUDE_DIRECTORIES>)

请注意，在指定将使用\ :command:`install(EXPORT)`\ 命令导出以进行安装的目标的使用要求时，\
必须格外小心。有关更多信息，请参阅\ :ref:`Creating Packages`。

.. _`Transitive Compile Properties`:

Transitive Compile Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

These represent `usage requirements <Target Usage Requirements_>`_ for
compiling consumers.

:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`
  List of compile definitions for compiling sources in the target's consumers.
  Typically these are used by the target's header files.

:prop_tgt:`INTERFACE_COMPILE_OPTIONS`
  List of compile options for compiling sources in the target's consumers.

:prop_tgt:`INTERFACE_COMPILE_FEATURES`
  .. versionadded:: 3.1

  List of :manual:`compile features <cmake-compile-features(7)>` needed
  for compiling sources in the target's consumers.  Typically these
  ensure the target's header files are processed when compiling consumers
  using a sufficient language standard level.

:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`
  List of include directories for compiling sources in the target's consumers.
  Typically these are the locations of the target's header files.

:prop_tgt:`INTERFACE_SYSTEM_INCLUDE_DIRECTORIES`
  List of directories that, when specified as include directories, e.g., by
  :prop_tgt:`INCLUDE_DIRECTORIES` or :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`,
  should be treated as "system" include directories when compiling sources
  in the target's consumers.

:prop_tgt:`INTERFACE_SOURCES`
  List of source files to associate with the target's consumers.

:prop_tgt:`INTERFACE_PRECOMPILE_HEADERS`
  .. versionadded:: 3.16

  List of header files to precompile and include when compiling
  sources in the target's consumers.

:prop_tgt:`INTERFACE_AUTOMOC_MACRO_NAMES`
  .. versionadded:: 3.27

  List of macro names used by :prop_tgt:`AUTOMOC` to determine if a
  C++ source in the target's consumers needs to be processed by ``moc``.

:prop_tgt:`INTERFACE_AUTOUIC_OPTIONS`
  .. versionadded:: 3.0

  List of options used by :prop_tgt:`AUTOUIC` when invoking ``uic``
  for the target's consumers.

.. _`Transitive Link Properties`:

Transitive Link Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^

These represent `usage requirements <Target Usage Requirements_>`_ for
linking consumers.

:prop_tgt:`INTERFACE_LINK_LIBRARIES`
  List of link libraries for linking the target's consumers, for
  those that are executables, shared libraries, or module libraries.
  These are the transitive dependencies of the target.

  Additionally, for compiling and linking the target's consumers,
  `usage requirements <Target Usage Requirements_>`_ are collected from
  the transitive closure of ``INTERFACE_LINK_LIBRARIES`` entries naming
  `Normal Libraries`_, `Interface Libraries`_, `Object Libraries`_,
  and `Imported Targets`_,

:prop_tgt:`INTERFACE_LINK_DIRECTORIES`
  .. versionadded:: 3.13

  List of link directories for linking the target's consumers, for
  those that are executables, shared libraries, or module libraries.

:prop_tgt:`INTERFACE_LINK_OPTIONS`
  .. versionadded:: 3.13

  List of link options for linking the target's consumers, for
  those that are executables, shared libraries, or module libraries.

:prop_tgt:`INTERFACE_LINK_DEPENDS`
  .. versionadded:: 3.13

  List of files on which linking the target's consumers depends, for
  those that are executables, shared libraries, or module libraries.

.. _`Custom Transitive Properties`:

Custom Transitive Properties
----------------------------

.. versionadded:: 3.30

The :genex:`TARGET_PROPERTY` generator expression evaluates the above
`build specification <Target Build Specification_>`_ and
`usage requirement <Target Usage Requirements_>`_ properties
as builtin transitive properties.  It also supports custom transitive
properties defined by the :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`
and :prop_tgt:`TRANSITIVE_LINK_PROPERTIES` properties on the target
and its link dependencies.

For example:

.. code-block:: cmake

  add_library(example INTERFACE)
  set_target_properties(example PROPERTIES
    TRANSITIVE_COMPILE_PROPERTIES "CUSTOM_C"
    TRANSITIVE_LINK_PROPERTIES    "CUSTOM_L"

    INTERFACE_CUSTOM_C "EXAMPLE_CUSTOM_C"
    INTERFACE_CUSTOM_L "EXAMPLE_CUSTOM_L"
    )

  add_library(mylib STATIC mylib.c)
  target_link_libraries(mylib PRIVATE example)
  set_target_properties(mylib PROPERTIES
    CUSTOM_C           "MYLIB_PRIVATE_CUSTOM_C"
    CUSTOM_L           "MYLIB_PRIVATE_CUSTOM_L"
    INTERFACE_CUSTOM_C "MYLIB_IFACE_CUSTOM_C"
    INTERFACE_CUSTOM_L "MYLIB_IFACE_CUSTOM_L"
    )

  add_executable(myexe myexe.c)
  target_link_libraries(myexe PRIVATE mylib)
  set_target_properties(myexe PROPERTIES
    CUSTOM_C "MYEXE_CUSTOM_C"
    CUSTOM_L "MYEXE_CUSTOM_L"
    )

  add_custom_target(print ALL VERBATIM
    COMMAND ${CMAKE_COMMAND} -E echo
      # Prints "MYLIB_PRIVATE_CUSTOM_C;EXAMPLE_CUSTOM_C"
      "$<TARGET_PROPERTY:mylib,CUSTOM_C>"

      # Prints "MYLIB_PRIVATE_CUSTOM_L;EXAMPLE_CUSTOM_L"
      "$<TARGET_PROPERTY:mylib,CUSTOM_L>"

      # Prints "MYEXE_CUSTOM_C"
      "$<TARGET_PROPERTY:myexe,CUSTOM_C>"

      # Prints "MYEXE_CUSTOM_L;MYLIB_IFACE_CUSTOM_L;EXAMPLE_CUSTOM_L"
      "$<TARGET_PROPERTY:myexe,CUSTOM_L>"
    )

.. _`Compatible Interface Properties`:

兼容的接口属性
-------------------------------

一些目标属性需要在目标和每个依赖项的接口之间兼容。例如，\
:prop_tgt:`POSITION_INDEPENDENT_CODE`\ 目标属性可以指定一个布尔值，表示目标是否应该被\
编译为位置无关的代码，这具有特定于平台的结果。目标还可以指定使用要求\
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`\ 来通知消费者必须被编译为位置无关代码。

.. code-block:: cmake

  add_executable(exe1 exe1.cpp)
  set_property(TARGET exe1 PROPERTY POSITION_INDEPENDENT_CODE ON)

  add_library(lib1 SHARED lib1.cpp)
  set_property(TARGET lib1 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1)

在这里，``exe1``\ 和\ ``exe2``\ 都将被编译为位置无关代码。``lib1``\ 也将被编译为位置无关\
代码，因为这是\ ``SHARED``\ 库的默认设置。如果依赖关系有冲突的、不兼容的要求，\
:manual:`cmake(1)`\ 会发出一个诊断：

.. code-block:: cmake

  add_library(lib1 SHARED lib1.cpp)
  set_property(TARGET lib1 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

  add_library(lib2 SHARED lib2.cpp)
  set_property(TARGET lib2 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE OFF)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1)
  set_property(TARGET exe1 PROPERTY POSITION_INDEPENDENT_CODE OFF)

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1 lib2)

``lib1``\ 要求\ ``INTERFACE_POSITION_INDEPENDENT_CODE``\ 与\ ``exe1``\ 目标的\
:prop_tgt:`POSITION_INDEPENDENT_CODE`\ 属性不“兼容”。库要求将消费者构建为位置无关代码，\
而可执行文件指定不构建为位置无关代码，因此会发出诊断。

``lib1``\ 和\ ``lib2``\ 要求不“兼容”。其中一个要求将消费者构建为与位置无关的代码，而另一\
个并未要求将消费者构建为与位置无关的代码。因为\ ``exe2``\ 链接到两者，并且它们是冲突的，所\
以会发出一个CMake错误消息： ::

  CMake Error: The INTERFACE_POSITION_INDEPENDENT_CODE property of "lib2" does
  not agree with the value of POSITION_INDEPENDENT_CODE already determined
  for "exe2".

为了“兼容”，如果有设置\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ 属性，在布尔意义上，\
必须与设置该属性的所有传递指定依赖项的\ :prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`\
属性相同。

通过在\ :prop_tgt:`COMPATIBLE_INTERFACE_BOOL`\ 目标属性的内容中指定该属性，“兼容接口要\
求”的属性可以扩展到其他属性。每个指定的属性必须在消费目标和对应的属性之间兼容，每个依赖都有一个\
``INTERFACE_``\ 前缀：

.. code-block:: cmake

  add_library(lib1Version2 SHARED lib1_v2.cpp)
  set_property(TARGET lib1Version2 PROPERTY INTERFACE_CUSTOM_PROP ON)
  set_property(TARGET lib1Version2 APPEND PROPERTY
    COMPATIBLE_INTERFACE_BOOL CUSTOM_PROP
  )

  add_library(lib1Version3 SHARED lib1_v3.cpp)
  set_property(TARGET lib1Version3 PROPERTY INTERFACE_CUSTOM_PROP OFF)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1Version2) # CUSTOM_PROP will be ON

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1Version2 lib1Version3) # Diagnostic

非布尔属性也可以参与“兼容接口”计算。在\ :prop_tgt:`COMPATIBLE_INTERFACE_STRING`\ 属性\
中指定的属性必须是未指定的，或者与所有传递指定的依赖项中的相同字符串相比较。这有助于确保库的\
多个不兼容版本不会通过目标的传递要求链接在一起：

.. code-block:: cmake

  add_library(lib1Version2 SHARED lib1_v2.cpp)
  set_property(TARGET lib1Version2 PROPERTY INTERFACE_LIB_VERSION 2)
  set_property(TARGET lib1Version2 APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING LIB_VERSION
  )

  add_library(lib1Version3 SHARED lib1_v3.cpp)
  set_property(TARGET lib1Version3 PROPERTY INTERFACE_LIB_VERSION 3)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1Version2) # LIB_VERSION will be "2"

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1Version2 lib1Version3) # Diagnostic

:prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MAX`\ 目标属性指定内容将被数值计算，并且将计算\
所有指定的最大值：

.. code-block:: cmake

  add_library(lib1Version2 SHARED lib1_v2.cpp)
  set_property(TARGET lib1Version2 PROPERTY INTERFACE_CONTAINER_SIZE_REQUIRED 200)
  set_property(TARGET lib1Version2 APPEND PROPERTY
    COMPATIBLE_INTERFACE_NUMBER_MAX CONTAINER_SIZE_REQUIRED
  )

  add_library(lib1Version3 SHARED lib1_v3.cpp)
  set_property(TARGET lib1Version3 PROPERTY INTERFACE_CONTAINER_SIZE_REQUIRED 1000)

  add_executable(exe1 exe1.cpp)
  # CONTAINER_SIZE_REQUIRED will be "200"
  target_link_libraries(exe1 lib1Version2)

  add_executable(exe2 exe2.cpp)
  # CONTAINER_SIZE_REQUIRED will be "1000"
  target_link_libraries(exe2 lib1Version2 lib1Version3)

类似地，可以使用\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MIN`\ 从依赖项中计算属性的最\
小数值。

每个计算出的“兼容”属性值都可以在生成时使用生成器表达式从消费者中读取。

请注意，对于每个被依赖者，每个兼容接口属性中指定的属性集不能与任何其他属性中指定的属性集相交。

属性起源调试
-------------------------

因为构建规范可以由依赖关系决定，创建目标和负责设置构建规范的代码缺乏本地化可能会使代码更难推\
理。\ :manual:`cmake(1)`\ 提供了一个调试工具，打印属性内容的来源，这可能是由依赖关系决定\
的。可以调试的属性列在\ :variable:`CMAKE_DEBUG_TARGET_PROPERTIES`\ 变量文档中：

.. code-block:: cmake

  set(CMAKE_DEBUG_TARGET_PROPERTIES
    INCLUDE_DIRECTORIES
    COMPILE_DEFINITIONS
    POSITION_INDEPENDENT_CODE
    CONTAINER_SIZE_REQUIRED
    LIB_VERSION
  )
  add_executable(exe1 exe1.cpp)

对于在\ :prop_tgt:`COMPATIBLE_INTERFACE_BOOL`\ 或\
:prop_tgt:`COMPATIBLE_INTERFACE_STRING`\ 中列出的属性，调试输出显示哪个目标负责设置该\
属性，以及哪个其他依赖项也定义了该属性。在\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MAX`\
和\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MIN`\ 的情况下，调试输出显示每个依赖项的属\
性值，以及该值是否决定了新的极值。

使用生成器表达式构建规范
----------------------------------------------

构建规范可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`，其中包含有\
条件的或在生成时才知道的内容。例如，计算出的属性“compatible”值可以通过\
``TARGET_PROPERTY``\ 表达式读取：

.. code-block:: cmake

  add_library(lib1Version2 SHARED lib1_v2.cpp)
  set_property(TARGET lib1Version2 PROPERTY
    INTERFACE_CONTAINER_SIZE_REQUIRED 200)
  set_property(TARGET lib1Version2 APPEND PROPERTY
    COMPATIBLE_INTERFACE_NUMBER_MAX CONTAINER_SIZE_REQUIRED
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1Version2)
  target_compile_definitions(exe1 PRIVATE
      CONTAINER_SIZE=$<TARGET_PROPERTY:CONTAINER_SIZE_REQUIRED>
  )

在本例中，将使用\ ``-DCONTAINER_SIZE=200``\ 编译\ ``exe1``\ 源文件。

一元\ ``TARGET_PROPERTY``\ 生成器表达式和\ ``TARGET_POLICY``\ 生成器表达式是在消费目\
标上下文中计算的。这意味着使用要求规范可以根据使用者的不同进行评估：

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  target_compile_definitions(lib1 INTERFACE
    $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:LIB1_WITH_EXE>
    $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:LIB1_WITH_SHARED_LIB>
    $<$<TARGET_POLICY:CMP0041>:CONSUMER_CMP0041_NEW>
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1)

  cmake_policy(SET CMP0041 NEW)

  add_library(shared_lib shared_lib.cpp)
  target_link_libraries(shared_lib lib1)

``exe1``\ 可执行文件将使用\ ``-DLIB1_WITH_EXE``\ 编译，\
而\ ``shared_lib``\ 共享库将使用\ ``-DLIB1_WITH_SHARED_LIB``\ 和\
``-DCONSUMER_CMP0041_NEW``\ 编译，因为策略\ :policy:`CMP0041`\ 在创建\
``shared_lib``\ 目标的地方是\ ``NEW``。

``BUILD_INTERFACE``\ 表达式包装的需求仅在从同一个构建系统中的目标消费时使用，或者在使用\
:command:`export`\ 命令从导出到构建目录的目标消费时使用。\ ``INSTALL_INTERFACE``\ 表达\
式包装了只在使用\ :command:`install(EXPORT)`\ 命令安装并导出的目标时使用的需求：

.. code-block:: cmake

  add_library(ClimbingStats climbingstats.cpp)
  target_compile_definitions(ClimbingStats INTERFACE
    $<BUILD_INTERFACE:ClimbingStats_FROM_BUILD_LOCATION>
    $<INSTALL_INTERFACE:ClimbingStats_FROM_INSTALLED_LOCATION>
  )
  install(TARGETS ClimbingStats EXPORT libExport ${InstallArgs})
  install(EXPORT libExport NAMESPACE Upstream::
          DESTINATION lib/cmake/ClimbingStats)
  export(EXPORT libExport NAMESPACE Upstream::)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 ClimbingStats)

在这种情况下，\ ``exe1``\ 可执行文件将使用\ ``-DClimbingStats_FROM_BUILD_LOCATION``\
进行编译。导出命令生成\ :prop_tgt:`IMPORTED`\ 目标，其中省略了\ ``INSTALL_INTERFACE``\
或\ ``BUILD_INTERFACE``，去掉了\ ``*_INTERFACE``\ 标记。使用\ ``ClimbingStats``\
包的一个单独项目将包含：

.. code-block:: cmake

  find_package(ClimbingStats REQUIRED)

  add_executable(Downstream main.cpp)
  target_link_libraries(Downstream Upstream::ClimbingStats)

``Downstream``\ 目标将使用\ ``-DClimbingStats_FROM_BUILD_LOCATION``\ 或\
``-DClimbingStats_FROM_INSTALL_LOCATION``\ 编译，这取决于\ ``ClimbingStats``\ 包是\
从构建位置还是安装位置使用的。有关包和导出的更多信息，请参阅\ :manual:`cmake-packages(7)`\
手册。

.. _`Include Directories and Usage Requirements`:

包含目录和使用要求
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

包含目录在作为使用要求指定和与生成器表达式一起使用时需要一些特殊考虑。\
:command:`target_include_directories`\ 命令可以接受相对包含目录和绝对包含目录：

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  target_include_directories(lib1 PRIVATE
    /absolute/path
    relative/path
  )

相对路径是相对于出现命令的源目录进行解释的。:prop_tgt:`IMPORTED`\ 目标的\
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 中不允许有相对路径。

在使用非平凡生成器表达式的情况下，可以在\ ``INSTALL_INTERFACE``\ 表达式的参数中使用\
``INSTALL_PREFIX``\ 表达式。它是一个替换标记，在被消费项目导入时扩展为安装前缀。

包括构建树和安装树之间的目录使用需求通常不同。``BUILD_INTERFACE``\ 和\
``INSTALL_INTERFACE``\ 生成器表达式可用于描述基于使用位置的单独使用需求。\
``INSTALL_INTERFACE``\ 表达式中允许使用相对路径，并且相对于安装前缀进行解释。例如：

.. code-block:: cmake

  add_library(ClimbingStats climbingstats.cpp)
  target_include_directories(ClimbingStats INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/generated>
    $<INSTALL_INTERFACE:/absolute/path>
    $<INSTALL_INTERFACE:relative/path>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/$<CONFIG>/generated>
  )

CMake提供了与包含目录使用需求相关的两个便捷API。\
变量\ :variable:`CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE`\ 可以被启用，其作用相当于：

.. code-block:: cmake

  set_property(TARGET tgt APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR}>
  )

对于每个受影响的目标。对于已安装的目标来说，\
使用\ :command:`install(TARGETS)`\ 命令可以方便地使用\ ``INCLUDES DESTINATION``\ 组件：

.. code-block:: cmake

  install(TARGETS foo bar bat EXPORT tgts ${dest_args}
    INCLUDES DESTINATION include
  )
  install(EXPORT tgts ${other_args})
  install(FILES ${headers} DESTINATION include)

这相当于在由\ :command:`install(EXPORT)`\ 生成的每个已安装的\ :prop_tgt:`IMPORTED`\
目标的\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 中附加\
``${CMAKE_INSTALL_PREFIX}/include``。

当\ :ref:`导入的目标 <Imported targets>`\ 的\
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 被使用时，该属性中的条目可能被视为系统包含\
目录。其影响取决于工具链，但一个常见的影响是忽略在这些目录中找到的头的编译器警告。已安装目标的\
:prop_tgt:`SYSTEM`\ 属性决定了这种行为（有关如何修改目标的已安装值，请参阅\
:prop_tgt:`EXPORT_NO_SYSTEM`\ 属性）。还可以通过在\ *使用者*\ 上设置\
:prop_tgt:`NO_SYSTEM_FROM_IMPORTED`\ 目标属性来更改使用者如何解释所使用的导入目标的系统\
行为。

如果一个二进制目标被传递地链接到一个macOS :prop_tgt:`FRAMEWORK`，框架的\ ``Headers``\
目录也被视为使用需求。这与将框架目录作为包含目录传递的效果相同。

链接库和生成器表达式
----------------------------------------

与构建规范一样，可以使用生成器表达式条件指定\ :prop_tgt:`链接库 <LINK_LIBRARIES>`。\
然而，由于使用需求的消耗是基于链接依赖项的集合，因此有一个额外的限制，即链接依赖项必须形成一个\
“有向无环图”。也就是说，如果链接到目标依赖于目标属性的值，那么目标属性可能不依赖于链接的依赖项：

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  add_library(lib2 lib2.cpp)
  target_link_libraries(lib1 PUBLIC
    $<$<TARGET_PROPERTY:POSITION_INDEPENDENT_CODE>:lib2>
  )
  add_library(lib3 lib3.cpp)
  set_property(TARGET lib3 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1 lib3)

由于\ ``exe1``\ 目标的\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ 属性的值依赖于链接的库\
（\ ``lib3``\ ），而链接\ ``exe1``\ 的边缘由同一个\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\
属性决定，因此上述依赖图包含一个循环。:manual:`cmake(1)`\ 发出错误消息。

.. _`Output Artifacts`:

输出构件
----------------

:command:`add_library`\ 和\ :command:`add_executable`\ 命令创建的构建系统目标创建规\
则来创建二进制输出。二进制文件的准确输出位置只能在生成时确定，因为它依赖于构建配置和链接依赖\
的链接语言等。\ ``TARGET_FILE``、\ ``TARGET_LINKER_FILE``\ 和相关的表达式可以用来访问\
生成的二进制文件的名称和位置。然而，这些表达式不适用于\ ``OBJECT``\ 库，因为这些库没有生成\
与表达式相关的单个文件。

目标可以构建三种输出工件，具体内容将在下面的部分中详细介绍。它们的分类在DLL平台和非DLL平台之\
间是不同的。包括Cygwin在内的所有基于windows的系统都是DLL平台。

.. _`Runtime Output Artifacts`:

运行时输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

构建系统目标的\ *运行时*\ 输出工件可能是：

* :command:`add_executable`\ 命令创建的可执行目标的可执行文件（例如\ ``.exe``）。

* 在DLL平台上：由\ :command:`add_library`\ 命令和\ ``SHARED``\ 选项创建的共享库目标的\
  可执行文件（例如\ ``.dll``）。

:prop_tgt:`RUNTIME_OUTPUT_DIRECTORY`\ 和\ :prop_tgt:`RUNTIME_OUTPUT_NAME`\
目标属性可以用于控制构建树中的运行时输出工件位置和名称。

.. _`Library Output Artifacts`:

库输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

构建系统目标的\ *库*\ 输出工件可能是：

* 由\ :command:`add_library`\ 命令使用\ ``MODULE``\ 选项创建的模块库目标的可加载模块文件\
  （例如\ ``.dll``\ 或\ ``.so``）。

* 在非DLL平台上：由\ :command:`add_library`\ 命令和\ ``SHARED``\ 选项创建的共享库目标\
  的共享库文件（例如\ ``.so``\ 或\ ``.dylib``）。

:prop_tgt:`LIBRARY_OUTPUT_DIRECTORY`\ 和\ :prop_tgt:`LIBRARY_OUTPUT_NAME`\
目标属性可以用来控制构建树中的库输出工件位置和名称。

.. _`Archive Output Artifacts`:

档案输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

构建系统目标的\ *归档*\ 输出工件可能是：

* 由\ :command:`add_library`\ 命令使用\ ``STATIC``\ 选项创建的静态库目标的静态库文件\
  （例如\ ``.lib``\ 或\ ``.a``）。

* 在DLL平台上：由\ :command:`add_library`\ 命令和\ ``SHARED``\ 选项创建的共享库目标的\
  导入库文件（例如\ ``.lib``）。只有当库导出至少一个非托管符号时，才保证此文件存在。

* 在DLL平台上：当设置了可执行目标的\ :prop_tgt:`ENABLE_EXPORTS`\ 目标属性时，\
  由\ :command:`add_executable`\ 命令创建的可执行目标的导入库文件（例如\ ``.lib``）。

* 在AIX上：当设置了可执行目标的\ :prop_tgt:`ENABLE_EXPORTS`\ 目标属性时，\
  :command:`add_executable`\ 命令创建的可执行目标的链接器导入文件（例如\ ``.imp``）。

* 在macOS上：共享库目标的链接器导入文件（例如\ ``.tbd``）由\ :command:`add_library`\
  命令创建，带有\ ``SHARED``\ 选项，当它的\ :prop_tgt:`ENABLE_EXPORTS`\ 目标属性被设\
  置时。

:prop_tgt:`ARCHIVE_OUTPUT_DIRECTORY`\ 和\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\
目标属性可以用于控制构建树中的归档输出工件位置和名称。

目录作用域命令
-------------------------

:command:`target_include_directories`、:command:`target_compile_definitions`\ 和\
:command:`target_compile_options`\ 命令一次只能对一个目标产生影响。\
:command:`add_compile_definitions`、:command:`add_compile_options`\ 和\
:command:`include_directories`\ 命令具有类似的功能，但为了方便起见，它们在目录范围而不是\
目标范围内操作。

.. _`Build Configurations`:

构建配置
====================

配置为特定类型的构建确定规范，例如\ ``Release``\ 或\ ``Debug``。\
指定方法取决于所使用的\ :manual:`generator <cmake-generators(7)>`\ 的类型。\
对于单个配置生成器，如\ :ref:`Makefile Generators`\ 和\ :generator:`Ninja`，\
配置是在配置时由\ :variable:`CMAKE_BUILD_TYPE`\ 变量指定的。\
对于像\ :ref:`Visual Studio <Visual Studio Generators>`、:generator:`Xcode`\ 和\
:generator:`Ninja Multi-Config`\ 这样的多配置生成器，配置是由用户在构建时选择的，\
:variable:`CMAKE_BUILD_TYPE`\ 会被忽略。在多配置情况下，\
*可用*\ 配置集在配置时由\ :variable:`CMAKE_CONFIGURATION_TYPES`\ 变量指定，\
但使用的实际配置直到构建阶段才能知道。这种差异经常被误解，导致出现如下问题代码：

.. code-block:: cmake

  # WARNING: This is wrong for multi-config generators because they don't use
  #          and typically don't even set CMAKE_BUILD_TYPE
  string(TOLOWER ${CMAKE_BUILD_TYPE} build_type)
  if (build_type STREQUAL debug)
    target_compile_definitions(exe1 PRIVATE DEBUG_BUILD)
  endif()

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 应该用于正确处理特定于配置的逻辑，\
而不管使用的生成器是什么。例如：

.. code-block:: cmake

  # Works correctly for both single and multi-config generators
  target_compile_definitions(exe1 PRIVATE
    $<$<CONFIG:Debug>:DEBUG_BUILD>
  )

在\ :prop_tgt:`IMPORTED`\ 目标存在的情况下，\
:prop_tgt:`MAP_IMPORTED_CONFIG_DEBUG <MAP_IMPORTED_CONFIG_<CONFIG>>`\ 的内容也由\
上面的\ :genex:`$<CONFIG:Debug>`\ 表达式负责。


区分大小写
----------------

:variable:`CMAKE_BUILD_TYPE`\ 和\ :variable:`CMAKE_CONFIGURATION_TYPES`\ 就像其他\
变量一样，与它们的值进行的任何字符串比较都是区分大小写的。:genex:`$<CONFIG>`\ 生成器表达式\
还保留由用户或CMake默认设置的配置大小写。例如：

.. code-block:: cmake

  # NOTE: Don't use these patterns, they are for illustration purposes only.

  set(CMAKE_BUILD_TYPE Debug)
  if(CMAKE_BUILD_TYPE STREQUAL DEBUG)
    # ... will never get here, "Debug" != "DEBUG"
  endif()
  add_custom_target(print_config ALL
    # Prints "Config is Debug" in this single-config case
    COMMAND ${CMAKE_COMMAND} -E echo "Config is $<CONFIG>"
    VERBATIM
  )

  set(CMAKE_CONFIGURATION_TYPES Debug Release)
  if(DEBUG IN_LIST CMAKE_CONFIGURATION_TYPES)
    # ... will never get here, "Debug" != "DEBUG"
  endif()

相比之下，CMake在内部根据配置修改行为的地方使用配置类型时不区分大小写。例如，\
:genex:`$<CONFIG:Debug>`\ 生成器表达式对于不仅是\ ``Debug``，而且是\ ``DEBUG``、\
``debug``\ 甚至\ ``DeBuG``\ 的配置都将计算为1。因此，您可以在\
:variable:`CMAKE_BUILD_TYPE`\ 和\ :variable:`CMAKE_CONFIGURATION_TYPES`\ 中指定任\
意大小写混合的配置类型，尽管有严格的约定（请参阅下一节）。如果你必须在字符串比较中测试值，\
那么首先将值转换为大写或小写，然后再相应地调整测试。

默认和自定义配置
---------------------------------

默认情况下，CMake定义了许多标准配置：

* ``Debug``
* ``Release``
* ``RelWithDebInfo``
* ``MinSizeRel``

在多配置生成器中，默认情况下\ :variable:`CMAKE_CONFIGURATION_TYPES`\ 变量将使用上述列表\
（可能是其中的一个子集）填充，除非被项目或用户覆盖。使用的实际配置由用户在构建时选择。

对于单配置生成器，配置在配置时使用\ :variable:`CMAKE_BUILD_TYPE`\ 变量指定，不能在构建时\
更改。默认值通常不是上述标准配置，而是一个空字符串。一个常见的误解是，这与\ ``Debug``\ 相同，\
但事实并非如此。用户应该始终显式地指定构建类型，以避免此常见问题。

上述标准配置类型在大多数平台上提供了合理的行为，但它们可以被扩展为提供其他类型。每个配置都为\
所使用的语言定义了一组编译器和链接器标志变量。这些变量遵循惯例\
:variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`，其中\ ``<CONFIG>``\ 总是大写的配置名称。\
在定义自定义配置类型时，确保适当地设置了这些变量，通常是缓存变量。


伪目标
==============

有些目标类型不表示构建系统的输出，而只表示输入，如外部依赖项、别名或其他非构建构件。生成的构\
建系统中不表示伪目标。

.. _`Imported Targets`:

导入的目标
----------------

:prop_tgt:`IMPORTED`\ 目标表示预先存在的依赖项。通常这样的由上游包定义的目标，应该被视为\
不可变的。在声明了一个\ :prop_tgt:`IMPORTED`\ 目标之后，我们可以像使用其他常规目标一样，\
使用习惯命令\ :command:`target_compile_definitions`、\
:command:`target_include_directories`、\ :command:`target_compile_options`\ 或\
:command:`target_link_libraries`\ 来调整\
它的目标属性。

:prop_tgt:`IMPORTED`\ 的目标可能有与二进制目标相同的使用需求属性，例如\
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`、\
:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`、\
:prop_tgt:`INTERFACE_COMPILE_OPTIONS`、\
:prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 和\
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`。

:prop_tgt:`LOCATION`\ 也可以从IMPORTED目标读取，尽管这样做的理由很少。\
:command:`add_custom_command`\ 等命令可以透明地使用\
:prop_tgt:`IMPORTED` :prop_tgt:`EXECUTABLE <TYPE>`\ 目标作为\ ``COMMAND``\ 可执行\
文件。

:prop_tgt:`IMPORTED`\ 目标定义的范围是定义它的目录。可以从子目录访问和使用它，但不能从父\
目录或同级目录访问。作用域类似于cmake变量的作用域。

还可以定义一个在构建系统中全局访问的\ ``GLOBAL`` :prop_tgt:`IMPORTED`\ 目标。

请参阅\ :manual:`cmake-packages(7)`\ 手册了解更多关于使用\ :prop_tgt:`IMPORTED`\ 目\
标创建包的信息。

.. _`Alias Targets`:

别名目标
-------------

``ALIAS``\ 目标是在只读上下文中可以与二进制目标名称互换使用的名称。\
``ALIAS``\ 目标的一个主要用例是伴随一个库的单元测试可执行文件，它可能是相同构建系统的一部分，\
也可能是基于用户配置单独构建的。

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  install(TARGETS lib1 EXPORT lib1Export ${dest_args})
  install(EXPORT lib1Export NAMESPACE Upstream:: ${other_args})

  add_library(Upstream::lib1 ALIAS lib1)

在另一个目录中，我们可以无条件地链接到\ ``Upstream::lib1``\ 目标，它可以是来自包的\
:prop_tgt:`IMPORTED`\ 目标，或者是作为相同构建系统的一部分构建的\ ``ALIAS``\ 目标。

.. code-block:: cmake

  if (NOT TARGET Upstream::lib1)
    find_package(lib1 REQUIRED)
  endif()
  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 Upstream::lib1)

``ALIAS``\ 目标是不可变的、不可安装的或不可导出的。它们完全局限于构建系统描述。一个名称可以\
通过读取它的\ :prop_tgt:`ALIASED_TARGET`\ 属性来测试它是否是一个\ ``ALIAS``\ 名称：

.. code-block:: cmake

  get_target_property(_aliased Upstream::lib1 ALIASED_TARGET)
  if(_aliased)
    message(STATUS "The name Upstream::lib1 is an ALIAS for ${_aliased}.")
  endif()

.. _`Interface Libraries`:

接口库
-------------------

``INTERFACE``\ 库目标不会编译源代码，也不会在磁盘上生成库工件，因此它没有\ :prop_tgt:`LOCATION`。

它可以指定使用要求，如\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`、\
:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`、:prop_tgt:`INTERFACE_COMPILE_OPTIONS`、\
:prop_tgt:`INTERFACE_LINK_LIBRARIES`、:prop_tgt:`INTERFACE_SOURCES`\ 和\
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`。只有\
:command:`target_include_directories`、:command:`target_compile_definitions`、\
:command:`target_compile_options`、:command:`target_sources`\ 和\
:command:`target_link_libraries`\ 命令的\ ``INTERFACE``\ 模式可以与\ ``INTERFACE``\
库一起使用。

自CMake 3.19起，一个\ ``INTERFACE``\ 库目标可以有选择地包含源文件。包含源文件的接口库将\
作为构建目标包含在生成的构建系统中。它不编译源代码，但可能包含用于生成其他源代码的自定义命令。\
此外，IDE将把源文件作为目标的一部分显示，以便进行交互式读取和编辑。

``INTERFACE``\ 库的一个主要用例是仅有头文件（header-only）的库。CMake 3.23起，\
可以通过使用\ :command:`target_sources`\ 命令将头文件添加到头文件集来将头文件和库关联：

.. code-block:: cmake

  add_library(Eigen INTERFACE)

  target_sources(Eigen PUBLIC
    FILE_SET HEADERS
      BASE_DIRS src
      FILES src/eigen.h src/vector.h src/matrix.h
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 Eigen)

当我们在这里指定\ ``FILE_SET``\ 时，我们定义的\ ``BASE_DIRS``\ 自动成为\ ``Eigen``\
目标使用要求中的包含目录。来自此目标的使用需求在编译时被消耗和使用，但它对链接没有影响。

另一个用例是对使用需求采用完全以目标为中心的设计：

.. code-block:: cmake

  add_library(pic_on INTERFACE)
  set_property(TARGET pic_on PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)
  add_library(pic_off INTERFACE)
  set_property(TARGET pic_off PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE OFF)

  add_library(enable_rtti INTERFACE)
  target_compile_options(enable_rtti INTERFACE
    $<$<OR:$<COMPILER_ID:GNU>,$<COMPILER_ID:Clang>>:-rtti>
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 pic_on enable_rtti)

这样，``exe1``\ 的构建规范就完全表示为链接的目标，而编译器特定标志的复杂性被封装在\
``INTERFACE``\ 库目标中。

可以安装和导出\ ``INTERFACE``\ 库。我们可以随着目标安装默认的头文件集：

.. code-block:: cmake

  add_library(Eigen INTERFACE)

  target_sources(Eigen INTERFACE
    FILE_SET HEADERS
      BASE_DIRS src
      FILES src/eigen.h src/vector.h src/matrix.h
  )

  install(TARGETS Eigen EXPORT eigenExport
    FILE_SET HEADERS DESTINATION include/Eigen)
  install(EXPORT eigenExport NAMESPACE Upstream::
    DESTINATION lib/cmake/Eigen
  )

在这里，定义在头文件集中的头文件被安装在\ ``include/Eigen``。安装目标自动成为用户使用要求\
的包含目录。
