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

.. warning::

  实现细节不是稳定接口。每个CMake版本都可能修改它们，而不尝试提供兼容性。外部\
  工具链维护者负责为他们支持的每个CMake版本更新其实现。

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
* ``CMAKE_CXX_COMPILE_BMI``：用于从\ :term:`module interface unit`\ 编译\
  :term:`BMI`\ 文件的命令模板。当\ ``CMAKE_CXX_MODULE_BMI_ONLY_FLAG``\ 不能完全\
  添加到对象编译模板时使用。
* ``CMAKE_CXX_MODULE_BMI_ONLY_FLAG``：用于仅从\ :term:`module interface unit`\
  编译\ :term:`BMI`\ 文件的参数。这在从外部项目使用模块时用于编译当前构建中使用的\
  :term:`BMI`\ 文件。

如果工具链不提供\ ``CMAKE_CXX_COMPILE_BMI``\ 或\ ``CMAKE_CXX_MODULE_BMI_ONLY_FLAG``\
变量，它将无法使用由\ ``IMPORTED``\ 目标提供的模块。

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

模块映射服务
^^^^^^^^^^^^^^^^^^^^^^

另一种策略是在构建过程中运行一个服务，作为确定模块放置和发现位置的权威来源。\
编译器被指示向该服务查询诸如“此源正在导出模块X”和“此源正在导入模块Y”之类的问题，\
并分别接收创建或查找\ :term:`BMI`\ 的路径。在这种情况下，服务动态实现整理逻辑。

特别值得注意的是，这与\ `确定性构建 <design-goal-deterministic-builds_>`__\ 和\
`静态通信 <design-goal-static-communication_>`__\ 目标相冲突，因为磁盘上的状态\
可能与实际状态不匹配，并且很难协调\ :term:`build tool`\ 本身的生命周期与服务。\
主要缺少的功能是构建会话开始和结束时的某种信号，以便此类服务能够知道它在什么上下\
文中回答请求。还需要一种方法来恢复会话并检测会话何时失效。CMake今天支持的所有\
:term:`build tool`\ 都没有这些功能。

还有一些与\ `正确构建 <design-goal-correct-builds_>`__\ 目标相冲突的风险。当导入\
模块时，编译器会等待响应后再继续。然而，不能保证该名称的（可见）模块确实存在，\
因此它可能会无限期等待。在等待编译报告它创建该模块时，可能会遇到依赖循环，导致\
编译挂起，直到达到某个资源限制（可能是时间，或者所有可能的模块提供者都没有报告该\
名称的模块）。当这些编译正在等待答案时，存在一个问题：它们如何影响所使用的\
:term:`build tool`\ 的并行度限制？等待答案的编译是否会计入限制并阻止其他编译启动\
以潜在地发现模块？如果不计入，那么这些编译可能占用的其他资源（例如，内存或可用\
文件描述符）怎么办？

可能的未来增强
============================

本节记录了CMake对C++模块支持的可能未来增强。这里的内容不保证将来会实现，且排序\
是任意的。

批量扫描
--------------

可以一次扫描目标中的所有源文件，当源文件共享传递包含时，这应该会更快。这对增量\
构建有副作用，因为目标中任何源文件的更新意味着目标中的所有源文件都会被再次扫描。\
考虑到扫描可以快多少，假设未更改的结果不会触发重新编译，进行这种“额外”扫描应该\
是可以忽略不计的。

BMI修改优化
-----------------------------

目前，与对象文件一样，即使内容没有更改，编译器也总是会更新\ :term:`BMI`\ 文件。\
由于模块增加了“无更改”导致（概念上）不必要重新编译的潜在范围，如果\ :term:`BMI`\
文件没有更改，避免重新编译模块消费者可能会很有用。这可以通过包装编译来实现，\
通过带有\ ``ninja``\ 的\ ``restat = 1``\ 功能的\ ``cmake -E copy_if_different``\
传递来处理\ :term:`BMI`，以避免在\ :term:`BMI`\ 文件实际未更改时重新编译导入器。

.. _`easier-source-specification`:

更简便的源文件指定
---------------------------

CMake模块支持的初始实现采用了“只需列出源文件；CMake 会自行处理”的模式。然而，\
这在与其他元数据要求相关的方面遇到了问题。这些问题是在实现超越“仅构建使用模块的\
代码”的CMake支持时发现的。

与同一目标上的\ `单独BMI生成 <separate-bmi-generation_>`__\ 存在冲突，因为后者\
需要在生成时知道所有生成\ :term:`BMI`\ 的规则。

.. _`separate-bmi-generation`:

