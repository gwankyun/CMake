.. cmake-manual-description: CMake C++ Modules Support Reference

cmake-cxxmodules(7)
*******************

.. versionadded:: 3.28

C++ 20为语言引入了“\ :term:`模块 <C++ module>`\ ”的概念。该设计要求\
:term:`构建系统 <build system>`\ 对编译进行排序，以可靠地满足\ ``import``\ 语句。\
CMake的实现会在构建过程中要求编译器扫描源文件以查找模块依赖，整理扫描结果以推断\
排序约束，并告诉\ :term:`构建工具 <build tool>`\ 如何动态更新构建图。

编译策略
====================

使用C++模块后，编译一组C++源文件不再是\ :term:`易并行 <embarrassingly parallel>`。\
也就是说，任何给定的源文件可能需要先编译另一个源文件，以提供C++编译器用于满足其他\
源文件中\ ``import``\ 语句的“\ :abbr:`BMI (built module interface)`\ ”\
（或“\ :abbr:`CMI (compiled module interface)`\ ”）。对于包含的头文件，源文件可以\
共享其声明，以便任何消费者都能独立编译。而对于模块，编译器现在会在编译过程中根据\
源文件的内容及其\ ``export``\ 语句生成\ :term:`BMI`\ 文件。这意味着，为确保正确\
构建而无需在每次源文件更改时（通过运行配置和生成步骤）重新生成构建图，必须在构建\
阶段从源文件中确定正确的编译顺序。

:term:`构建系统 <build system>`\ 必须能够在构建图中对这些编译进行排序。有多种适用\
于此的策略，但每种策略都有其优缺点。CMake使用“扫描”步骤策略，这是CMake用户在构建\
上下文中最明显的与模块相关的变更。CMake提供了多种方式来控制源文件的扫描行为。

.. _cxxmodules-scanning-control:

扫描控制
================

是否扫描源代码以查找C++模块的使用情况取决于以下查询。使用第一个提供决定是否扫描的查询。

- 如果源文件属于\ ``CXX_MODULES``\ 类型的文件集，则会对其进行扫描。
- 如果目标不使用至少C++ 20，则不会对其进行扫描。
- 如果源文件不是\ ``CXX``\ 语言，它将不会被扫描。
- 如果设置了\ :prop_sf:`CXX_SCAN_FOR_MODULES`\ 源文件属性，则将使用其值。
- 如果设置了\ :variable:`CMAKE_CXX_SCAN_FOR_MODULES`\ 目标属性，则将使用其值。设置\
  :variable:`CMAKE_CXX_SCAN_FOR_MODULES`\ 变量，以便在创建所有目标时初始化该属性。
- 否则，将在编译器和生成器支持的前提下，扫描源文件。参见策略\ :policy:`CMP0155`。

请注意，任何扫描的源代码都将被排除在任何统一构建中（参见\ :prop_tgt:`UNITY_BUILD`），\
因为与模块相关的语句只能发生在C++翻译单元中的一个地方。

编译器支持
================

CMake支持扫描C++模块源文件的编译器列表包括：

* MSVC toolset 14.34及更高版本（随Visual Studio 17.4及更高版本提供）
* LLVM/Clang 16.0及更高版本
* GCC 14及更高版本

``import std``\ 支持
======================

对\ ``import std``\ 的支持仅限于以下工具链和标准库组合：

* Clang 18.1.2及更高版本，搭配标准库\ ``libc++``\ 或\ ``libstdc++`` 
* MSVC toolset 14.36及更高版本（随Visual Studio 17.6及更高版本提供）
* GCC 15及更高版本

  .. note::

    Ubuntu 26.04之前的版本附带损坏的\ ``libstdc++.modules.json``\ 文件。
    参见\ `Ubuntu issue 2141579`_。

.. _`Ubuntu issue 2141579`: https://bugs.launchpad.net/ubuntu/+source/gcc-15/+bug/2141579

:variable:`CMAKE_CXX_COMPILER_IMPORT_STD`\ 变量列出了活动C++工具链中支持\
``import std``\ 的标准级别。  

此外，目前只有\ :ref:`Ninja Generators`\ 支持\ ``import std``，因为\
:ref:`Visual Studio Generators`\ 不支持为\ ``IMPORTED``\ 目标构建\ :term:`BMIs <BMI>`。

.. note::

   仅当通过\ ``CMAKE_EXPERIMENTAL_CXX_IMPORT_STD``\ 开关启用了对\ ``import std``\
   的实验性支持时，才提供此支持。

生成器支持
=================

支持扫描C++模块源代码的生成器包括：

- :generator:`Ninja`
- :generator:`Ninja Multi-Config`
- :generator:`Visual Studio 17 2022`
- :generator:`Visual Studio 18 2026`

注意\ :ref:`Ninja Generators`\ 要求\ ``ninja`` 1.11或更新版本。

限制
-----------

CMake中当前C++模块支持存在一些已知限制。编译器中的已知限制或bug未在此处列出，\
因为这些可能会随时间变化。

对于所有生成器：

