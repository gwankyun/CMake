.. cmake-manual-description: CMake Qt Features Reference

cmake-qt(7)
***********

.. only:: html

   .. contents::

引言
============

CMake可以找到并使用Qt 4、Qt 5和Qt 6库。Qt 4库可以通过CMake自带的\ :module:`FindQt4`\
搜寻模块找到，而Qt 5和Qt 6库可以通过Qt 5和Qt 6自带的“配置文件包”找到。有关CMake包的更多信息，\
请参见\ :manual:`cmake-packages(7)`，并查看你所用Qt版本的\ `Qt cmake手册`_。

.. _`Qt cmake手册`: https://doc.qt.io/qt-6/cmake-manual.html

Qt 4、Qt 5和Qt 6可以在同一个\ :manual:`CMake buildsystem <cmake-buildsystem(7)>`\
中一起使用：

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

  project(Qt4_5_6)

  set(CMAKE_AUTOMOC ON)

  find_package(Qt6 COMPONENTS Widgets DBus REQUIRED)
  add_executable(publisher publisher.cpp)
  target_link_libraries(publisher Qt6::Widgets Qt6::DBus)

  find_package(Qt5 COMPONENTS Gui DBus REQUIRED)
  add_executable(subscriber1 subscriber1.cpp)
  target_link_libraries(subscriber1 Qt5::Gui Qt5::DBus)

  find_package(Qt4 REQUIRED)
  add_executable(subscriber2 subscriber2.cpp)
  target_link_libraries(subscriber2 Qt4::QtGui Qt4::QtDBus)

一个CMake目标不应该同时链接到多个Qt版本。如果尝试执行此操作或从可传递目标依赖项评估得到此\
结果，则会发出诊断。

Qt构建工具
==============

Qt依赖于一些捆绑的代码生成工具，比如用于元对象代码生成的\ ``moc``，用于小部件布局和填充的\
``uic``，以及用于虚拟文件系统内容生成的\ ``rcc``。如果满足适当的条件，:manual:`cmake(1)`\
可以自动调用这些工具。自动工具调用可以同时用于Qt 4到6。

.. _`Qt AUTOMOC`:

AUTOMOC
^^^^^^^

:prop_tgt:`AUTOMOC`\ 目标属性控制\ :manual:`cmake(1)`\ 是否检查目标中的C++文件，\
以确定它们是否需要运行\ ``moc``，并在适当的时间创建规则来执行\ ``moc``。

如果在头文件中发现了来自\ :prop_tgt:`AUTOMOC_MACRO_NAMES`\ 的宏，则将在该文件上运行\
``moc``。结果将被放入一个根据\ ``moc_<basename>.cpp``\ 命名的文件中。遵循Qt约定，如果\
在C++实现文件中找到宏，则moc输出将被放入根据\ ``<basename>.moc``\ 命名的文件中。\
``<basename>.moc``\ 必须由用户使用预处理器\ ``#include``\ 包含在C++实现文件中。

包括\ ``moc_*.cpp``\ 和\ ``*.moc``\ 文件将生成在\ ``<AUTOGEN_BUILD_DIR>/include``\
目录下，该目录会自动添加到目标的\ :prop_tgt:`INCLUDE_DIRECTORIES`\ 目录中。

* 这与CMake 3.7及以下版本不同；详细信息请参阅它们的文档。

* 对于\ :prop_gbl:`多配置生成器 <GENERATOR_IS_MULTI_CONFIG>`，\
  包含目录为\ ``<AUTOGEN_BUILD_DIR>/include_<CONFIG>``。

* 参考\ :prop_tgt:`AUTOGEN_BUILD_DIR`。

不包含\ ``moc_<basename>.cpp``\ 文件将在自定义文件夹中生成，以避免名称冲突，\
并包含在编译到目标中的单独文件中，命名为\ ``<AUTOGEN_BUILD_DIR>/mocs_compilation.cpp``\
或\ ``<AUTOGEN_BUILD_DIR>/mocs_compilation_$<CONFIG>.cpp``。

* 参考\ :prop_tgt:`AUTOGEN_BUILD_DIR`。

``moc``\ 命令行将使用它所调用的目标的\ :prop_tgt:`COMPILE_DEFINITIONS`\ 和\
:prop_tgt:`INCLUDE_DIRECTORIES`\ 目标属性，以及适当的构建配置。

:prop_tgt:`AUTOMOC`\ 目标属性可以通过设置\ :variable:`CMAKE_AUTOMOC`\ 变量预先为以下\
所有目标设置。可以填充\ :prop_tgt:`AUTOMOC_MOC_OPTIONS`\ 目标属性来设置要传递给\
``moc``\ 的选项。可以填充\ :variable:`CMAKE_AUTOMOC_MOC_OPTIONS`\ 变量，以预先设置以\
下所有目标的选项。

可以将其他要搜索的宏名称添加到\ :prop_tgt:`AUTOMOC_MACRO_NAMES`\ 中。

可以使用\ :prop_tgt:`AUTOMOC_DEPEND_FILTERS`\ 从源代码中提取其他\ ``moc``\ 依赖文件名称。

