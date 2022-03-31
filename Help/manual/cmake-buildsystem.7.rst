.. cmake-manual-description: CMake Buildsystem Reference

cmake-buildsystem(7)
********************

.. only:: html

   .. contents::

引言
============

基于CMake的构建系统被组织为一组高级逻辑目标。每个目标对应于一个可执行文件或库，或者是包含自定义命令的自定义目标。目标之间的依赖关系在构建系统中表示，以确定构建顺序和响应更改的重新生成规则。

二进制目标
==============

可执行文件和库使用\ :command:`add_executable`\ 和\ :command:`add_library`\ 命令定义。生成的二进制文件具有针对平台的适当\ :prop_tgt:`PREFIX`、:prop_tgt:`SUFFIX`\ 和扩展名。二进制目标之间的依赖关系使用\ :command:`target_link_libraries`\ 命令表示：

.. code-block:: cmake

  add_library(archive archive.cpp zip.cpp lzma.cpp)
  add_executable(zipapp zipapp.cpp)
  target_link_libraries(zipapp archive)

``archive``\ 被定义为一个\ ``STATIC``\ 库——一个包含\ ``archive.cpp``、``zip.cpp``\ 和\ ``lzma.cpp``\ 编译对象的存档。``zipapp``\ 被定义为通过编译和链接\ ``zipapp.cpp``\ 而形成的可执行文件。当链接\ ``zipapp``\ 可执行文件时，``archive``\ 静态库会被链接到。

二进制可执行文件
------------------

:command:`add_executable`\ 命令定义了一个可执行目标：

.. code-block:: cmake

  add_executable(mytool mytool.cpp)

像\ :command:`add_custom_command`\ 这样的命令，它生成要在构建时运行的规则，可以透明地将\ :prop_tgt:`EXECUTABLE <TYPE>`\ 目标作为可执行\ ``COMMAND``\ 文件使用。构建系统规则将确保在尝试运行命令之前构建可执行文件。

二进制库类型
--------------------

.. _`Normal Libraries`:

普通库
^^^^^^^^^^^^^^^^

默认情况下，:command:`add_library`\ 命令定义了一个\ ``STATIC``\ 库，除非指定了类型。使用这个命令时，可以指定一个类型：

.. code-block:: cmake

  add_library(archive SHARED archive.cpp zip.cpp lzma.cpp)

.. code-block:: cmake

  add_library(archive STATIC archive.cpp zip.cpp lzma.cpp)

可以启用\ :variable:`BUILD_SHARED_LIBS`\ 变量来改变\ :command:`add_library`\ 的行为，默认情况下构建共享库。

在整个构建系统定义的上下语境中，特定的库是\ ``SHARED``\ 还是\ ``STATIC``\ 在很大程度上是无关紧要的——不管库的类型如何，命令、依赖规范和其他API的工作方式都是类似的。``MODULE``\ 库类型的不同之处在于，它通常不会被链接到——它不会在\ :command:`target_link_libraries`\ 命令的右侧被使用。它是一个使用运行时技术作为插件加载的类型。如果库不导出任何非托管符号（例如Windows资源DLL, C++/CLI DLL），则要求库不是\ ``SHARED``\ 库，因为CMake希望\ ``SHARED``\ 库至少导出一个符号。

.. code-block:: cmake

  add_library(archive MODULE 7z.cpp)

.. _`Apple Frameworks`:

苹果框架
""""""""""""""""

一个\ ``SHARED``\ 库可以被标记为\ :prop_tgt:`FRAMEWORK`\ 目标属性来创建一个macOS或iOS框架Bundle。带有\ ``FRAMEWORK``\ 目标属性的库还应该设置\ :prop_tgt:`FRAMEWORK_VERSION`\ 目标属性。根据macOS约定，该属性通常设置为“A”。``MACOSX_FRAMEWORK_IDENTIFIER``\ 设置为\ ``CFBundleIdentifier``\ 键，它用作bundle的唯一标识。

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

``OBJECT``\ 库类型定义了由编译给定源文件产生的目标文件的非归档集合。通过使用语法\ ``$<TARGET_OBJECTS:name>``，对象文件集合可以用作其他目标的源输入。这是一个\ :manual:`generator expression <cmake-generator-expressions(7)>`，可以用来向其他目标提供\ ``OBJECT``\ 库内容：

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

其他目标的链接（或归档）步骤将\ *直接*\ 链接的\ ``OBJECT``\ 库中的对象文件。此外，当在其他目标中编译源代码时，``OBJECT``\ 库的使用需求将得到满足。此外，这些使用需求将传递到那些其他目标的依赖项。

在使用\ :command:`add_custom_command(TARGET)`\ 命令签名时，对象库不能用作\ ``TARGET``。但是，对象列表可以通过\ :command:`add_custom_command(OUTPUT)`\ 或\ :command:`file(GENERATE)`\ 使用\ ``$<TARGET_OBJECTS:objlib>``。

构建规范和使用要求
==========================================

:command:`target_include_directories`、:command:`target_compile_definitions`\ 和\ :command:`target_compile_options`\ 命令指定二进制目标的构建规范和使用要求。这些命令分别填充了\ :prop_tgt:`INCLUDE_DIRECTORIES`、:prop_tgt:`COMPILE_DEFINITIONS`\ 和\ :prop_tgt:`COMPILE_OPTIONS`\ 目标属性，可能还有\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`、:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`\ 和\ :prop_tgt:`INTERFACE_COMPILE_OPTIONS`\ 目标属性。

每个命令都有\ ``PRIVATE``、``PUBLIC``\ 和\ ``INTERFACE``\ 模式。``PRIVATE``\ 模式只填充目标属性的非\ ``INTERFACE_``\ 变量，``INTERFACE``\ 模式只填充\ ``INTERFACE_``\ 变量。``PUBLIC``\ 模式填充各自目标属性的各个变量。每个命令一次可以调用多个关键字：

.. code-block:: cmake

  target_compile_definitions(archive
    PRIVATE BUILDING_WITH_LZMA
    INTERFACE USING_ARCHIVE_LIB
  )

注意，使用要求并不是为了方便而让下游使用特定的\ :prop_tgt:`COMPILE_OPTIONS`\ 或\ :prop_tgt:`COMPILE_OPTIONS`\ 等。属性的内容必须是\ **要求**，而不仅仅是建议或方便。

请参阅\ :manual:`cmake-packages(7)`\ 手册的\ :ref:`Creating Relocatable Packages`\ 一节，讨论在为重新分发创建包时指定使用要求时必须注意的其他事项。

目标属性
-----------------

在编译二进制目标的源文件时，:prop_tgt:`INCLUDE_DIRECTORIES`、:prop_tgt:`COMPILE_DEFINITIONS`\ 和\ :prop_tgt:`COMPILE_OPTIONS`\ 目标属性的内容会被适当地使用。

:prop_tgt:`INCLUDE_DIRECTORIES`\ 中的条目用\ ``-I``\ 或\ ``-isystem``\ 前缀按照属性值出现的顺序添加到编译行。

:prop_tgt:`COMPILE_DEFINITIONS`\ 中的条目以\ ``-D``\ 或\ ``/D``\ 作为前缀，并以未指定的顺序添加到编译行中。:prop_tgt:`DEFINE_SYMBOL`\ 目标属性也被添加为一个编译定义，作为\ ``SHARED``\ 库和 ``MODULE``\ 库目标的便捷特例。

:prop_tgt:`COMPILE_OPTIONS`\ 中的条目被转义为shell，并按照属性值中出现的顺序添加。一些编译选项有特殊的独立处理，如\ :prop_tgt:`POSITION_INDEPENDENT_CODE`。

:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`、:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`\ 和\ :prop_tgt:`INTERFACE_COMPILE_OPTIONS`\ 目标属性的内容是\ *使用要求*\ ——它们指定消费者必须使用哪些内容来正确编译和链接它们所出现的目标。对于任何二进制目标，在\ :command:`target_link_libraries`\ 命令中指定的每个目标上的每个\ ``INTERFACE_``\ 属性的内容都会被消耗：

.. code-block:: cmake

  set(srcs archive.cpp zip.cpp)
  if (LZMA_FOUND)
    list(APPEND srcs lzma.cpp)
  endif()
  add_library(archive SHARED ${srcs})
  if (LZMA_FOUND)
    # The archive library sources are compiled with -DBUILDING_WITH_LZMA
    target_compile_definitions(archive PRIVATE BUILDING_WITH_LZMA)
  endif()
  target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

  add_executable(consumer)
  # Link consumer to archive and consume its usage requirements. The consumer
  # executable sources are compiled with -DUSING_ARCHIVE_LIB.
  target_link_libraries(consumer archive)

因为通常需要将源目录和相应的构建目录添加到\ :prop_tgt:`INCLUDE_DIRECTORIES`\ 中，所以可以启用\ :variable:`CMAKE_INCLUDE_CURRENT_DIR`\ 变量，方便地将相应的目录添加到所有目标的\ :prop_tgt:`INCLUDE_DIRECTORIES`\ 中。可以启用 \ :variable:`CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE`\ 变量，将相应的目录添加到所有目标的\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 中。通过使用\ :command:`target_link_libraries`\ 命令，可以方便地使用多个不同目录中的目标。


.. _`Target Usage Requirements`:

传递使用要求
-----------------------------

The usage requirements of a target can transitively propagate to dependents.
The :command:`target_link_libraries` command has ``PRIVATE``,
``INTERFACE`` and ``PUBLIC`` keywords to control the propagation.

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

Because ``archive`` is a ``PUBLIC`` dependency of ``archiveExtras``, the
usage requirements of it are propagated to ``consumer`` too.  Because
``serialization`` is a ``PRIVATE`` dependency of ``archiveExtras``, the usage
requirements of it are not propagated to ``consumer``.

Generally, a dependency should be specified in a use of
:command:`target_link_libraries` with the ``PRIVATE`` keyword if it is used by
only the implementation of a library, and not in the header files.  If a
dependency is additionally used in the header files of a library (e.g. for
class inheritance), then it should be specified as a ``PUBLIC`` dependency.
A dependency which is not used by the implementation of a library, but only by
its headers should be specified as an ``INTERFACE`` dependency.  The
:command:`target_link_libraries` command may be invoked with multiple uses of
each keyword:

.. code-block:: cmake

  target_link_libraries(archiveExtras
    PUBLIC archive
    PRIVATE serialization
  )

Usage requirements are propagated by reading the ``INTERFACE_`` variants
of target properties from dependencies and appending the values to the
non-``INTERFACE_`` variants of the operand.  For example, the
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` of dependencies is read and
appended to the :prop_tgt:`INCLUDE_DIRECTORIES` of the operand.  In cases
where order is relevant and maintained, and the order resulting from the
:command:`target_link_libraries` calls does not allow correct compilation,
use of an appropriate command to set the property directly may update the
order.

For example, if the linked libraries for a target must be specified
in the order ``lib1`` ``lib2`` ``lib3`` , but the include directories must
be specified in the order ``lib3`` ``lib1`` ``lib2``:

.. code-block:: cmake

  target_link_libraries(myExe lib1 lib2 lib3)
  target_include_directories(myExe
    PRIVATE $<TARGET_PROPERTY:lib3,INTERFACE_INCLUDE_DIRECTORIES>)

Note that care must be taken when specifying usage requirements for targets
which will be exported for installation using the :command:`install(EXPORT)`
command.  See :ref:`Creating Packages` for more.

.. _`Compatible Interface Properties`:

兼容的接口属性
-------------------------------

Some target properties are required to be compatible between a target and
the interface of each dependency.  For example, the
:prop_tgt:`POSITION_INDEPENDENT_CODE` target property may specify a
boolean value of whether a target should be compiled as
position-independent-code, which has platform-specific consequences.
A target may also specify the usage requirement
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE` to communicate that
consumers must be compiled as position-independent-code.

.. code-block:: cmake

  add_executable(exe1 exe1.cpp)
  set_property(TARGET exe1 PROPERTY POSITION_INDEPENDENT_CODE ON)

  add_library(lib1 SHARED lib1.cpp)
  set_property(TARGET lib1 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1)

Here, both ``exe1`` and ``exe2`` will be compiled as position-independent-code.
``lib1`` will also be compiled as position-independent-code because that is the
default setting for ``SHARED`` libraries.  If dependencies have conflicting,
non-compatible requirements :manual:`cmake(1)` issues a diagnostic:

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

The ``lib1`` requirement ``INTERFACE_POSITION_INDEPENDENT_CODE`` is not
"compatible" with the :prop_tgt:`POSITION_INDEPENDENT_CODE` property of
the ``exe1`` target.  The library requires that consumers are built as
position-independent-code, while the executable specifies to not built as
position-independent-code, so a diagnostic is issued.

The ``lib1`` and ``lib2`` requirements are not "compatible".  One of them
requires that consumers are built as position-independent-code, while
the other requires that consumers are not built as position-independent-code.
Because ``exe2`` links to both and they are in conflict, a CMake error message
is issued::

  CMake Error: The INTERFACE_POSITION_INDEPENDENT_CODE property of "lib2" does
  not agree with the value of POSITION_INDEPENDENT_CODE already determined
  for "exe2".

To be "compatible", the :prop_tgt:`POSITION_INDEPENDENT_CODE` property,
if set must be either the same, in a boolean sense, as the
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE` property of all transitively
specified dependencies on which that property is set.

This property of "compatible interface requirement" may be extended to other
properties by specifying the property in the content of the
:prop_tgt:`COMPATIBLE_INTERFACE_BOOL` target property.  Each specified property
must be compatible between the consuming target and the corresponding property
with an ``INTERFACE_`` prefix from each dependency:

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

Non-boolean properties may also participate in "compatible interface"
computations.  Properties specified in the
:prop_tgt:`COMPATIBLE_INTERFACE_STRING`
property must be either unspecified or compare to the same string among
all transitively specified dependencies. This can be useful to ensure
that multiple incompatible versions of a library are not linked together
through transitive requirements of a target:

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

The :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MAX` target property specifies
that content will be evaluated numerically and the maximum number among all
specified will be calculated:

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

Similarly, the :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MIN` may be used to
calculate the numeric minimum value for a property from dependencies.

Each calculated "compatible" property value may be read in the consumer at
generate-time using generator expressions.

Note that for each dependee, the set of properties specified in each
compatible interface property must not intersect with the set specified in
any of the other properties.

属性起源调试
-------------------------

Because build specifications can be determined by dependencies, the lack of
locality of code which creates a target and code which is responsible for
setting build specifications may make the code more difficult to reason about.
:manual:`cmake(1)` provides a debugging facility to print the origin of the
contents of properties which may be determined by dependencies.  The properties
which can be debugged are listed in the
:variable:`CMAKE_DEBUG_TARGET_PROPERTIES` variable documentation:

.. code-block:: cmake

  set(CMAKE_DEBUG_TARGET_PROPERTIES
    INCLUDE_DIRECTORIES
    COMPILE_DEFINITIONS
    POSITION_INDEPENDENT_CODE
    CONTAINER_SIZE_REQUIRED
    LIB_VERSION
  )
  add_executable(exe1 exe1.cpp)

In the case of properties listed in :prop_tgt:`COMPATIBLE_INTERFACE_BOOL` or
:prop_tgt:`COMPATIBLE_INTERFACE_STRING`, the debug output shows which target
was responsible for setting the property, and which other dependencies also
defined the property.  In the case of
:prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MAX` and
:prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MIN`, the debug output shows the
value of the property from each dependency, and whether the value determines
the new extreme.

使用生成器表达式构建规范
----------------------------------------------

Build specifications may use
:manual:`generator expressions <cmake-generator-expressions(7)>` containing
content which may be conditional or known only at generate-time.  For example,
the calculated "compatible" value of a property may be read with the
``TARGET_PROPERTY`` expression:

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

In this case, the ``exe1`` source files will be compiled with
``-DCONTAINER_SIZE=200``.

The unary ``TARGET_PROPERTY`` generator expression and the ``TARGET_POLICY``
generator expression are evaluated with the consuming target context.  This
means that a usage requirement specification may be evaluated differently based
on the consumer:

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

The ``exe1`` executable will be compiled with ``-DLIB1_WITH_EXE``, while the
``shared_lib`` shared library will be compiled with ``-DLIB1_WITH_SHARED_LIB``
and ``-DCONSUMER_CMP0041_NEW``, because policy :policy:`CMP0041` is
``NEW`` at the point where the ``shared_lib`` target is created.

The ``BUILD_INTERFACE`` expression wraps requirements which are only used when
consumed from a target in the same buildsystem, or when consumed from a target
exported to the build directory using the :command:`export` command.  The
``INSTALL_INTERFACE`` expression wraps requirements which are only used when
consumed from a target which has been installed and exported with the
:command:`install(EXPORT)` command:

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

In this case, the ``exe1`` executable will be compiled with
``-DClimbingStats_FROM_BUILD_LOCATION``.  The exporting commands generate
:prop_tgt:`IMPORTED` targets with either the ``INSTALL_INTERFACE`` or the
``BUILD_INTERFACE`` omitted, and the ``*_INTERFACE`` marker stripped away.
A separate project consuming the ``ClimbingStats`` package would contain:

.. code-block:: cmake

  find_package(ClimbingStats REQUIRED)

  add_executable(Downstream main.cpp)
  target_link_libraries(Downstream Upstream::ClimbingStats)

Depending on whether the ``ClimbingStats`` package was used from the build
location or the install location, the ``Downstream`` target would be compiled
with either ``-DClimbingStats_FROM_BUILD_LOCATION`` or
``-DClimbingStats_FROM_INSTALL_LOCATION``.  For more about packages and
exporting see the :manual:`cmake-packages(7)` manual.

.. _`Include Directories and Usage Requirements`:

包含目录和使用要求
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Include directories require some special consideration when specified as usage
requirements and when used with generator expressions.  The
:command:`target_include_directories` command accepts both relative and
absolute include directories:

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  target_include_directories(lib1 PRIVATE
    /absolute/path
    relative/path
  )

Relative paths are interpreted relative to the source directory where the
command appears.  Relative paths are not allowed in the
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` of :prop_tgt:`IMPORTED` targets.

In cases where a non-trivial generator expression is used, the
``INSTALL_PREFIX`` expression may be used within the argument of an
``INSTALL_INTERFACE`` expression.  It is a replacement marker which
expands to the installation prefix when imported by a consuming project.

Include directories usage requirements commonly differ between the build-tree
and the install-tree.  The ``BUILD_INTERFACE`` and ``INSTALL_INTERFACE``
generator expressions can be used to describe separate usage requirements
based on the usage location.  Relative paths are allowed within the
``INSTALL_INTERFACE`` expression and are interpreted relative to the
installation prefix.  For example:

.. code-block:: cmake

  add_library(ClimbingStats climbingstats.cpp)
  target_include_directories(ClimbingStats INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/generated>
    $<INSTALL_INTERFACE:/absolute/path>
    $<INSTALL_INTERFACE:relative/path>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/$<CONFIG>/generated>
  )

Two convenience APIs are provided relating to include directories usage
requirements.  The :variable:`CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE` variable
may be enabled, with an equivalent effect to:

.. code-block:: cmake

  set_property(TARGET tgt APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR}>
  )

for each target affected.  The convenience for installed targets is
an ``INCLUDES DESTINATION`` component with the :command:`install(TARGETS)`
command:

.. code-block:: cmake

  install(TARGETS foo bar bat EXPORT tgts ${dest_args}
    INCLUDES DESTINATION include
  )
  install(EXPORT tgts ${other_args})
  install(FILES ${headers} DESTINATION include)

This is equivalent to appending ``${CMAKE_INSTALL_PREFIX}/include`` to the
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` of each of the installed
:prop_tgt:`IMPORTED` targets when generated by :command:`install(EXPORT)`.

When the :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` of an
:ref:`imported target <Imported targets>` is consumed, the entries in the
property are treated as ``SYSTEM`` include directories, as if they were
listed in the :prop_tgt:`INTERFACE_SYSTEM_INCLUDE_DIRECTORIES` of the
dependency. This can result in omission of compiler warnings for headers
found in those directories.  This behavior for :ref:`imported targets` may
be controlled by setting the :prop_tgt:`NO_SYSTEM_FROM_IMPORTED` target
property on the *consumers* of imported targets, or by setting the
:prop_tgt:`IMPORTED_NO_SYSTEM` target property on the imported targets
themselves.

If a binary target is linked transitively to a macOS :prop_tgt:`FRAMEWORK`, the
``Headers`` directory of the framework is also treated as a usage requirement.
This has the same effect as passing the framework directory as an include
directory.

链接库和生成器表达式
----------------------------------------

Like build specifications, :prop_tgt:`link libraries <LINK_LIBRARIES>` may be
specified with generator expression conditions.  However, as consumption of
usage requirements is based on collection from linked dependencies, there is
an additional limitation that the link dependencies must form a "directed
acyclic graph".  That is, if linking to a target is dependent on the value of
a target property, that target property may not be dependent on the linked
dependencies:

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

As the value of the :prop_tgt:`POSITION_INDEPENDENT_CODE` property of
the ``exe1`` target is dependent on the linked libraries (``lib3``), and the
edge of linking ``exe1`` is determined by the same
:prop_tgt:`POSITION_INDEPENDENT_CODE` property, the dependency graph above
contains a cycle.  :manual:`cmake(1)` issues an error message.

.. _`Output Artifacts`:

输出构件
----------------

The buildsystem targets created by the :command:`add_library` and
:command:`add_executable` commands create rules to create binary outputs.
The exact output location of the binaries can only be determined at
generate-time because it can depend on the build-configuration and the
link-language of linked dependencies etc.  ``TARGET_FILE``,
``TARGET_LINKER_FILE`` and related expressions can be used to access the
name and location of generated binaries.  These expressions do not work
for ``OBJECT`` libraries however, as there is no single file generated
by such libraries which is relevant to the expressions.

There are three kinds of output artifacts that may be build by targets
as detailed in the following sections.  Their classification differs
between DLL platforms and non-DLL platforms.  All Windows-based
systems including Cygwin are DLL platforms.

.. _`Runtime Output Artifacts`:

运行时输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

A *runtime* output artifact of a buildsystem target may be:

* The executable file (e.g. ``.exe``) of an executable target
  created by the :command:`add_executable` command.

* On DLL platforms: the executable file (e.g. ``.dll``) of a shared
  library target created by the :command:`add_library` command
  with the ``SHARED`` option.

The :prop_tgt:`RUNTIME_OUTPUT_DIRECTORY` and :prop_tgt:`RUNTIME_OUTPUT_NAME`
target properties may be used to control runtime output artifact locations
and names in the build tree.

.. _`Library Output Artifacts`:

库输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

A *library* output artifact of a buildsystem target may be:

* The loadable module file (e.g. ``.dll`` or ``.so``) of a module
  library target created by the :command:`add_library` command
  with the ``MODULE`` option.

* On non-DLL platforms: the shared library file (e.g. ``.so`` or ``.dylib``)
  of a shared library target created by the :command:`add_library`
  command with the ``SHARED`` option.

The :prop_tgt:`LIBRARY_OUTPUT_DIRECTORY` and :prop_tgt:`LIBRARY_OUTPUT_NAME`
target properties may be used to control library output artifact locations
and names in the build tree.

.. _`Archive Output Artifacts`:

档案输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

An *archive* output artifact of a buildsystem target may be:

* The static library file (e.g. ``.lib`` or ``.a``) of a static
  library target created by the :command:`add_library` command
  with the ``STATIC`` option.

* On DLL platforms: the import library file (e.g. ``.lib``) of a shared
  library target created by the :command:`add_library` command
  with the ``SHARED`` option.  This file is only guaranteed to exist if
  the library exports at least one unmanaged symbol.

* On DLL platforms: the import library file (e.g. ``.lib``) of an
  executable target created by the :command:`add_executable` command
  when its :prop_tgt:`ENABLE_EXPORTS` target property is set.

* On AIX: the linker import file (e.g. ``.imp``) of an executable target
  created by the :command:`add_executable` command when its
  :prop_tgt:`ENABLE_EXPORTS` target property is set.

The :prop_tgt:`ARCHIVE_OUTPUT_DIRECTORY` and :prop_tgt:`ARCHIVE_OUTPUT_NAME`
target properties may be used to control archive output artifact locations
and names in the build tree.

目录作用域命令
-------------------------

The :command:`target_include_directories`,
:command:`target_compile_definitions` and
:command:`target_compile_options` commands have an effect on only one
target at a time.  The commands :command:`add_compile_definitions`,
:command:`add_compile_options` and :command:`include_directories` have
a similar function, but operate at directory scope instead of target
scope for convenience.

.. _`Build Configurations`:

构建配置
====================

Configurations determine specifications for a certain type of build, such
as ``Release`` or ``Debug``.  The way this is specified depends on the type
of :manual:`generator <cmake-generators(7)>` being used.  For single
configuration generators like  :ref:`Makefile Generators` and
:generator:`Ninja`, the configuration is specified at configure time by the
:variable:`CMAKE_BUILD_TYPE` variable. For multi-configuration generators
like :ref:`Visual Studio <Visual Studio Generators>`, :generator:`Xcode`, and
:generator:`Ninja Multi-Config`, the configuration is chosen by the user at
build time and :variable:`CMAKE_BUILD_TYPE` is ignored.  In the
multi-configuration case, the set of *available* configurations is specified
at configure time by the :variable:`CMAKE_CONFIGURATION_TYPES` variable,
but the actual configuration used cannot be known until the build stage.
This difference is often misunderstood, leading to problematic code like the
following:

.. code-block:: cmake

  # WARNING: This is wrong for multi-config generators because they don't use
  #          and typically don't even set CMAKE_BUILD_TYPE
  string(TOLOWER ${CMAKE_BUILD_TYPE} build_type)
  if (build_type STREQUAL debug)
    target_compile_definitions(exe1 PRIVATE DEBUG_BUILD)
  endif()

:manual:`Generator expressions <cmake-generator-expressions(7)>` should be
used instead to handle configuration-specific logic correctly, regardless of
the generator used.  For example:

.. code-block:: cmake

  # Works correctly for both single and multi-config generators
  target_compile_definitions(exe1 PRIVATE
    $<$<CONFIG:Debug>:DEBUG_BUILD>
  )

In the presence of :prop_tgt:`IMPORTED` targets, the content of
:prop_tgt:`MAP_IMPORTED_CONFIG_DEBUG <MAP_IMPORTED_CONFIG_<CONFIG>>` is also
accounted for by the above ``$<CONFIG:Debug>`` expression.


区分大小写
----------------

:variable:`CMAKE_BUILD_TYPE` and :variable:`CMAKE_CONFIGURATION_TYPES` are
just like other variables in that any string comparisons made with their
values will be case-sensitive.  The ``$<CONFIG>`` generator expression also
preserves the casing of the configuration as set by the user or CMake defaults.
For example:

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

In contrast, CMake treats the configuration type case-insensitively when
using it internally in places that modify behavior based on the configuration.
For example, the ``$<CONFIG:Debug>`` generator expression will evaluate to 1
for a configuration of not only ``Debug``, but also ``DEBUG``, ``debug`` or
even ``DeBuG``.  Therefore, you can specify configuration types in
:variable:`CMAKE_BUILD_TYPE` and :variable:`CMAKE_CONFIGURATION_TYPES` with
any mixture of upper and lowercase, although there are strong conventions
(see the next section).  If you must test the value in string comparisons,
always convert the value to upper or lowercase first and adjust the test
accordingly.

默认和自定义配置
---------------------------------

By default, CMake defines a number of standard configurations:

* ``Debug``
* ``Release``
* ``RelWithDebInfo``
* ``MinSizeRel``

In multi-config generators, the :variable:`CMAKE_CONFIGURATION_TYPES` variable
will be populated with (potentially a subset of) the above list by default,
unless overridden by the project or user.  The actual configuration used is
selected by the user at build time.

For single-config generators, the configuration is specified with the
:variable:`CMAKE_BUILD_TYPE` variable at configure time and cannot be changed
at build time.  The default value will often be none of the above standard
configurations and will instead be an empty string.  A common misunderstanding
is that this is the same as ``Debug``, but that is not the case.  Users should
always explicitly specify the build type instead to avoid this common problem.

The above standard configuration types provide reasonable behavior on most
platforms, but they can be extended to provide other types.  Each configuration
defines a set of compiler and linker flag variables for the language in use.
These variables follow the convention :variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`,
where ``<CONFIG>`` is always the uppercase configuration name.  When defining
a custom configuration type, make sure these variables are set appropriately,
typically as cache variables.


伪目标
==============

Some target types do not represent outputs of the buildsystem, but only inputs
such as external dependencies, aliases or other non-build artifacts.  Pseudo
targets are not represented in the generated buildsystem.

.. _`Imported Targets`:

导入的目标
----------------

An :prop_tgt:`IMPORTED` target represents a pre-existing dependency.  Usually
such targets are defined by an upstream package and should be treated as
immutable. After declaring an :prop_tgt:`IMPORTED` target one can adjust its
target properties by using the customary commands such as
:command:`target_compile_definitions`, :command:`target_include_directories`,
:command:`target_compile_options` or :command:`target_link_libraries` just like
with any other regular target.

:prop_tgt:`IMPORTED` targets may have the same usage requirement properties
populated as binary targets, such as
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`,
:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`,
:prop_tgt:`INTERFACE_COMPILE_OPTIONS`,
:prop_tgt:`INTERFACE_LINK_LIBRARIES`, and
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`.

The :prop_tgt:`LOCATION` may also be read from an IMPORTED target, though there
is rarely reason to do so.  Commands such as :command:`add_custom_command` can
transparently use an :prop_tgt:`IMPORTED` :prop_tgt:`EXECUTABLE <TYPE>` target
as a ``COMMAND`` executable.

The scope of the definition of an :prop_tgt:`IMPORTED` target is the directory
where it was defined.  It may be accessed and used from subdirectories, but
not from parent directories or sibling directories.  The scope is similar to
the scope of a cmake variable.

It is also possible to define a ``GLOBAL`` :prop_tgt:`IMPORTED` target which is
accessible globally in the buildsystem.

See the :manual:`cmake-packages(7)` manual for more on creating packages
with :prop_tgt:`IMPORTED` targets.

.. _`Alias Targets`:

别名目标
-------------

An ``ALIAS`` target is a name which may be used interchangeably with
a binary target name in read-only contexts.  A primary use-case for ``ALIAS``
targets is for example or unit test executables accompanying a library, which
may be part of the same buildsystem or built separately based on user
configuration.

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  install(TARGETS lib1 EXPORT lib1Export ${dest_args})
  install(EXPORT lib1Export NAMESPACE Upstream:: ${other_args})

  add_library(Upstream::lib1 ALIAS lib1)

In another directory, we can link unconditionally to the ``Upstream::lib1``
target, which may be an :prop_tgt:`IMPORTED` target from a package, or an
``ALIAS`` target if built as part of the same buildsystem.

.. code-block:: cmake

  if (NOT TARGET Upstream::lib1)
    find_package(lib1 REQUIRED)
  endif()
  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 Upstream::lib1)

``ALIAS`` targets are not mutable, installable or exportable.  They are
entirely local to the buildsystem description.  A name can be tested for
whether it is an ``ALIAS`` name by reading the :prop_tgt:`ALIASED_TARGET`
property from it:

.. code-block:: cmake

  get_target_property(_aliased Upstream::lib1 ALIASED_TARGET)
  if(_aliased)
    message(STATUS "The name Upstream::lib1 is an ALIAS for ${_aliased}.")
  endif()

.. _`Interface Libraries`:

接口库
-------------------

An ``INTERFACE`` library target does not compile sources and does not
produce a library artifact on disk, so it has no :prop_tgt:`LOCATION`.

It may specify usage requirements such as
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`,
:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`,
:prop_tgt:`INTERFACE_COMPILE_OPTIONS`,
:prop_tgt:`INTERFACE_LINK_LIBRARIES`,
:prop_tgt:`INTERFACE_SOURCES`,
and :prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`.
Only the ``INTERFACE`` modes of the :command:`target_include_directories`,
:command:`target_compile_definitions`, :command:`target_compile_options`,
:command:`target_sources`, and :command:`target_link_libraries` commands
may be used with ``INTERFACE`` libraries.

Since CMake 3.19, an ``INTERFACE`` library target may optionally contain
source files.  An interface library that contains source files will be
included as a build target in the generated buildsystem.  It does not
compile sources, but may contain custom commands to generate other sources.
Additionally, IDEs will show the source files as part of the target for
interactive reading and editing.

A primary use-case for ``INTERFACE`` libraries is header-only libraries.

.. code-block:: cmake

  add_library(Eigen INTERFACE
    src/eigen.h
    src/vector.h
    src/matrix.h
    )
  target_include_directories(Eigen INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
    $<INSTALL_INTERFACE:include/Eigen>
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 Eigen)

Here, the usage requirements from the ``Eigen`` target are consumed and used
when compiling, but it has no effect on linking.

Another use-case is to employ an entirely target-focussed design for usage
requirements:

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

This way, the build specification of ``exe1`` is expressed entirely as linked
targets, and the complexity of compiler-specific flags is encapsulated in an
``INTERFACE`` library target.

``INTERFACE`` libraries may be installed and exported.  Any content they refer
to must be installed separately:

.. code-block:: cmake

  set(Eigen_headers
    src/eigen.h
    src/vector.h
    src/matrix.h
    )
  add_library(Eigen INTERFACE ${Eigen_headers})
  target_include_directories(Eigen INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
    $<INSTALL_INTERFACE:include/Eigen>
  )

  install(TARGETS Eigen EXPORT eigenExport)
  install(EXPORT eigenExport NAMESPACE Upstream::
    DESTINATION lib/cmake/Eigen
  )
  install(FILES ${Eigen_headers}
    DESTINATION include/Eigen
  )