- :term:`头单元 <header unit>`\ 不被支持。

对于\ :ref:`Visual Studio Generators`：

- 仅支持Visual Studio 2022和MSVC工具集14.34（Visual Studio 17.4）及更高版本。
- 不支持导出或安装\ :term:`BMI`\ 或模块信息。
- 不支持从带有C++模块（包括\ ``import std``\ ）的\ ``IMPORTED``\ 目标编译\
  :term:`BMIs <BMI>`。
- 未诊断从\ ``PUBLIC``\ 模块源使用由\ ``PRIVATE``\ 源提供的模块的情况。

另外，作为设计选择，CMake不为导入的目标表达与配置无关的模块映射。\
:prop_tgt:`IMPORTED_CXX_MODULES_<CONFIG>`\ 目标属性始终与特定配置相关联。这在\
从/向无配置感知的构建系统导入/导出目标时可能会产生一些摩擦。未来的工作将缓解这\
一限制。

使用
=====

CMake故障排除
---------------------

本节旨在回答有关CMake实现的常见问题，并帮助诊断或解释CMake C++模块支持中的错误。

文件扩展名支持
^^^^^^^^^^^^^^^^^^^^^^

CMake对任何单元类型的模块的文件扩展名没有要求。虽然不同工具链有不同的偏好（例如，\
MSVC上的\ ``.ixx``\ 和Clang上的\ ``.cppm``），但没有普遍认可的扩展名。因此，CMake\
只要求文件被识别为\ ``CXX``\ 语言源文件。默认情况下，任何被识别的扩展名都足够，\
但也可以将\ :prop_sf:`LANGUAGE`\ 属性与任何其他扩展名一起使用。

文件名要求
^^^^^^^^^^^^^^^^^^^^^^

模块名称与其声明所在文件的名称或路径没有关系。C++标准对此没有要求，CMake也没有。\
然而，在项目中使用某种模式可能会很有用，以便在缺乏类似IDE的“查找符号”功能的环境中\
（例如，在代码审查平台上）更轻松地导航。 

无模块扫描
^^^^^^^^^^^^^^^^^^^^^^^^

尚未采用模块的项目面临的一个常见问题是源文件的不必要扫描。这种情况通常发生在C++20\
项目开始使用CMake 3.28时，或者3.28感知项目开始使用C++20时。这两种情况都会将\
:policy:`CMP0155`\ 设置为\ ``NEW``，默认情况下启用对C++20或更新版本的C++源文件的\
扫描。项目关闭此功能的最简单方法是添加：

.. code-block:: cmake

   set(CMAKE_CXX_SCAN_FOR_MODULES 0)

到其顶层\ ``CMakeLists.txt``\ 文件的顶部。注意，它\ **不应**\ 放在缓存中，否则\
可能会影响通过\ ``FetchContent``\ 使用它的项目。还应注意可能想要为自己的源文件\
启用扫描的供应商项目，因为这也会改变它们的默认设置。

调试模块构建
-----------------------

本节旨在帮助诊断或解释CMake的C++模块支持在构建方面可能出现的常见错误。

导入循环
^^^^^^^^^^^^^

C++标准不允许\ :term:`translation unit`\ 的\ ``import``\ 图中存在循环；因此，\
CMake也不允许。目前，CMake会将此检测留给\ :term:`build tool`，基于用于排序模块\
编译的\ :term:`dynamic dependencies`。\ `CMake Issue 26119`_\ 跟踪了在这种情况下\
改善用户体验的需求。

.. _`CMake Issue 26119`: https://gitlab.kitware.com/cmake/cmake/-/issues/26119

内部模块分区扩展
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

在最初研究C++模块构建的实现时，似乎存在一种代表\ :term:`partition unit`\ 和\
:term:`implementation unit`\ 交集的\ :term:`translation unit`\ 类型。早期的CMake\
设计包含了对这些翻译单元的特定支持；然而，在仔细阅读标准后，发现这些单元实际上并\
不存在。这些单元本应该使用\ ``module M:part;``\ 作为其模块声明语句。问题在于，\
这也是用于声明不贡献到主模块外部接口的模块分区的确切语法。只有MSVC支持这种区分。\
其他编译器不支持，并且会将此类文件视为\ :term:`internal partition unit`，而CMake\
会引发错误，指出提供模块的C++源文件必须位于类型为\ ``CXX_MODULES``\ 的\
``FILE_SET``\ 中。

修复方法是不使用此扩展，因为它与不使用扩展相比没有提供更多的表达能力。所有\
:term:`implementation unit`\ 源文件都应该只使用\ ``module M;``\ 作为其模块声明\
语句，无论所定义的实体在哪个分区中声明。例如：

.. code-block:: cpp

   // module-interface.cpp
   export module M;
   export int foo();

   // module-impl.cpp
   module M:part; // module M:part; looks like an internal partition
   int foo() { return 42; }

相反，应使用显式的接口/实现分离：

.. code-block:: cpp

   // module-interface.cpp
   export module M;
   export int foo();

   // module-impl.cpp
   module M;
   int foo() { return 42; }