通过启用\ :prop_sf:`SKIP_AUTOMOC`\ 或更广泛的\ :prop_sf:`SKIP_AUTOGEN`，\
可以将源C++文件排除在\ :prop_tgt:`AUTOMOC`\ 处理之外。

.. _`Qt AUTOUIC`:

AUTOUIC
^^^^^^^

:prop_tgt:`AUTOUIC`\ 目标属性控制\ :manual:`cmake(1)`\ 是否检查目标中的C++文件，\
以确定它们是否需要运行\ ``uic``，并在适当的时候创建规则来执行\ ``uic``。

如果发现预处理器\ ``#include``\ 指令匹配\ ``<path>ui_<basename>.h``\ 和\
``<basename>.ui``\ 文件存在，则执行\ ``uic``\ 生成相应的文件。在以下位置搜索\
``<basename>.ui``\ 文件

1. ``<source_dir>/<basename>.ui``
2. ``<source_dir>/<path><basename>.ui``
3. ``<AUTOUIC_SEARCH_PATHS>/<basename>.ui``
4. ``<AUTOUIC_SEARCH_PATHS>/<path><basename>.ui``

其中\ ``<source_dir>``\ 是C++文件的目录，:prop_tgt:`AUTOUIC_SEARCH_PATHS`\ 是附加搜\
索路径的列表。

生成的\ ``ui_*.h``\ 文件被放置在\ ``<AUTOGEN_BUILD_DIR>/include``\ 目录中，该目录会\
自动添加到目标的\ :prop_tgt:`INCLUDE_DIRECTORIES`\ 目录中。

* 这与CMake 3.7及以下版本不同；详细信息请参阅它们的文档。

* 对于\ :prop_gbl:`多配置生成器 <GENERATOR_IS_MULTI_CONFIG>`，\
  包含目录为\ ``<AUTOGEN_BUILD_DIR>/include_<CONFIG>``。

* 参考\ :prop_tgt:`AUTOGEN_BUILD_DIR`。

:prop_tgt:`AUTOUIC`\ 目标属性可以通过设置\ :variable:`CMAKE_AUTOUIC`\ 变量预先为以下\
所有目标设置。:prop_tgt:`AUTOUIC_OPTIONS`\ 目标属性可以被填充以设置传递给\ ``uic``\
的选项。可以填充\ :variable:`CMAKE_AUTOUIC_OPTIONS`\ 变量，以预先设置以下所有目标的选项。\
:prop_sf:`AUTOUIC_OPTIONS`\ 源文件属性可以在\ ``<basename>.ui``\ 文件上来设置文件的特\
定选项。这将覆盖\ :prop_tgt:`AUTOUIC_OPTIONS`\ 目标属性中的选项。

一个目标可以用调用\ ``uic``\ 时应该使用的选项填充\ :prop_tgt:`INTERFACE_AUTOUIC_OPTIONS`\
目标属性。这必须与依赖器目标的\ :prop_tgt:`AUTOUIC_OPTIONS`\ 目标属性内容一致。\
:variable:`CMAKE_DEBUG_TARGET_PROPERTIES`\ 变量可以用来跟踪这样的\
:prop_tgt:`INTERFACE_AUTOUIC_OPTIONS`\ 的起始目标。这意味着为Qt提供替代翻译系统的库可\
以指定运行\ ``uic``\ 时应该使用的选项：

.. code-block:: cmake

  add_library(KI18n klocalizedstring.cpp)
  target_link_libraries(KI18n Qt6::Core)

  # KI18n uses the tr2i18n() function instead of tr().  That function is
  # declared in the klocalizedstring.h header.
  set(autouic_options
    -tr tr2i18n
    -include klocalizedstring.h
  )

  set_property(TARGET KI18n APPEND PROPERTY
    INTERFACE_AUTOUIC_OPTIONS ${autouic_options}
  )

当\ ``uic``\ 被\ :prop_tgt:`AUTOUIC`\ 运行时，一个连接到上游导出目标的消费项目会自动使\
用适当的选项，这是连接到\ :prop_tgt:`IMPORTED`\ 目标的结果：

.. code-block:: cmake

  set(CMAKE_AUTOUIC ON)
  # Uses a libwidget.ui file:
  add_library(LibWidget libwidget.cpp)
  target_link_libraries(LibWidget
    KF5::KI18n
    Qt5::Widgets
  )

通过启用\ :prop_sf:`SKIP_AUTOUIC`\ 或更广泛的\ :prop_sf:`SKIP_AUTOGEN`，\
可以将源文件排除在\ :prop_tgt:`AUTOUIC`\ 处理之外。

.. _`Qt AUTORCC`:

AUTORCC
^^^^^^^

:prop_tgt:`AUTORCC`\ 目标属性控制\ :manual:`cmake(1)`\ 是否创建规则在适当的时间对后缀为\
``.qrc``\ 的源文件执行\ ``rcc``。

.. code-block:: cmake

  add_executable(myexe main.cpp resource_file.qrc)

