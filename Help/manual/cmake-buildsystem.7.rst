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

传播使用要求
-----------------------------

目标的使用要求可以传递到依赖项。:command:`target_link_libraries`\ 命令通过\ ``PRIVATE``、``INTERFACE``\ 和\ ``PUBLIC``\ 关键字来控制传播。

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

因为\ ``archive``\ 是\ ``archiveExtras``\ 的\ ``PUBLIC``\ 依赖项，所以它的使用要求也会传播给\ ``consumer``。因为\ ``serialization``\ 是\ ``archiveExtras``\ 的\ ``PRIVATE``\ 依赖项，所以它的使用要求不会传播到\ ``consumer``。

通常，如果依赖项只在库的实现，而不是头文件中使用，则应该使用\ :command:`target_link_libraries`\ 和\ ``PRIVATE``\ 关键字指定依赖项。如果一个依赖在库的头文件中被额外使用（例如用于类继承），那么它应该被指定为\ ``PUBLIC``\ 依赖。一个库的实现中没有使用的依赖项，只有它的头文件才使用它，则应该被指定为一个\ ``INTERFACE``\ 依赖项。:command:`target_link_libraries`\ 命令可以对每个关键字进行多次调用：

.. code-block:: cmake

  target_link_libraries(archiveExtras
    PUBLIC archive
    PRIVATE serialization
  )

使用要求是通过从依赖项中读取目标属性的\ ``INTERFACE_``\ 变量并将值附加到操作数的非\ ``INTERFACE_``\ 变量来传播的。例如，读取依赖关系的\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 并将其附加到操作数的\ :prop_tgt:`INCLUDE_DIRECTORIES`\ 中。如果顺序是相关的且被维护，并且\ :command:`target_link_libraries`\ 调用产生的顺序不允许正确的编译，则可以使用适当的命令直接设置属性来更新顺序。

例如，如果一个目标的链接库必须按照\ ``lib1`` ``lib2`` ``lib3``\ 的顺序指定，但是包含目录必须按照\ ``lib3`` ``lib1`` ``lib2``\ 的顺序指定：

.. code-block:: cmake

  target_link_libraries(myExe lib1 lib2 lib3)
  target_include_directories(myExe
    PRIVATE $<TARGET_PROPERTY:lib3,INTERFACE_INCLUDE_DIRECTORIES>)

请注意，在指定将使用\ :command:`install(EXPORT)`\ 命令导出以进行安装的目标的使用要求时，必须格外小心。有关更多信息，请参阅\ :ref:`Creating Packages`。

.. _`Compatible Interface Properties`:

兼容的接口属性
-------------------------------

一些目标属性需要在目标和每个依赖项的接口之间兼容。例如，:prop_tgt:`POSITION_INDEPENDENT_CODE`\ 目标属性可以指定一个布尔值，表示目标是否应该被编译为位置无关的代码，这具有特定于平台的结果。目标还可以指定使用要求\ :prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`\ 来通知消费者必须被编译为位置无关代码。

.. code-block:: cmake

  add_executable(exe1 exe1.cpp)
  set_property(TARGET exe1 PROPERTY POSITION_INDEPENDENT_CODE ON)

  add_library(lib1 SHARED lib1.cpp)
  set_property(TARGET lib1 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1)

在这里，``exe1``\ 和\ ``exe2``\ 都将被编译为位置无关代码。``lib1``\ 也将被编译为位置无关代码，因为这是\ ``SHARED``\ 库的默认设置。如果依赖关系有冲突的、不兼容的要求，:manual:`cmake(1)`\ 会发出一个诊断：

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

``lib1``\ 要求\ ``INTERFACE_POSITION_INDEPENDENT_CODE``\ 与\ ``exe1``\ 目标的 \ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ 属性不“兼容”。库要求将消费者构建为位置无关代码，而可执行文件指定不构建为位置无关代码，因此会发出诊断。

``lib1``\ 和\ ``lib2``\ 要求不“兼容”。其中一个要求将消费者构建为与位置无关的代码，而另一个并未要求将消费者构建为与位置无关的代码。因为\ ``exe2``\ 链接到两者，并且它们是冲突的，所以会发出一个CMake错误消息： ::

  CMake Error: The INTERFACE_POSITION_INDEPENDENT_CODE property of "lib2" does
  not agree with the value of POSITION_INDEPENDENT_CODE already determined
  for "exe2".

为了“兼容”，如果有设置\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ 属性，在布尔意义上，必须与设置该属性的所有传递指定依赖项的\ :prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`\ 属性相同。