模块可见性
^^^^^^^^^^^^^^^^^

CMake在目标之间和目标内部强制实施\ :term:`module visibility`。这本质上意味着，\
从目标\ ``T``\ 的\ ``PRIVATE`` ``FILE_SET``\ 提供的模块（例如\ ``I``\ ）不能被\
以下对象导入：

- 依赖于\ ``T``\ 的其他目标；或
- 从目标\ ``T``\ 自身的\ ``PUBLIC`` ``FILE_SET``\ 提供的模块。

这是因为，一般来说，从模块导入的所有实体也必须能够被该模块的所有潜在导入者导入。\
即使模块\ ``I``\ 仅在模块的部分内容中使用（没有\ ``export``\ 关键字），它也可能\
以某种方式影响模块内部，使得模块的使用者需要能够传递地\ ``import``\ 它才能正常\
工作。由于CMake使用模块可见性来确定是否安装\
:term:`模块接口单元 <module interface unit>`，\ ``PRIVATE``\ 模块接口单元不会被\
安装，这意味着任何导入\ ``I``\ 的已安装模块的使用都将无法正常工作。

相反，仅从\ :term:`implementation unit`\ 内部导入\ ``PRIVATE`` C++ 模块，因为这些\
模块不会暴露给任何模块的使用者。

设计
======

CMake的C++模块支持设计与其他设计相比做出了多项权衡。首先，将介绍CMake选择的设计。\
后续章节将介绍未被CMake实现选用的替代设计。

总体而言，这些设计位于两个维度的某个位置：

.. list-table::

   * - 显式动态
     - 显式静态
     - 显式固定
   * - 隐式动态
     - 隐式静态
     - 隐式固定

* **显式**\ 构建直接控制每个翻译单元可见的模块。例如，当编译需要模块\ ``M``\
  的源文件时，编译器将获得指定导入\ ``M``\ 模块时要使用的确切BMI文件的信息。
* **隐式**\ 构建也可以控制模块可见性，但它通过将\ :term:`BMIs <BMI>` 分组到目录\
  中来实现，然后在这些目录中搜索文件以满足源文件中的\ ``import``\ 语句。
* **静态**\ 构建使用一组静态的构建命令来完成构建。必须支持在构建时在节点之间添加边。
* **动态**\ 构建可能在构建过程中创建新的构建命令，并在构建过程中安排任何发现的工作。
* **固定**\ 构建是在所有模块依赖关系已知的情况下生成的。

设计目标
------------

CMake的C++模块构建实现侧重于以下设计目标：

1. `Correct Builds <design-goal-correct-builds_>`__
2. `Deterministic Builds <design-goal-deterministic-builds_>`__
3. `Support Generated Sources <design-goal-generated-sources_>`__
4. `Static Communication <design-goal-static-communication_>`__
5. `Minimize Regeneration <design-goal-minimize-regeneration_>`__

.. _design-goal-correct-builds:

正确构建
^^^^^^^^^^^^^^

最重要的是，不正确的构建对所有相关人员来说都是令人沮丧的体验。一个不检测错误而让\
有可检测问题的构建运行完成的系统，很容易导致毫无结果的调试会话。CMake会优先避免\
这种情况。

.. _design-goal-deterministic-builds:

确定性构建
^^^^^^^^^^^^^^^^^^^^

给定构建的磁盘状态，应该能够确定接下来会发生什么步骤。这并不意味着构建中可以并发\
运行的规则的精确顺序是确定的，而是指要完成的工作集及其结果是确定的。例如，如果任务\
``A``\ 和\ ``B``\ 之间没有依赖关系，那么\ ``A``\ 不应对\ ``B``\ 的执行产生影响，\
反之亦然。

.. _design-goal-generated-sources:

支持生成的源代码
^^^^^^^^^^^^^^^^^^^^^^^^^

代码生成在C++生态系统中非常普遍，因此仅支持在配置时已知内容的文件中使用模块是不\
合适的。如果不支持使用或提供模块的生成源代码，代码生成工具将无法使用模块，并且\
生成源代码的任何依赖项也必须提供非模块化的方式来使用其接口（即提供头文件）。考虑\
到所有C++实现都在符号修饰中使用\ :term:`strong module ownership`，当这些接口最终\
引用其他库中已编译的符号时，这会带来问题。

.. _design-goal-static-communication:

静态通信
^^^^^^^^^^^^^^^^^^^^

构建的不同步骤之间的所有通信都应该静态处理。鉴于CMake支持的\
:term:`build tools <build tool>`，为需要在编译期间交互的配套工具建立受控生命周期\
是具有挑战性的。\ ``make``\ 和\ ``ninja``\ 都不提供在构建开始时启动工具并确保在\
构建结束时停止它的方法。相反，与编译器的通信通过输入和输出文件进行管理，使用\
:term:`build tool`\ 中的依赖项来保持一切更新。这种方法启用了标准的构建调试策略，\
并允许开发人员在调查问题时直接运行构建命令，而无需考虑在后台运行的其他工具。