通过设置\ :variable:`CMAKE_AUTORCC`\ 变量，可以为以下所有目标预先设置\
:prop_tgt:`AUTORCC`\ 目标属性。可以填充\ :prop_tgt:`AUTORCC_OPTIONS`\ 目标属性来设置\
传递给\ ``rcc``\ 的选项。可以填充\ :variable:`CMAKE_AUTORCC_OPTIONS`\ 变量，以预先设\
置以下所有目标的选项。\ :prop_sf:`AUTORCC_OPTIONS`\ 源文件属性可以在\ ``<name>.qrc``\
文件上设置文件的特定选项。这将覆盖\ :prop_tgt:`AUTORCC_OPTIONS`\ 目标属性中的选项。

通过启用\ :prop_sf:`SKIP_AUTORCC`\ 或更广泛的\ :prop_sf:`SKIP_AUTOGEN`，源文件可以从\
:prop_tgt:`AUTORCC`\ 处理中排除。

.. _`<ORIGIN>_autogen`:

``<ORIGIN>_autogen``\ 目标
===============================

``moc``\ 和\ ``uic``\ 工具作为CMake生成的合成\ :ref:`<ORIGIN>_autogen <<ORIGIN>_autogen>`\
:command:`自定义目标 <add_custom_target>`\ 的一部分执行。默认情况下，\
``<ORIGIN>_autogen``\ 目标继承了\ ``<ORIGIN>``\ 目标的依赖关系（参见\
:prop_tgt:`AUTOGEN_ORIGIN_DEPENDS`）。通过将目标依赖项添加到\
:prop_tgt:`AUTOGEN_TARGET_DEPENDS`\ 目标属性，可以将它们添加到\
:ref:`<ORIGIN>_autogen`\ 中。

.. note::
  如果使用Qt 5.15或更高版本，并且生成器是\ :generator:`Ninja`\ 或\
  :ref:`Makefile Generators`，请参阅\ :ref:`<ORIGIN>_autogen_timestamp_deps`。

.. _`<ORIGIN>_autogen_timestamp_deps`:

``<ORIGIN>_autogen_timestamp_deps``\ 目标
==============================================

如果使用Qt 5.15或更高版本，并且生成器是\ :generator:`Ninja`\ 或\ :ref:`Makefile Generators`，\
则除了\ :ref:`<ORIGIN>_autogen`\ 之外，还创建了\ ``<ORIGIN>_autogen_timestamp_deps``\
目标。这个目标没有任何要执行的源或命令，但是它有以前由Qt 5.15之前的\ :ref:`<ORIGIN>_autogen`\
继承的依赖项。这些依赖项将作为自定义命令的顺序依赖项列表，而不会强制重新执行自定义命令。

Visual Studio生成器
========================

当使用\ :manual:`Visual Studio生成器 <cmake-generators(7)>`\ 时，CMake生成一个\
``PRE_BUILD``\ :command:`自定义命令 <add_custom_command>`，而不是\
:ref:`<ORIGIN>_autogen <<ORIGIN>_autogen>`\ :command:`自定义目标 <add_custom_target>`\
（用于\ :prop_tgt:`AUTOMOC`\ 和\ :prop_tgt:`AUTOUIC`）。但这并不总是可能的，并且在以\
下任何情况下都会使用\ :ref:`<ORIGIN>_autogen <<ORIGIN>_autogen>`\
:command:`自定义目标 <add_custom_target>`

- ``<ORIGIN>``\ 目标依赖于来自\ :prop_tgt:`AUTOMOC`\ 和\ :prop_tgt:`AUTOUIC`\
  而未被\ :prop_sf:`SKIP_AUTOMOC`、:prop_sf:`SKIP_AUTOUIC`、:prop_sf:`SKIP_AUTOGEN`\
  或\ :policy:`CMP0071`\ 排除的\ :prop_sf:`GENERATED`\ 文件
- :prop_tgt:`AUTOGEN_TARGET_DEPENDS`\ 列出了一个源文件
- :variable:`CMAKE_GLOBAL_AUTOGEN_TARGET`\ 已启用

Windows上的qtmain.lib
=====================

QtGui库的Qt 4和5\ :prop_tgt:`IMPORTED`\ 目标指定Qt附带的qtmain.lib静态库将被所有已启用\
:prop_tgt:`WIN32_EXECUTABLE`\ 的依赖可执行文件链接。

若要禁用此行为，请为基于Qt5的目标启用\ ``Qt5_NO_LINK_QTMAIN``\ 目标属性，或为基于Qt 4的\
目标启用\ ``QT4_NO_LINK_QTMAIN``\ 目标属性。

.. code-block:: cmake

  add_executable(myexe WIN32 main.cpp)
  target_link_libraries(myexe Qt4::QtGui)

  add_executable(myexe_no_qtmain WIN32 main_no_qtmain.cpp)
  set_property(TARGET main_no_qtmain PROPERTY QT4_NO_LINK_QTMAIN ON)
  target_link_libraries(main_no_qtmain Qt4::QtGui)