通过在\ :prop_tgt:`COMPATIBLE_INTERFACE_BOOL`\ 目标属性的内容中指定该属性，“兼容接口要求”的属性可以扩展到其他属性。每个指定的属性必须在消费目标和对应的属性之间兼容，每个依赖都有一个\ ``INTERFACE_``\ 前缀：

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

非布尔属性也可以参与“兼容接口”计算。在\ :prop_tgt:`COMPATIBLE_INTERFACE_STRING`\ 属性中指定的属性必须是未指定的，或者与所有传递指定的依赖项中的相同字符串相比较。这有助于确保库的多个不兼容版本不会通过目标的传递要求链接在一起：

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

:prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MAX`\ 目标属性指定内容将被数值计算，并且将计算所有指定的最大值：

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

类似地，可以使用\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MIN`\ 从依赖项中计算属性的最小数值。

每个计算出的“兼容”属性值都可以在生成时使用生成器表达式从消费者中读取。

请注意，对于每个被依赖者，每个兼容接口属性中指定的属性集不能与任何其他属性中指定的属性集相交。

属性起源调试
-------------------------

因为构建规范可以由依赖关系决定，创建目标和负责设置构建规范的代码缺乏本地化可能会使代码更难推理。:manual:`cmake(1)`\ 提供了一个调试工具，打印属性内容的来源，这可能是由依赖关系决定的。可以调试的属性列在\ :variable:`CMAKE_DEBUG_TARGET_PROPERTIES`\ 变量文档中：

.. code-block:: cmake

  set(CMAKE_DEBUG_TARGET_PROPERTIES
    INCLUDE_DIRECTORIES
    COMPILE_DEFINITIONS
    POSITION_INDEPENDENT_CODE
    CONTAINER_SIZE_REQUIRED
    LIB_VERSION
  )
  add_executable(exe1 exe1.cpp)

对于在\ :prop_tgt:`COMPATIBLE_INTERFACE_BOOL`\ 或\ :prop_tgt:`COMPATIBLE_INTERFACE_STRING`\ 中列出的属性，调试输出显示哪个目标负责设置该属性，以及哪个其他依赖项也定义了该属性。在\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MAX`\ 和\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MIN`\ 的情况下，调试输出显示每个依赖项的属性值，以及该值是否决定了新的极值。

使用生成器表达式构建规范
----------------------------------------------