.. _design-goal-minimize-regeneration:

最小化重新生成
^^^^^^^^^^^^^^^^^^^^^

在使用模块的构建进行积极开发时，不应要求每次更改都重新生成构建图。这意味着模块\
依赖必须在构建图可用后构建。否则，一个\ `正确的构建 <design-goal-correct-builds_>`__\
将需要在每次编辑模块感知源文件时重新生成构建图，因为任何更改都可能改变模块依赖关系。

这也意味着所有模块感知源必须在配置时已知（即使它们尚未存在），以便构建图可以包含\
用于\ :term:`scan`\ 其依赖关系的命令。

.. note::

  ``ninja``\ 存在一个已知问题，当两次构建之间两个源之间的依赖顺序反转（即\ ``a``\
  导入\ ``b``\ 变为\ ``b``\ 导入\ ``a``）时，可能会错误地检测到依赖循环。详情请\
  参见\ `ninja issue 2666`_。

.. _`ninja issue 2666`: https://github.com/ninja-build/ninja/issues/2666

用例考量
-----------------------

上述设计目标对实现进行了约束。此外，CMake通过多配置生成器（如\
:generator:`Ninja Multi-Config`\ 和\ :ref:`Visual Studio Generators`\ ）支持混合\
配置。本节描述CMake如何处理这些约束。

选择的设计
---------------

CMake使用的一般策略是“\ :term:`scan`\ ”源文件以提取排序依赖信息，并使用现有边之\
间的新边更新构建图。这是通过获取每个源文件的扫描结果（由\ `P1689R5`_\ 文件表示），\
然后使用其依赖项的信息为每个目标“\ :term:`collating <collate>`\ ”它们来完成的。\
整理器的主要任务是生成“\ :term:`module map`\ ”文件，将其传递给每个编译规则，并\
提供满足\ ``import``\ 语句所需的\ :term:`BMIs <BMI>`\ 路径，以及在编译期间通知\
:term:`build tool`\ 满足这些\ ``import``\ 语句所需的依赖项。整理器还使用构建时\
信息为模块接口单元、它们的\ :term:`BMIs <BMI>`\ 生成\ ``install``\ 规则，以及为\
任何带有C++模块的导出目标生成属性。它还强制实施\ ``PRIVATE``\ 模块不得被其他目标\
或目标内的任何\ ``PUBLIC`` :term:`module interface unit`\ 使用的规则。

.. _`P1689R5`: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/p1689r5.html

实现细节
----------------------

本节描述CMake实际如何构建图、各部分之间传递的数据以及包含该数据的文件。它既可用\
作功能文档，也可用作指南，帮助调试模块构建的人员了解在哪里找到各种数据。

.. note::

   本节记录了内部实现细节，可能对\ :manual:`工具链文件 <cmake-toolchains(7)>`\
   作者或调试模块相关问题时有用。项目不需要检查或修改此处提到的任何变量、属性、\
   文件或目标。

工具链（扫描）
^^^^^^^^^^^^^^^^^^^^

支持模块的编译器还必须提供扫描工具。这通常是编译器本身带有一些额外标志，或者是与\
编译器一起提供的工具。扫描的命令模板存储在\ ``CMAKE_CXX_SCANDEP_SOURCE``\ 变量中。\
该命令应将\ `P1689R5`_\ 格式的结果写入\ ``<DYNDEP_FILE>``\ 占位符指定的位置。\
此外，该命令还应将任何\ :term:`discovered dependencies` ``<DEP_FILE>``\ 占位符。\
这允许\ :term:`构建工具 <build tool>`\ 在扫描命令的任何依赖项发生变化时重新运行扫描。

此外，工具链应设置以下变量：

* ``CMAKE_CXX_MODULE_MAP_FORMAT``：\ :term:`module map`\ 的格式，用于描述编译期\
  间导入模块的依赖\ :term:`BMI`\ 文件的位置。必须是\ ``gcc``、\ ``clang``\ 或\
  ``msvc``\ 之一。
* ``CMAKE_CXX_MODULE_MAP_FLAG``：用于告知编译器\ :term:`module map`\ 文件的参数。\
  它应使用\ ``<MODULE_MAP_FILE>``\ 占位符。
* ``CMAKE_CXX_MODULE_BMI_ONLY_FLAG``：用于仅从\ :term:`module interface unit`\
  编译\ :term:`BMI`\ 文件的参数。这在从外部项目使用模块时用于编译当前构建中使用的\
  :term:`BMI`\ 文件。

如果工具链不提供\ ``CMAKE_CXX_MODULE_BMI_ONLY_FLAG``，它将无法使用由\ ``IMPORTED``\
目标提供的模块。

工具链（\ ``import std``\ ）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

如果工具链支持\ ``import std``，它还必须提供一个名为\
``${CMAKE_CXX_COMPILER_ID}-CXX-CXXImportStd``\ 的工具链标识模块。

.. note::

   当前只有CMake可以提供这些文件，因为它们的包含方式。一旦\ ``import std``\
   不再是实验性的，外部工具链也可以独立提供支持。