单独BMI生成
-----------------------

CMake当前使用单个规则来同时生成编译所需的\ :term:`BMI`\ 和目标文件。至少Clang\
支持直接从\ :term:`BMI`\ 编译生成目标文件。这会带来好处，因为\ :term:`BMI`\ 生成\
通常比编译更快，并且将\ :term:`BMI`\ 生成为单独步骤可以让导入方无需等待目标文件\
生成即可开始编译。

当前实现不支持此功能，因为只有Clang支持直接从\ :term:`BMI`\ 生成目标文件。其他\
编译器要么不支持这种两阶段生成（如GCC），要么需要从源代码重新开始目标文件编译。

与同一目标上的\ `更简便的源文件指定 <easier-source-specification_>`__\ 存在冲突，\
因为CMake必须在生成时（而非构建时）知道所有生成\ :term:`BMI`\ 的源文件，才能创建\
两阶段规则。

模块编译词汇表
===========================

.. glossary::

   BMI
     构建模块接口（Built Module Interface）。编译器生成的C++模块接口的二进制表示，\
     是模块使用者所必需的。文件扩展名因编译器而异。

   CMI
     编译模块接口（Compiled Module Interface）。某些编译器使用的\ :term:`BMI`\
     的替代名称。

   build database
     包含编译命令、模块依赖关系和分组信息的JSON文件。用于IDE集成和构建分析。

   build system
     一种促进软件构建的工具，包含构建组件之间相互关系的模型。例如CMake、Meson、\
     build2等。

   build tool
     构建图执行工具。例如\ `ninja`\ 和\ `make`。有些构建工具同时也是它们自己的\
     :term:`build system`。

   C++ module
     C++20语言特性，用于描述软件组件的API。旨在替代为此目的使用的头文件。

   collate
     从扫描的源代码中聚合模块信息的过程，以确保正确的编译顺序，并为构建的其他\
     部分（例如安装或\ :term:`build database`\ ）提供元数据。

   discovered dependencies
     在处理命令期间发现的不需要显式声明的依赖项。

   dynamic dependencies
     需要单独命令检测的依赖项，以便后续命令的依赖项得到满足。

   embarrassingly parallel
     一组任务，由于它们之间的依赖关系最小，可以轻松划分为许多可以并发执行的独立任务。

   explicit build
     一种构建策略，其中模块依赖项是显式指定的，而不是发现的。

   fixed build
     一种构建策略，其中所有模块依赖项都被计算并直接插入到构建图中。

   header unit
     通过\ ``import``\ 语句而不是\ ``#include``\ 预处理指令使用的头文件。实现\
     可能还提供将\ ``#include``\ 视为\ ``import``\ 的支持。

   implementation unit
     实现模块接口单元中声明的模块实体的C++ :term:`translation unit`。

   implicit build
     一种构建策略，其中模块依赖项是在编译期间通过搜索\ :term:`BMI`\ 文件发现的。

   internal partition unit
     包含分区名称且未从\ :term:`primary module interface unit`\ 导出的\
     :term:`translation unit`。

   module interface unit
     使用\ ``export module``\ 声明模块公共接口的\ :term:`translation unit`。\
     这样的单元可能是也可能不是\ :term:`partition unit`。

   module map
     将模块名称映射到BMI位置的编译器特定文件。

   module visibility
     CMake基于模块声明范围（PUBLIC/PRIVATE）对模块访问规则的强制执行。

   ODR
     单一定义规则（One Definition Rule）。C++要求每个实体在每个程序中恰好定义一次。

   partition unit
     描述带有分区名称的模块的\ :term:`translation unit`\ （即\
     `module MODNAME:PARTITION;`\ ）。分区可能使用也可能不使用\ ``export``\
     关键字。如果使用，则它也是\ :term:`module interface unit`\ ；否则，它是\
     :term:`internal partition unit`。

   primary module interface unit
     导出非\ :term:`partition unit`\ 的命名模块的\ :term:`module interface unit`。

   scan
     分析\ :term:`translation unit`\ 以发现模块导入和导出的过程。

   static build
     在生成时确定所有编译规则的构建配置。

   strong module ownership
     C++实现已确定了一种模型，其中模块“拥有”其中声明的符号。实际上，这意味着模块\
     名称被包含在其中声明的实体符号修饰中。

   synthetic target
     CMake生成的构建目标，用于向模块提供目标的特定用户提供\ :term:`BMIs <BMI>`。

   translation unit
     C++程序编译的最小组件。通常，每个源文件对应一个翻译单元。不使用C++模块的C++\
     源文件可以合并为单个翻译单元。
