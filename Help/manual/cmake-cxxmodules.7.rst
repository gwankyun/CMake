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

配置
^^^^^^^^^

在配置步骤中，CMake需要跟踪哪些源文件关心模块。有关每个源文件如何确定其是否关心\
模块的信息，请参见\ :ref:`Scanning Control <cxxmodules-scanning-control>`。CMake\
在其内部目标表示结构（\ ``cmTarget``\ ）中跟踪这些信息。可以使用\
:command:`target_sources`、\ :command:`target_compile_features`\ 和\
:command:`set_property`\ 命令修改需要扫描的源文件集合。

此外，目标可以使用\ :prop_tgt:`CXX_MODULE_STD`\ 目标属性来表示希望在目标的源文件\
中使用\ ``import std``。

生成
^^^^^^^^

在生成步骤中，CMake需要添加额外的规则，以确保提供模块的源文件能够在导入这些模块\
的源文件之前构建。由于CMake使用\ :term:`static build`，构建图必须包含所有可能的\
扫描和模块生成命令。确保提供模块的命令之间的依赖边将确保构建图正确执行。这意味着，\
虽然所有源文件可能会被扫描，但只有实际使用的模块才会被生成。

CMake执行的第一步是为提供模块的目标的每一种唯一使用方式生成一个\
:term:`synthetic target`。这些目标基于其他目标，但只为其他目标提供\ :term:`BMI`\
文件，而不是目标文件。这是因为\ :term:`BMI`\ 文件的兼容性极其狭窄，不能在任意\
``import``\ 实例之间共享。由于工具链的内部工作原理，对于任何一次编译，通常只能\
有一组针对各种标志的设置，包括导入模块的\ :term:`BMI`\ 文件。例如，使用的C++标准\
需要在所有模块中保持一致，但有许多设置可能会导致不兼容。

.. note::

   CMake当前假设所有用法都是兼容的，并且每个目标只会创建一组\ :term:`BMIs <BMI>`。\
   当需要多个\ :term:`BMI`\ 文件但CMake只提供一组时，这可能会导致构建失败。有关\
   移除这一假设的进展，请参见\ `CMake Issue 25916`_。

.. _`CMake Issue 25916`: https://gitlab.kitware.com/cmake/cmake/-/issues/25916

一旦所有\ :term:`合成目标 <synthetic target>`\ 创建完成，CMake会检查每个包含可能\
使用C++模块的源文件的目标，并为其中每个源文件创建一个\ :term:`scan`\ 命令。该命令\
会输出一个\ `P1689R5`_\ 格式的文件，描述其使用和提供的C++模块（如果有）。CMake\
还会为合格的编译创建一个\ :term:`collate`\ 模块依赖的命令。该命令依赖于所有合格\
源文件的\ :term:`scan`\ 结果、目标本身的信息，以及任何提供C++模块的依赖目标的\
:term:`collate`\ 结果。:term:`collate`\ 步骤使用特定于目标的\
``CXXDependInfo.json``\ 文件，其中包含以下信息：

- ``compiler-*``: 基本编译器信息（\ ``id``、\ ``frontend-variant``\ 和\
  ``simulate-id``），用于在为编译器生成路径时生成正确格式化的路径
- ``cxx-modules``: 对象文件到\ ``FILE_SET``\ 信息的映射，用于强制执行\
  :term:`module visibility`\ 并为\ :term:`module interface unit`\ 源文件生成安装\
  规则
- ``module-dir``: 为此目标放置\ :term:`BMI`\ 文件的位置
- ``dir-{cur,top}-{src,bld}``: 当前目录（\ ``cur``\ ）和项目顶部（\ ``top``\ ）\
  的源（\ ``src``\ ）和构建（\ ``bld``\ ）目录，用于为\ :term:`build tool`\
  动态依赖计算准确的相对路径
- ``exports``: 既包含目标又提供C++模块信息的导出列表，用于从导出的目标中为\
  ``IMPORTED``\ 目标提供准确的模。
- ``bmi-installation``: 安装信息，用于为\ :term:`BMI`\ 文件生成安装脚本
- ``database-info``: 如果\ :prop_tgt:`EXPORT_BUILD_DATABASE`\ 请求，则生成\
  :term:`build database`\ 信息所需的信息