该模块必须提供\ ``_cmake_cxx_import_std``\ 命令。它将接收两个参数：C++ 标准的\
版本（例如\ ``23``\ ）和一个变量名，用于存放其\ ``import std``\ 支持的结果。该\
变量应填充CMake源代码，用于声明\ ``__CMAKE::CXX${std}``\ 目标，其中\ ``${std}``\
是传入的版本。如果无法创建该目标，源代码应将\
``CMAKE_CXX${std}_COMPILER_IMPORT_STD_NOT_FOUND_MESSAGE``\ 变量设置为当前配置不\
支持\ ``import std``\ 的原因。请注意，CMake将使用条件检查来保护返回的代码，以\
确保目标只定义一次。

理想情况下，\ ``__CMAKE::CXX${std}``\ 目标将是一个带有附加\ ``std``\ 模块源的\
``IMPORTED`` ``INTERFACE``\ 目标。但是，对于某些实现可能需要编译对象。当有期望由\
模块的使用者通过编译它来提供的符号时，需要对象文件。这里存在一个问题，如果在程序\
中多次发生这种情况，将导致这些符号的重复，这可能违反它们的\ :term:`ODR`。

例如，如果模块的使用者被期望为该模块提供符号，那么模块的使用就是程序的全局属性，\
不能被抽象掉。想象一个库公开C API但内部使用C++模块。如果它应该提供模块符号，\
那么任何使用C API的东西如果想将相同的模块用于自己的目的，都需要与其内部模块使用\
进行协作。如果两者最终都为导入的模块提供符号，可能会产生冲突。

Configure
^^^^^^^^^

During the configure step, CMake needs to track which sources care about
modules at all.  See :ref:`Scanning Control <cxxmodules-scanning-control>` for
how each source determines whether it cares about modules or not.  CMake
tracks these in its internal target representation structure (``cmTarget``).
The set of sources which need to be scanned may be modified using the
:command:`target_sources`, :command:`target_compile_features`, and
:command:`set_property` commands.

Additionally, targets may use the :prop_tgt:`CXX_MODULE_STD` target property
to indicate that ``import std`` is desired within the target's sources.

Generate
^^^^^^^^

During generation, CMake needs to add additional rules to ensure that the
sources providing modules can be built before sources that import those
modules.  Since CMake uses a :term:`static build`, the build graph must
contain all possible commands for scanning and module generation.  The
dependency edges between commands to ensure that modules are provided will
then ensure that the build graph executes correctly.  This means that, while
all sources may get scanned, only modules that are actually used will be
generated.

The first step CMake performs is to generate a :term:`synthetic target` for
each unique usage of a module-providing target.  These targets are based on
other targets, but provide only :term:`BMI` files for other targets rather
than object files.  This is because the compatibility of :term:`BMI` files is
extremely narrow and cannot be shared between arbitrary ``import`` instances.
Due to the internal workings of toolchains, there can generally only be a
single set of settings for a variety of flags for any one compilation,
including :term:`BMI` files for imported modules.  As an example, the C++
standard in use needs to be consistent across all modules, but there are many
settings which may cause incompatibilities.

.. note::

   CMake currently assumes that all usages are compatible and will only create
   one set of :term:`BMIs <BMI>` for each target.  This may cause build
   failures where multiple :term:`BMI` files are required, but CMake only
   provides one set.  See `CMake Issue 25916`_ for progress on removing this
   assumption.

.. _`CMake Issue 25916`: https://gitlab.kitware.com/cmake/cmake/-/issues/25916

Once all of the :term:`synthetic targets <synthetic target>` are created,
CMake looks at each target that has any source that might use C++ modules and
creates a command to :term:`scan` each of them.  This command will output a
`P1689R5`_-formatted file describing the C++ modules it uses and provides (if
any).  It will also create a command to :term:`collate` module dependencies
for the eligible compilations.  This command depends on the :term:`scan`
results of all eligible sources, information about the target itself, as well
as the :term:`collate` results of any dependent targets which provide C++
modules.  The :term:`collate` step uses a target-specific
``CXXDependInfo.json`` file which contains the following information:

- ``compiler-*``: basic compiler information (``id``, ``frontend-variant``,
  and ``simulate-id``) which is used to generate correctly formatted paths
  when generating paths for the compiler
- ``cxx-modules``: a map of object files to the ``FILE_SET`` information,
  which is used to enforce :term:`module visibility` and generate install
  rules for :term:`module interface unit` sources
- ``module-dir``: where to place :term:`BMI` files for this target
- ``dir-{cur,top}-{src,bld}``: the source (``src``) and build (``bld``)
  directories for the current directory (``cur``) and the top (``top``) of the
  project, used to compute accurate relative paths for the :term:`build tool`
  dynamic dependencies
- ``exports``: The list of exports which both contain the target and are
  providing C++ module information, used to provide accurate module properties
  on ``IMPORTED`` targets from the exported targets.
- ``bmi-installation``: installation information, used to generate install
  scripts for :term:`BMI` files
