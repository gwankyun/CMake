target_link_libraries
---------------------

.. only:: html

   .. contents::

指定在链接给定目标或者其依赖项时要使用的库和标志。来自链接库目标的\
:ref:`使用需求 <Target Usage Requirements>`\ 将被传递下去。目标依赖项的使用需求会影响\
其自身源代码的编译。

概述
^^^^^^^^

该命令有几个签名，详细内容将在下面的小节中介绍。它们都有一般格式

.. code-block:: cmake

  target_link_libraries(<target> ... <item>... ...)

命名\ ``<target>``\ 必须是由\ :command:`add_executable`\ 或\ :command:`add_library`\
等命令创建的，并且不能是\ :ref:`别名目标 <Alias Targets>`。如果策略\ :policy:`CMP0079`\
没有设置为\ ``NEW``，则目标必须已经在当前目录下创建。重复调用相同的\ ``<target>``\ 将元素\
按照调用的顺序添加。

.. versionadded:: 3.13
  ``<target>``\ 不必定义在\ ``target_link_libraries``\ 调用所在的目录中。

每个\ ``<item>``\ 可能是：

* **库目标名**: 生成的链接行将具有与目标相关联的可链接库文件的完整路径。如果库文件发生更改，\
  构建系统将依赖于重新链接\ ``<target>``。

  命名目标必须由\ :command:`add_library`\ 在项目中创建，或者作为\
  :ref:`导入库 <Imported Targets>`\ 创建。如果它是在项目中创建的，那么将自动在构建系统中\
  添加一个排序依赖项，以确保命名库目标在\ ``<target>``\ 链接之前是最新的。

  如果导入库设置了\ :prop_tgt:`IMPORTED_NO_SONAME`\ 目标属性，CMake可能会要求链接器\
  搜索该库而不是使用完整的路径（例如\ ``/usr/lib/libfoo.so``\ 变成\ ``-lfoo``）。

  目标工作的完整路径会被shell自动引用/转义。

* **库文件的完整路径**: 生成的链接行通常会保留文件的完整路径。如果库文件发生更改，构建系统将\
  依赖于重新链接\ ``<target>`` 。

  在某些情况下，CMake可能会要求链接器搜索该库（例如\ ``/usr/lib/libfoo.so``\ 变成\
  ``-lfoo``），例如当检测到共享库没有\ ``SONAME``\ 字段时。有关另一个案例的讨论，请参阅策略\
  :policy:`CMP0060`。

  如果库文件在macOS框架中，框架的\ ``Headers``\ 目录也会作为\
  :ref:`使用需求 <Target Usage Requirements>`\ 进行处理。这与将框架目录作为include目录\
  传递的效果相同。

  .. versionadded:: 3.28

    在苹果平台上，库文件可能指向一个\ ``.xcframework``\ 文件夹。如果是，目标将获得所选库的\
    ``Headers``\ 目录作为使用要求。

  .. versionadded:: 3.8
    在VS 2010及更高版本的\ :ref:`Visual Studio Generators`\ 上，以\ ``.targets``\
    结尾的库文件将被视为MSBuild目标文件并导入生成的项目文件。其他生成器不支持此功能。

  库文件的完整路径将自动被引号/转义以供shell使用。

* **普通的库名**: 生成的链接行将要求链接器搜索该库（例如\ ``foo``\ 变为\ ``-lfoo``\ 或\
  ``foo.lib``）。

  库名/标志被视为命令行字符串片段，在使用时不需要额外的引号或转义。

* **链接标志**: 以\ ``-``\ 开头，但不是\ ``-l``\ 或\ ``-framework``\ 的项目名称被视为\
  链接标志。注意，对于传递依赖，这些标志会像其他任何库链接项一样被处理，所以通常只指定为不会\
  传播到依赖项的私有链接项是安全的。

  这里指定的链接标志会插入到链接命令中与链接库相同的位置。根据链接器的不同，这可能不正确。\
  使用\ :prop_tgt:`LINK_OPTIONS`\ 目标属性或\ :command:`target_link_options`\
  命令显式添加链接标志。然后，这些标志将放置在链接命令中工具链定义的标志位置。

  .. versionadded:: 3.13
    :prop_tgt:`LINK_OPTIONS`\ 目标属性和\ :command:`target_link_options`\ 命令。\
    对于CMake的早期版本，请使用\ :prop_tgt:`LINK_FLAGS`\ 属性。

  链接标志被视为命令行字符串片段，使用时不需要额外的引号或转义。