构建规范可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`，其中包含有条件的或在生成时才知道的内容。例如，计算出的属性“compatible”值可以通过\ ``TARGET_PROPERTY``\ 表达式读取：

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

一元\ ``TARGET_PROPERTY``\ 生成器表达式和\ ``TARGET_POLICY``\ 生成器表达式是在消费目标上下文中计算的。这意味着使用要求规范可以根据使用者的不同进行评估：

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

``exe1``\ 可执行文件将使用\ ``-DLIB1_WITH_EXE``\ 编译，而\ ``shared_lib``\ 共享库将使用\ ``-DLIB1_WITH_SHARED_LIB``\ 和\ ``-DCONSUMER_CMP0041_NEW``\ 编译，因为策略\ :policy:`CMP0041`\ 在创建\ ``shared_lib``\ 目标的地方是\ ``NEW``。

``BUILD_INTERFACE``\ 表达式包装的需求仅在从同一个构建系统中的目标消费时使用，或者在使用\ :command:`export`\ 命令从导出到构建目录的目标消费时使用。``INSTALL_INTERFACE``\ 表达式包装了只在使用\ :command:`install(EXPORT)`\ 命令安装并导出的目标时使用的需求：

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

在这种情况下，``exe1``\ 可执行文件将使用\ ``-DClimbingStats_FROM_BUILD_LOCATION``\ 进行编译。导出命令生成\ :prop_tgt:`IMPORTED`\ 目标，其中省略了\ ``INSTALL_INTERFACE``\ 或\ ``BUILD_INTERFACE``，去掉了\ ``*_INTERFACE``\ 标记。使用\ ``ClimbingStats``\ 包的一个单独项目将包含：

.. code-block:: cmake

  find_package(ClimbingStats REQUIRED)

  add_executable(Downstream main.cpp)
  target_link_libraries(Downstream Upstream::ClimbingStats)

``Downstream``\ 目标将使用\ ``-DClimbingStats_FROM_BUILD_LOCATION``\ 或\ ``-DClimbingStats_FROM_INSTALL_LOCATION``\ 编译，这取决于\ ``ClimbingStats``\ 包是从构建位置还是安装位置使用的。有关包和导出的更多信息，请参阅\ :manual:`cmake-packages(7)`\ 手册。

.. _`Include Directories and Usage Requirements`:

包含目录和使用要求
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

包含目录在作为使用要求指定和与生成器表达式一起使用时需要一些特殊考虑。:command:`target_include_directories`\ 命令可以接受相对包含目录和绝对包含目录：

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  target_include_directories(lib1 PRIVATE
    /absolute/path
    relative/path
  )

相对路径是相对于出现命令的源目录进行解释的。:prop_tgt:`IMPORTED`\ 目标的\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 中不允许有相对路径。

在使用非平凡生成器表达式的情况下，可以在\ ``INSTALL_INTERFACE``\ 表达式的参数中使用\ ``INSTALL_PREFIX``\ 表达式。它是一个替换标记，在被消费项目导入时扩展为安装前缀。

包括构建树和安装树之间的目录使用需求通常不同。``BUILD_INTERFACE``\ 和\ ``INSTALL_INTERFACE``\ 生成器表达式可用于描述基于使用位置的单独使用需求。\ ``INSTALL_INTERFACE``\ 表达式中允许使用相对路径，并且相对于安装前缀进行解释。例如：

.. code-block:: cmake

  add_library(ClimbingStats climbingstats.cpp)
  target_include_directories(ClimbingStats INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/generated>
    $<INSTALL_INTERFACE:/absolute/path>
    $<INSTALL_INTERFACE:relative/path>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/$<CONFIG>/generated>
  )

CMake提供了与包含目录使用需求相关的两个便捷API。变量\ :variable:`CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE`\ 可以被启用，其作用相当于：

.. code-block:: cmake

  set_property(TARGET tgt APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR}>
  )

对于每个受影响的目标。对于已安装的目标来说，使用\ :command:`install(TARGETS)`\ 命令可以方便地使用\ ``INCLUDES DESTINATION``\ 组件：

.. code-block:: cmake

  install(TARGETS foo bar bat EXPORT tgts ${dest_args}
    INCLUDES DESTINATION include
  )
  install(EXPORT tgts ${other_args})
  install(FILES ${headers} DESTINATION include)

这相当于在由\ :command:`install(EXPORT)`\ 生成的每个已安装的\ :prop_tgt:`IMPORTED`\ 目标的\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 中附加\ ``${CMAKE_INSTALL_PREFIX}/include``。

当一个\ :ref:`导入的目标 <Imported targets>`\ 的\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ 被使用时，属性中的条目被视为\ ``SYSTEM``\ 包含目录，就像它们列在依赖项的 \ :prop_tgt:`INTERFACE_SYSTEM_INCLUDE_DIRECTORIES`\ 中一样。这可能导致在这些目录中找到的头文件的编译器警告被忽略。导入目标的这种行为可以通过在导入目标的\ *消费者*\ 上设置 \ :prop_tgt:`NO_SYSTEM_FROM_IMPORTED`\ 目标属性来控制，或者通过在导入目标本身上设置\ :prop_tgt:`IMPORTED_NO_SYSTEM`\ 目标属性来控制。

如果一个二进制目标被传递地链接到一个macOS :prop_tgt:`FRAMEWORK`，框架的\ ``Headers``\ 目录也被视为使用需求。这与将框架目录作为包含目录传递的效果相同。

链接库和生成器表达式
----------------------------------------

与构建规范一样，可以使用生成器表达式条件指定\ :prop_tgt:`链接库 <LINK_LIBRARIES>`。然而，由于使用需求的消耗是基于链接依赖项的集合，因此有一个额外的限制，即链接依赖项必须形成一个“有向无环图”。也就是说，如果链接到目标依赖于目标属性的值，那么目标属性可能不依赖于链接的依赖项：

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

由于\ ``exe1``\ 目标的\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ 属性的值依赖于链接的库（\ ``lib3``\ ），而链接\ ``exe1``\ 的边缘由同一个\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ 属性决定，因此上述依赖图包含一个循环。:manual:`cmake(1)`\ 发出错误消息。

.. _`Output Artifacts`:

输出构件
----------------

:command:`add_library`\ 和\ :command:`add_executable`\ 命令创建的构建系统目标创建规则来创建二进制输出。二进制文件的准确输出位置只能在生成时确定，因为它依赖于构建配置和链接依赖的链接语言等。``TARGET_FILE``、``TARGET_LINKER_FILE``\ 和相关的表达式可以用来访问生成的二进制文件的名称和位置。然而，这些表达式不适用于\ ``OBJECT``\ 库，因为这些库没有生成与表达式相关的单个文件。

目标可以构建三种输出工件，具体内容将在下面的部分中详细介绍。它们的分类在DLL平台和非DLL平台之间是不同的。包括Cygwin在内的所有基于windows的系统都是DLL平台。

.. _`Runtime Output Artifacts`:

运行时输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

构建系统目标的\ *运行时*\ 输出工件可能是：

* :command:`add_executable`\ 命令创建的可执行目标的可执行文件（例如\ ``.exe``）。

* 在DLL平台上：由\ :command:`add_library`\ 命令和\ ``SHARED``\ 选项创建的共享库目标的可执行文件（例如\ ``.dll``）。

:prop_tgt:`RUNTIME_OUTPUT_DIRECTORY`\ 和\ :prop_tgt:`RUNTIME_OUTPUT_NAME`\ 目标属性可以用于控制构建树中的运行时输出工件位置和名称。

.. _`Library Output Artifacts`:

库输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

构建系统目标的\ *library*\ 输出工件可能是：

* 由\ :command:`add_library`\ 命令使用\ ``MODULE``\ 选项创建的模块库目标的可加载模块文件（例如\ ``.dll``\ 或\ ``.so``）。

* 在非DLL平台上：由\ :command:`add_library`\ 命令和\ ``SHARED``\ 选项创建的共享库目标的共享库文件（例如\ ``.so``\ 或\ ``.dylib``）。

:prop_tgt:`LIBRARY_OUTPUT_DIRECTORY`\ 和\ :prop_tgt:`LIBRARY_OUTPUT_NAME`\ 目标属性可以用来控制构建树中的库输出工件位置和名称。

.. _`Archive Output Artifacts`:

档案输出构件
^^^^^^^^^^^^^^^^^^^^^^^^

构建系统目标的\ *归档*\ 输出工件可能是：

* 由\ :command:`add_library`\ 命令使用\ ``STATIC``\ 选项创建的静态库目标的静态库文件（例如\ ``.lib``\ 或\ ``.a``）。

* 在DLL平台上：由\ :command:`add_library`\ 命令和\ ``SHARED``\ 选项创建的共享库目标的导入库文件（例如\ ``.lib``）。只有当库导出至少一个非托管符号时，才保证此文件存在。

* 在DLL平台上：当设置了可执行目标的\ :prop_tgt:`ENABLE_EXPORTS`\ 目标属性时，由\ :command:`add_executable`\ 命令创建的可执行目标的导入库文件（例如\ ``.lib``）。

* 在AIX上：当设置了可执行目标的\ :prop_tgt:`ENABLE_EXPORTS`\ 目标属性时，:command:`add_executable`\ 命令创建的可执行目标的链接器导入文件（例如\ ``.imp``）。

:prop_tgt:`ARCHIVE_OUTPUT_DIRECTORY`\ 和\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\ 目标属性可以用于控制构建树中的归档输出工件位置和名称。

目录作用域命令
-------------------------

:command:`target_include_directories`、:command:`target_compile_definitions`\ 和\ :command:`target_compile_options`\ 命令一次只能对一个目标产生影响。:command:`add_compile_definitions`、:command:`add_compile_options`\ 和\ :command:`include_directories`\ 命令具有类似的功能，但为了方便起见，它们在目录范围而不是目标范围内操作。

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