- ``database-info``: information required to generate :term:`build database`
  information if requested by :prop_tgt:`EXPORT_BUILD_DATABASE`
- ``sources``: list of other source files in the target, used to add to the
  :term:`build database` if requested
- ``config``: the configuration for the target, used to set the appropriate
  properties in generated export files
- ``language``: the language (e.g., C++ or Fortran) the
  :term:`collation <collate>` metadata file is describing
- ``include-dirs`` and ``forward-modules-from-target-dirs``: unused for C++

Each entry in the ``cxx-modules`` map records the following:

- ``bmi-only`` (bool): True if only the BMI, not the source of the BMI, is
  available
- ``compile-features`` (list[string]): :manual:`cmake-compile-features(7)` used
  to build the object
- ``compile-options`` (list[string]): compilation options/flags used to build
  the object, except for those derived from ``compile-features``
- ``definitions`` (list[string]): preprocessor defines used to build the object
- ``destination`` (string): intended install destination of the source file
- ``include-directories`` (list[string]): include directories used to build the
  object
- ``name`` (string): name of the file set which owns the source file
- ``relative-directory`` (string): base path relative to which the source file
  will be relocated into the install destination
- ``source`` (string): path to the source file
- ``type`` (string): type of the file set which owns the source file
- ``visibility`` (string): visibility of the file set which owns the source file

For each compilation, CMake will also provide a :term:`module map` which will
be created during the build by the :term:`collate` command.  How this is
provided to the compiler is specified by the ``CMAKE_CXX_MODULE_MAP_FORMAT``
and ``CMAKE_CXX_MODULE_MAP_FLAG`` toolchain variables.

Scan
^^^^

The compiler is expected to implement the :term:`scan` command.  This is
because only the compiler itself can reliably answer preprocessor predicates
like ``__has_builtin`` in order to provide accurate module usage information
in the face of arbitrary flags that may be used when compiling sources.

CMake names these files with the ``.ddi`` extension, which stands for "dynamic
dependency information".  These files are in `P1689R5`_ format and are used by
the :term:`collate` command to perform its tasks.

Collate
^^^^^^^

The :term:`collate` command performs the bulk of the work to make C++ modules
work within the build graph.  It consumes the following files as input:

- ``CXXDependInfo.json`` from the generate step
- ``.ddi`` files from the :term:`scanning <scan>` results of the target's
  sources
- ``CXXModules.json`` files output from eligible dependent targets'
  :term:`collate` commands

It uses the information from these files to generate:

- ``CXX.dd`` files to inform the :term:`build tool` of dependencies that exist
  between the compilation of a source and the :term:`BMI` files of the modules
  that it imports
- ``CXXModules.json`` files for use in :term:`collate` commands of depending
  targets
- ``*.modmap`` files for each compilation to find :term:`BMI` files for
  imported modules
- ``install-cxx-module-bmi-$<CONFIG>.cmake`` scripts for the installation of
  any :term:`BMI` files (included by the ``install`` scripts)
- ``target-*-$<CONFIG>.cmake`` export files for any exports of the target to
  provide the :prop_tgt:`IMPORTED_CXX_MODULES_<CONFIG>` properties
- ``CXX_build_database.json`` :term:`build database` files for the target when
  the its :prop_tgt:`EXPORT_BUILD_DATABASE` property is set

During its processing, it enforces the following guarantees:

- :term:`BMI` usage is consistent
- :term:`module visibility` is respected

C++ modules have the rule that only a single module of a given name may
exist within a program.  This is not exactly enforceable with the existence of
private modules, but it is enforceable for public modules.  The enforcement is
done by the :term:`collate` command.  Part of the ``CXXModules.json`` files is
the set of modules that are transitively imported by each module it provides.
When a module is then imported, the :term:`collate` command ensures that all
modules with a given name agree upon a given :term:`BMI` file to provide that
module.

Compile
^^^^^^^

Compilation uses the :term:`module map` file generated by the :term:`collate`
command to find imported modules during compilation.  Because CMake only
provides the locations of modules that are discovered by the :term:`scan`
command, any modules missed by it will not be provided to the compilation.

It is possible for toolchains to reject the :term:`BMI` file that CMake
provides to a compilation as incompatible.  This is because CMake assumes that
all usages are compatible at the moment.  See `CMake Issue 25916`_ for
progress on removing this assumption.

Install
^^^^^^^

During installation, install scripts which have been written by the
:term:`collate` command during the build are included so that any :term:`BMI`
files are installed as needed.  These need to be generated, as it is not
known what the :term:`BMI` file names will be during CMake's generation
(because CMake names the :term:`BMI` files after the module name itself).
These install scripts are included with the ``OPTIONAL`` keyword, so an
incomplete build may result in an incomplete installation as well.

Alternative Designs
-------------------

There are alternative designs that CMake does not implement.  This section
aims to give a brief overview and to explain why they were not chosen for
CMake's implementation.

Implicit Builds
^^^^^^^^^^^^^^^

An implicit build performs module builds using compile-time search paths to
make the implementation of the build simpler.  This is certainly something
that can be made to work.  However, CMake's goals exclude it as a solution.