* **生成器表达式**: 一个\ ``$<...>``\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\
  可以求值为上述任何项或它们的\ :ref:`分号分隔列表 <CMake Language Lists>`。如果\ ``...``\
  包含任何\ ``;``\ 字符，例如，在\ ``${list}``\ 变量求值之后，一定要使用一个显式引用的参数\
  ``"$<...>"``\ 以便该命令接收它作为单个\ ``<item>``。

  此外，生成器表达式可以用作上述任何项的片段，例如\ ``foo$<1:_d>``。

  请注意，生成器表达式将不会用于策略\ :policy:`CMP0003`\ 或策略\ :policy:`CMP0004`\
  的旧处理。

* 一个\ ``debug``、\ ``optimized``\ 或\ ``general``\ 关键字，紧跟着另一个\ ``<item>``。\
  关键字后面的项将仅用于相应的构建配置。\ ``debug``\ 关键字对应\ ``Debug``\ 配置（如果\
  设置了全局属性\ :prop_gbl:`DEBUG_CONFIGURATIONS`，则对应全局配置）。\ ``optimized``\
  关键字对应所有其他配置。\ ``general``\ 关键字对应所有配置，纯粹是可选的。通过创建和链接到\
  :ref:`导入库目标 <Imported Targets>`，可以为每个配置规则实现更高的粒度。这些关键字由该\
  命令立即解释，因此当由生成器表达式生成时，没有特殊含义。

包含\ ``::``\ 的项，如\ ``Foo::Bar``，被认为是\ :ref:`导入 <Imported Targets>`\ 或\
:ref:`别名 <Alias Targets>`\ 库目标名，如果不存在这样的目标，将导致错误。参见策略\
:policy:`CMP0028`。

有关定义构建属性的更多信息，请参阅\ :manual:`cmake-buildsystem(7)`\ 手册。

目标和/或其依赖的库
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

  target_link_libraries(<target>
                        <PRIVATE|PUBLIC|INTERFACE> <item>...
                       [<PRIVATE|PUBLIC|INTERFACE> <item>...]...)

``PUBLIC``、\ ``PRIVATE``\ 和\ ``INTERFACE``\ :ref:`作用域 <Target Command Scope>`\
关键字可以在一个命令中同时指定链接依赖关系和链接接口。

``PUBLIC``\ 之后的库和目标被链接到，并成为链接接口的一部分。\ ``PRIVATE``\ 之后的库和目标\
链接到，但不构成链接接口的一部分。\ ``INTERFACE``\ 之后的库附加到链接接口，不用于链接\
``<target>``。

目标及其依赖的库
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

  target_link_libraries(<target> <item>...)

默认情况下，库依赖是可传递的。当这个目标链接到另一个目标时，链接到这个目标的库也会出现在另一个\
目标的链接行上。这个可传递的“链接接口”存储在\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
目标属性中，可以通过直接设置该属性来覆盖。当\ :policy:`CMP0022`\ 没有设置为\ ``NEW``\ 时，\
传递链接是内置的，但可能会被\ :prop_tgt:`LINK_INTERFACE_LIBRARIES`\ 属性覆盖。对该命令\
的其他签名的调用可能会设置属性，使由该签名独家链接的任何库变为私有。

用于目标和/或其依赖项的库（遗留）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

  target_link_libraries(<target>
                        <LINK_PRIVATE|LINK_PUBLIC> <lib>...
                       [<LINK_PRIVATE|LINK_PUBLIC> <lib>...]...)

The ``LINK_PUBLIC`` and ``LINK_PRIVATE`` modes can be used to specify both
the link dependencies and the link interface in one command.

This signature is for compatibility only.  Prefer the ``PUBLIC`` or
``PRIVATE`` keywords instead.

Libraries and targets following ``LINK_PUBLIC`` are linked to, and are
made part of the :prop_tgt:`INTERFACE_LINK_LIBRARIES`.  If policy
:policy:`CMP0022` is not ``NEW``, they are also made part of the
:prop_tgt:`LINK_INTERFACE_LIBRARIES`.  Libraries and targets following
``LINK_PRIVATE`` are linked to, but are not made part of the
:prop_tgt:`INTERFACE_LINK_LIBRARIES` (or :prop_tgt:`LINK_INTERFACE_LIBRARIES`).

仅用于依赖的库（遗留）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

  target_link_libraries(<target> LINK_INTERFACE_LIBRARIES <item>...)