- ``sources``: 目标中其他源文件的列表，用于在请求时添加到\ :term:`build database`
- ``config``: 目标的配置，用于在生成的导出文件中设置适当的属性
- ``language``: :term:`collation <collate>`\ 元数据文件所描述的语言（例如，C++\
  或Fortra
- ``include-dirs``\ 和\ ``forward-modules-from-target-dirs``: 对于C++未使用

``cxx-modules``\ 映射中的每个条目记录以下内容：

- ``bmi-only`` (bool)：如果仅存在BMI而不存在BMI的源代码，则为True
- ``compile-features`` (list[string])：用于构建对象的\ :manual:`cmake-compile-features(7)`
- ``compile-options`` (list[string])：用于构建对象的编译选项/标志，不包括从\
  ``compile-features``\ 派生的选项
- ``definitions`` (list[string])：用于构建对象的预处理器定义
- ``destination`` (string)：源文件的预期安装目标
- ``include-directories`` (list[string])：用于构建对象的包含目录
- ``name`` (string)：拥有源文件的文件集名称
- ``relative-directory`` (string)：源文件将被重定位到安装目标的相对基础路径
- ``source`` (string)：源文件的路径
- ``type`` (string)：拥有源文件的文件集类型
- ``visibility`` (string)：拥有源文件的文件集可见性

每次编译时，CMake还会提供一个\ :term:`module map`，该映射由\ :term:`collate`\
命令在构建过程中创建。如何将其提供给编译器由\ ``CMAKE_CXX_MODULE_MAP_FORMAT``\
和\ ``CMAKE_CXX_MODULE_MAP_FLAG``\ 工具链变量指定。

扫描
^^^^

编译器需要实现\ :term:`scan`\ 命令。这是因为只有编译器本身能够可靠地回答像\
``__has_builtin``\ 这样的预处理器谓词，以便在面对编译源文件时可能使用的任意标志\
时提供准确的模块使用信息。

CMake使用\ ``.ddi``\ 扩展名命名这些文件，它代表“动态依赖信息”\
（dynamic dependency information）。这些文件采用\ `P1689R5`_\ 格式，并被\
:term:`collate`\ 命令用于执行其任务。

整合
^^^^^^^

:term:`collate`\ 命令执行大部分工作，使C++模块在构建图中正常工作。它使用以下文件\
作为输入：

- 来自生成步骤的\ ``CXXDependInfo.json``
- 来自目标源文件的\ :term:`scanning <scan>`\ 结果的\ ``.ddi``\ 文件
- 来自符合条件的依赖目标的\ :term:`collate`\ 命令输出的\ ``CXXModules.json``\ 文件

它使用这些文件中的信息生成：

- ``CXX.dd``\ 文件，用于通知\ :term:`build tool`\ 源文件编译与它导入的模块的\
  :term:`BMI`\ 文件之间存在的依赖关系
- 供依赖目标的\ :term:`collate`\ 命令使用的\ ``CXXModules.json``\ 文件
- 每个编译用于查找导入模块的\ :term:`BMI`\ 文件的\ ``*.modmap``\ 文件
- 用于安装任何\ :term:`BMI`\ 文件的\ ``install-cxx-module-bmi-$<CONFIG>.cmake``\
  脚本（由\ ``install``\ 脚本包含）
- 用于目标的任何导出的\ ``target-*-$<CONFIG>.cmake``\ 导出文件，以提供\
  :prop_tgt:`IMPORTED_CXX_MODULES_<CONFIG>`\ 属性
- 当目标的\ :prop_tgt:`EXPORT_BUILD_DATABASE`\ 属性设置时，为目标生成\
  ``CXX_build_database.json`` :term:`build database`\ 文件

在其处理过程中，它强制执行以下保证：

- :term:`BMI`\ 使用一致
- 遵守\ :term:`module visibility`

C++模块有一个规则，即一个程序中只能存在一个给定名称的模块。对于私有模块，这并不\
完全可执行，但对于公共模块是可执行的。这种强制执行由\ :term:`collate`\ 命令完成。\
``CXXModules.json``\ 文件的一部分是它提供的每个模块可传递导入的模块集。当导入一个\
模块时，\ :term:`collate`\ 命令确保所有具有给定名称的模块都同意使用给定的\
:term:`BMI`\ 文件来提供该模块。