When a build uses search directory management, the compiler is directed to
place module output files into a specified directory.  These directories are
then provided as search paths to any compilation allowed to use the modules
within them.

This strategy risks running into problems with the
`Correct Builds <design-goal-correct-builds_>`__ goal.  This stems from the
hazard of stale files being present in the search directories.  Since the
build system is unaware of the actual files being written, it is difficult to
know which files are allowed to be deleted (e.g., using ``ninja -t cleandead``
to remove outputs ``ninja`` has encountered but are no longer generated).
Removal of intermediate files may also cause the build to become stuck if the
outputs are not known to the build system beyond consumers reporting "usage of
file X".

There is also a need to at least do some level of ordering of :term:`BMI`
generation commands which share an output directory.  Separate directories may
be used to order groups of modules (e.g., one directory per target);
otherwise, modules within the same directory may not assume that other modules
writing to the shared directory will complete first.  If module paths are
grouped accurately according to the module dependency graph, it is a small
step to being an explicit build where the files are directly specified.

Static Scanning
^^^^^^^^^^^^^^^

A :term:`fixed build` performs a scan while generating the build graph and
includes the necessary dependencies up-front.  In CMake's case, it would look
at the source files during the generate phase and add the dependencies
directly to the build graph.  This is more likely to be suitable for a
:term:`build system` that is also its own :term:`build tool` where build graph
manipulation can be done cooperatively.

No matter whether it is integrated or not, this strategy necessitates either a
suitable C++ parser to extract the information in the first place, or toolchain
cooperation to obtain it.  While module dependency information is available to
a simpler C++ parser, dependencies may be hidden behind preprocessor
conditionals that need to be understood in order to be accurate.  Of course,
choosing to not support preprocessor conditionals around ``import`` statements
is also an option, but this may severely limit external library support.

For CMake, this strategy would mean that any change to a module-aware source
file may need to trigger regeneration of the build graph.  A benign edit would
at least need to trigger the *check* for changed imports, but may skip
actually regenerating if it is unchanged.  This may be less critical for a
:term:`build system` which is also its own :term:`build tool`, but it is a
direct violation of the
`Minimize Regeneration <design-goal-minimize-regeneration_>`__ goal.

Additionally, CMake's
`Support Generated Sources <design-goal-generated-sources_>`__ goal would be
unsupportable with this strategy.  CMake could defer scanning until the
generated files are available, but those sources cannot be compiled until such
a scan has been performed.  This would mean that there would be some unbounded
(but finite) number of regenerations of the build graph as sources become
available.

Module Mapping Service
^^^^^^^^^^^^^^^^^^^^^^

Another strategy is to run a service alongside the build that can act as an
oracle for where to place and discover modules.  The compiler is instructed to
query the service with questions such as "this source is exporting module X"
and "this source is importing module Y" and receive the path to either create
or find the :term:`BMI`, respectively.  In this case, the service dynamically
implements the collation logic.

Of particular note, this conflicts with the
`Deterministic Builds <design-goal-deterministic-builds_>`__ and
`Static Communication <design-goal-static-communication_>`__ goals because the
on-disk state may not match the actual state, and coordinating the lifetime of
the :term:`build tool` itself with the service is difficult.  The primary
missing feature is some signal when a build session starts and ends so that
such a service can know in what context it is answering requests.  There also
needs to be a way to resume a session and detect when a session is
invalidated.  No :term:`build tool` that CMake supports today has such
features.

There are also hazards which conflict with the
`Correct Builds <design-goal-correct-builds_>`__ goal.  When a module is
imported, the compiler waits for a response before continuing.  However, there
is no guarantee that a (visible) module of that name even exists, so it may
wait indefinitely.  While waiting for a compilation to report that it creates
that module, it may run into a dependency cycle which leaves the compilations
hanging until some resource limit is reached (probably time, or that all
possible providers of the module have not reported a module of that name).
While these compilations are waiting on answers, there is the question of how
they affect the parallelism limits of the :term:`build tool` in use.  Do
compilations waiting on an answer count towards the limit and block other
compilations from launching to potentially discover the module?  If they do
not, what about other resources that may be held in use by those compilations
(e.g., memory or available file descriptors)?

Possible Future Enhancements
============================

This section documents possible future enhancements to CMake's support of C++
modules.  Nothing here is a guarantee of future implementation, and the
ordering is arbitrary.

Batch Scanning
--------------

It is possible to scan all sources within a target at once, which should be
faster when sources share transitive includes.  This does have side effects
for incremental builds, as the update of any source in the target means that
all sources in the target are scanned again.  Given how much faster scanning
can be, it should be negligible to do such "extra" scanning assuming that
unchanged results do not trigger recompilations.

BMI Modification Optimization
-----------------------------