The ``LINK_INTERFACE_LIBRARIES`` mode appends the libraries to the
:prop_tgt:`INTERFACE_LINK_LIBRARIES` target property instead of using them
for linking.  If policy :policy:`CMP0022` is not ``NEW``, then this mode
also appends libraries to the :prop_tgt:`LINK_INTERFACE_LIBRARIES` and its
per-configuration equivalent.

This signature is for compatibility only.  Prefer the ``INTERFACE`` mode
instead.

Libraries specified as ``debug`` are wrapped in a generator expression to
correspond to debug builds.  If policy :policy:`CMP0022` is
not ``NEW``, the libraries are also appended to the
:prop_tgt:`LINK_INTERFACE_LIBRARIES_DEBUG <LINK_INTERFACE_LIBRARIES_<CONFIG>>`
property (or to the properties corresponding to configurations listed in
the :prop_gbl:`DEBUG_CONFIGURATIONS` global property if it is set).
Libraries specified as ``optimized`` are appended to the
:prop_tgt:`INTERFACE_LINK_LIBRARIES` property.  If policy :policy:`CMP0022`
is not ``NEW``, they are also appended to the
:prop_tgt:`LINK_INTERFACE_LIBRARIES` property.  Libraries specified as
``general`` (or without any keyword) are treated as if specified for both
``debug`` and ``optimized``.

链接对象库
^^^^^^^^^^^^^^^^^^^^^^^^

.. versionadded:: 3.12

:ref:`Object Libraries`\ 可以用作\ ``target_link_libraries``\ 的\ ``<target>``\
（第一个）参数，以指定其源对其他库的依赖关系。例如，代码

.. code-block:: cmake

  add_library(A SHARED a.c)
  target_compile_definitions(A PUBLIC A)

  add_library(obj OBJECT obj.c)
  target_compile_definitions(obj PUBLIC OBJ)
  target_link_libraries(obj PUBLIC A)

用\ ``-DA -DOBJ``\ 编译\ ``obj.c``，并建立传播到其依赖项的\ ``obj``\ 的使用需求。

普通库和可执行文件可能会链接到\ :ref:`Object Libraries`\ 以获取它们的对象和使用需求。\
继续上面的例子，代码

.. code-block:: cmake

  add_library(B SHARED b.c)
  target_link_libraries(B PUBLIC obj)

用\ ``-DA -DOBJ``\ 编译\ ``b.c`` ，用来自\ ``b.c``\ 和\ ``obj.c``\ 的对象文件创建\
共享库\ ``B``，并将\ ``B``\ 链接到\ ``A``。此外，代码

.. code-block:: cmake

  add_executable(main main.c)
  target_link_libraries(main B)

用\ ``-DA -DOBJ``\ 编译\ ``main.c``，并将可执行的\ ``main``\ 链接到\ ``B``\ 和\
``A``。对象库的使用需求通过\ ``B``\ 传递，但它的目标文件不是。

:ref:`Object Libraries`\ 可能“链接”到其他对象库以获得使用需求，但由于它们没有链接步骤，\
因此对它们的对象文件什么也做不了。继续上面的例子，代码：

.. code-block:: cmake

  add_library(obj2 OBJECT obj2.c)
  target_link_libraries(obj2 PUBLIC obj)

  add_executable(main2 main2.c)
  target_link_libraries(main2 obj2)

用\ ``-DA -DOBJ``\ 编译\ ``obj2.c``，用\ ``main2.c``\ 和\ ``obj2.c``\ 的对象文件\
创建可执行的\ ``main2``，并将\ ``main2``\ 链接到\ ``A``。

换句话说，当\ :ref:`Object Libraries`\ 出现在目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
属性中时，它们将被视为\ :ref:`Interface Libraries`，但当它们出现在目标的\
:prop_tgt:`LINK_LIBRARIES`\ 属性中时，它们的目标文件也将包含在链接中。

.. _`Linking Object Libraries via $<TARGET_OBJECTS>`:

通过\ ``$<TARGET_OBJECTS>``\ 链接对象库
""""""""""""""""""""""""""""""""""""""""""""""""""

.. versionadded:: 3.21

与对象库关联的对象文件可以通过\ :genex:`$<TARGET_OBJECTS>`\ 生成器表达式引用。这样的目标\
文件放在链接行中所有库的\ *前面*，不管它们的相对顺序如何。此外，还会在构建系统中添加一个顺序\
依赖项，以确保对象库在依赖目标链接之前是最新的。例如，代码