编译
^^^^^^^

编译过程使用由\ :term:`collate`\ 命令生成的\ :term:`module map`\ 文件来在编译期\
间查找导入的模块。由于CMake只提供由\ :term:`scan`\ 命令发现的模块位置，任何被它\
遗漏的模块都不会被提供给编译过程。

工具链可能会拒绝CMake提供给编译的\ :term:`BMI`\ 文件，认为它们不兼容。这是因为\
CMake目前假设所有用法都是兼容的。有关消除此假设的进展，请参见\ `CMake Issue 25916`_。

安装
^^^^^^^

在安装过程中，会包含由构建期间的\ :term:`collate`\ 命令编写的安装脚本，以便根据\
需要安装任何\ :term:`BMI`\ 文件。这些脚本需要生成，因为在CMake生成期间不知道\
:term:`BMI`\ 文件的名称（因为CMake根据模块名称本身命名\ :term:`BMI`\ 文件）。\
这些安装脚本包含\ ``OPTIONAL``\ 关键字，因此不完整的构建也可能导致不完整的安装。

替代设计
-------------------

CMake未实现的替代设计方案。本节旨在简要概述这些方案，并解释为什么它们未被选用于\
CMake的实现。

隐式构建
^^^^^^^^^^^^^^^

隐式构建使用编译时搜索路径执行模块构建，使构建实现更加简单。这确实是一种可以工作\
的方法。然而，CMake的目标将其排除在解决方案之外。

当构建使用搜索目录管理时，编译器会被指示将模块输出文件放置到指定目录中。这些目录\
随后被作为搜索路径提供给任何允许使用其中模块的编译过程。

这种策略可能会遇到与\ `正确构建 <design-goal-correct-builds_>`__\ 目标相关的问题。\
这源于搜索目录中可能存在过时文件的风险。由于构建系统不知道实际正在写入的文件，\
因此很难知道哪些文件可以被删除（例如，使用\ ``ninja -t cleandead``\ 删除\
``ninja``\ 已遇到但不再生成的输出）。如果构建系统除了消费者报告“使用文件 X”之\
不知道输出，那么删除中间文件也可能导致构建卡住。

此外，至少需要对共享输出目录的\ :term:`BMI`\ 生成命令进行某种程度的排序。可以使\
用单独的目录来对模块组进行排序（例如，每个目标一个目录）；否则，同一目录中的模块\
可能无法假设写入共享目录的其他模块会首先完成。如果模块路径根据模块依赖图准确分组，\
那么这离直接指定文件的显式构建只有一小步之遥。

静态扫描
^^^^^^^^^^^^^^^

:term:`fixed build`\ 在生成构建图时执行扫描，并预先包含必要的依赖项。在CMake的\
情况下，它会在生成阶段查看源文件，并将依赖项直接添加到构建图中。这更可能适用于\
同时也是其自身\ :term:`build tool`\ 的\ :term:`build system`，其中构建图操作可以\
协同完成。

无论是否集成，此策略都需要首先使用合适的C++解析器提取信息，或通过工具链合作获取\
信息。虽然模块依赖信息可被较简单的C++解析器获取，但依赖项可能隐藏在预处理器条件\
背后，需要理解这些条件才能确保准确性。当然，选择不支持\ ``import``\ 语句周围的\
预处理器条件也是一种选择，但这可能会严重限制外部库的支持。

对于CMake来说，此策略意味着对感知模块的源文件的任何更改都可能需要触发构建图的重\
新生成。即使是良性编辑，至少也需要触发对已更改导入的 *检查*，但如果没有变化，\
则可以跳过实际重新生成。对于同时也是其自身\ :term:`build tool`\ 的\
:term:`build system`\ 来说，这可能不太关键，但这直接违反了\
`最小化重新生成 <design-goal-minimize-regeneration_>`__\ 目标。

此外，CMake的\ `支持生成的源文件 <design-goal-generated-sources_>`__\ 目标在此\
策略下将无法支持。CMake可以将扫描推迟到生成的文件可用时，但在执行此类扫描之前，\
这些源文件无法编译。这意味着随着源文件变得可用，构建图可能会进行一些无界（但有限）\
次数的重新生成。

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