Currently, as with object files, compilers always update a :term:`BMI` file
even if the contents have not changed.  Because modules increase the potential
scope of "non-changes" to cause (conceptually) unnecessary recompilation, it
might be useful to avoid recompilation of module consumers if the :term:`BMI`
file has not changed.  This might be achieved by wrapping the compilation to
juggle the :term:`BMI` through a ``cmake -E copy_if_different`` pass with
``ninja``'s ``restat = 1`` feature to avoid recompiling importers if the
:term:`BMI` file doesn't actually change.

.. _`easier-source-specification`:

Easier Source Specification
---------------------------

The initial implementation of CMake's module support had used the "just list
sources; CMake will figure it out" pattern.  However, this ran into issues
related to other metadata requirements.  These were discovered while
implementing CMake support beyond just building the modules-using code.

Conflicts with `Separate BMI Generation <separate-bmi-generation_>`__ on a
single target, as that requires knowledge of all :term:`BMI`-generating rules
at generate time.

.. _`separate-bmi-generation`:

Separate BMI Generation
-----------------------

CMake currently uses a single rule to generate both the :term:`BMI` and the
object file for a compilation.  At least Clang supports compiling an object
directly from the :term:`BMI`.  This would be beneficial because :term:`BMI`
generation is typically faster than compilation and generating the :term:`BMI`
as a separate step allows importers to start compiling without waiting for the
object to also be generated.

This is not supported in the current implementation as only Clang supports
generating an object directly from the :term:`BMI`.  Other compilers either do
not support such a two-phase generation (GCC) or need to start object
compilation from the source again.

Conflicts with `Easier Source Specification <easier-source-specification_>`__
on a single target because CMake must know all :term:`BMI`-generating sources
at generate time rather than build time to create the two-phase rules.

Module Compilation Glossary
===========================

.. glossary::

   BMI
     Built Module Interface.  A compiler-generated binary representation of a
     C++ module's interface that is required by consumers of the module.  File
     extensions vary by compiler.

   CMI
     Compiled Module Interface.  Alternative name for :term:`BMI` used by some
     compilers.

   build database
     A JSON file containing compilation commands, module dependencies, and
     grouping information.  Used for IDE integration and build analysis.

   build system
     A tool that facilitates the building of software which includes a model
     of how components of the build relate to each other.  For example, CMake,
     Meson, build2, and more.

   build tool
     A build graph execution tool.  For example, `ninja` and `make`.  Some
     build tools are also their own :term:`build system`.

   C++ module
     A C++20 language feature for describing the API of a piece of software.
     Intended as a replacement for headers for this purpose.

   collate
     The process of aggregating module information from scanned sources to
     ensure correct compilation order and to provide metadata for other parts
     of the build (e.g., installation or a :term:`build database`).

   discovered dependencies
     Dependencies found during the processing of a command that do not need to
     be explicitly declared.

   dynamic dependencies
     Dependencies which require a separate command to detect so that a further
     command may have its dependencies satisfied.

   embarrassingly parallel
     A set of tasks which, due to having minimal dependencies between them,
     can be easily divided into many independent tasks that can be executed
     concurrently.

   explicit build
     A build strategy where module dependencies are explicitly specified
     rather than discovered.

   fixed build
     A build strategy where all module dependencies are computed and inserted
     directly into the build graph.

   header unit
     A header file which is used via an ``import`` statement rather than an
     ``#include`` preprocessor directive.  Implementations may provide support
     for treating ``#include`` as ``import`` as well.

   implementation unit
     A C++ :term:`translation unit` that implements module entities declared
     in a module interface unit.

   implicit build
     A build strategy where module dependencies are discovered by searching
     for :term:`BMI` files during compilation.

   internal partition unit
     A :term:`translation unit` which contains a partition name and is not
     exported from the :term:`primary module interface unit`.

   module interface unit
     A :term:`translation unit` that declares a module's public interface
     using ``export module``.  Such a unit may or may not be also be a
     :term:`partition unit`.

   module map
     A compiler-specific file mapping module names to BMI locations.

   module visibility
     CMake's enforcement of access rules for modules based on their
     declaration scope (PUBLIC/PRIVATE).

   ODR
     One Definition Rule.  The C++ requirement that any entity be defined
     exactly once per program.

   partition unit
     A :term:`translation unit` which describes a module with a partition name
     (i.e., `module MODNAME:PARTITION;`).  The partition may or may not use
     the ``export`` keyword.  If it does, it is also a
     :term:`module interface unit`; otherwise, it is a
     :term:`internal partition unit`.

   primary module interface unit
     A :term:`module interface unit` which exports a named module that is not
     a :term:`partition unit`.

   scan
     The process of analyzing a :term:`translation unit` to discover module
     imports and exports.

   static build
     A build configuration where all compilation rules are determined at
     generate time.

   strong module ownership
     C++ implementations have settled on a model where the module "owns" the
     symbols declared within it.  In practice, this means that the module name
     is included into the symbol mangling of entities declared within it.

   synthetic target
     A CMake-generated build target used to supply :term:`BMIs <BMI>` to a
     specific user of a module-providing target.

   translation unit
     The smallest component of a compilation for a C++ program.  Generally,
     there is one translation unit per source file.  C++ source files which do
     not use C++ modules may be combined into a single translation unit.