.. code-block:: cmake

  add_library(obj3 OBJECT obj3.c)
  target_compile_definitions(obj3 PUBLIC OBJ3)

  add_executable(main3 main3.c)
  target_link_libraries(main3 PRIVATE a3 $<TARGET_OBJECTS:obj3> b3)

将可执行文件\ ``main3``\ 与\ ``main3.c``\ 和\ ``obj3.c``\ 的对象文件链接起来，然后是\
``a3``\ 和\ ``b3``\ 库。\ ``main3.c``\ 编译时\ *没有*\ 考虑\ ``obj3``\ 的使用需求，\
例如\ ``-DOBJ3``。

这种方法可以根据使用要求在链接行中实现目标文件的传递包含。继续上面的例子，代码

.. code-block:: cmake

  add_library(iface_obj3 INTERFACE)
  target_link_libraries(iface_obj3 INTERFACE obj3 $<TARGET_OBJECTS:obj3>)

创建一个接口库\ ``iface_obj3``，它转发\ ``obj3``\ 的使用需求，并将\ ``obj3``\ 对象文件\
添加到依赖的链接行。代码如下

.. code-block:: cmake

  add_executable(use_obj3 use_obj3.c)
  target_link_libraries(use_obj3 PRIVATE iface_obj3)

使用\ ``-DOBJ3``\ 编译\ ``use_obj3.c``，并将可执行文件\ ``use_obj3``\ 与\
``use_obj3.c``\ 和\ ``obj3.c``\ 中的目标文件链接起来。

这也可以通过静态库传递。因为静态库没有链接，所以它不会使用以这种方式引用的对象库中的对象文件。\
相反，目标文件变成了静态库的传递链接依赖。继续上面的例子，代码

.. code-block:: cmake

  add_library(static3 STATIC static3.c)
  target_link_libraries(static3 PRIVATE iface_obj3)

  add_executable(use_static3 use_static3.c)
  target_link_libraries(use_static3 PRIVATE static3)

使用\ ``-DOBJ3``\ 编译\ ``static3.c``\ 并创建\ ``libstatic3.a``\ 只使用自己的目标文件。\
编译\ ``use_static3.c``\ 时\ *没有*\ 使用\ ``-DOBJ3``，因为使用需求不能通过\
``static3``\ 的私有依赖传递。但是，\ ``static3``\ 的链接依赖会传播，包括\ ``iface_obj3``\
对\ ``$<TARGET_OBJECTS:obj3>``\ 的引用。\ ``use_static3``\ 可执行文件是由\
``use_static3.c``\ 和\ ``obj3.c``\ 的对象文件创建的，并链接到\ ``libstatic3.a``\ 库。

当使用这种方法时，项目有责任避免将多个有此依赖的二进制文件再次链接到\ ``iface_obj3``，\
因为它们都将在链接行上获得\ ``obj3``\ 对象文件。

.. note::

  在\ ``target_link_libraries``\ 调用中引用\ :genex:`$<TARGET_OBJECTS>`\ 在某些情况\
  下在3.21之前的CMake版本中工作，但不完全支持：

  * 它没有将目标文件放在库的链接行之前。
  * 它没有在对象库上添加顺序依赖项。
  * 它不能在Xcode中支持多种架构。

静态库的循环依赖
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

库依赖图通常是无环的（DAG），但在相互依赖的\ ``STATIC``\ 库的情况下，CMake允许图包含循环\
（强连接组件）。当另一个目标链接到其中一个库时，CMake会重复整个连接的组件。例如，代码

.. code-block:: cmake

  add_library(A STATIC a.c)
  add_library(B STATIC b.c)
  target_link_libraries(A B)
  target_link_libraries(B A)
  add_executable(main main.c)
  target_link_libraries(main A)

链接\ ``main``\ 到\ ``A B A B``，虽然一个重复通常是足够的，病态的目标文件和符号安排可能\
需要更多。我们可以使用\ :prop_tgt:`LINK_INTERFACE_MULTIPLICITY`\ 目标属性来处理这种情况，\
或者在最后一次\ ``target_link_libraries``\ 调用中手动重复组件。然而，如果两个归档文件真的\
如此相互依赖，那么它们可能应该组合成一个单独的归档文件，可以使用\ :ref:`Object Libraries`。

创建可重定位包
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. |INTERFACE_PROPERTY_LINK| replace:: :prop_tgt:`INTERFACE_LINK_LIBRARIES`
.. include:: /include/INTERFACE_LINK_LIBRARIES_WARNING.txt

另外参阅
^^^^^^^^

* :command:`target_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`
