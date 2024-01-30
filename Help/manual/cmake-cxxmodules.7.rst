.. cmake-manual-description: CMake C++ Modules Support Reference

cmake-cxxmodules(7)
*******************

.. versionadded:: 3.28

C++ 20引入了“模块”的概念。该设计要求构建系统之间对编译进行排序，以可靠地满足\ ``import``\
语句。CMake的实现要求编译器在构建过程中扫描源文件中的模块依赖，整理扫描结果来推断排序约束，\
并告诉构建工具如何动态更新构建图。

扫描控制
================

是否扫描源代码以查找C++模块的使用情况取决于以下查询。使用第一个提供yes/no答案的查询。

- 如果源文件属于\ ``CXX_MODULES``\ 类型的文件集，则会对其进行扫描。
- 如果目标不使用至少C++ 20，则不会对其进行扫描。
- 如果源文件不是\ ``CXX``\ 语言，它将不会被扫描。
- 如果设置了\ :prop_sf:`CXX_SCAN_FOR_MODULES`\ 源文件属性，则将使用其值。
- 如果设置了\ :variable:`CMAKE_CXX_SCAN_FOR_MODULES`\ 目标属性，则将使用其值。设置\
  :variable:`CMAKE_CXX_SCAN_FOR_MODULES`\ 变量，以便在创建所有目标时初始化该属性。
- 否则，将在编译器和生成器支持的前提下，扫描源文件。参见策略\ :policy:`CMP0155`。

Note that any scanned source will be excluded from any unity build (see
:prop_tgt:`UNITY_BUILD`) because module-related statements can only happen at
one place within a C++ translation unit.

编译器支持
================

CMake原生支持模块依赖扫描的编译器包括：

* MSVC工具集14.34及更新版本（与Visual Studio 17.4及更新版本一起提供）
* LLVM/Clang 16.0及更新版本
* GCC 14（对于开发分支，2023-09-20之后）及更新版本

生成器支持
=================

支持扫描C++模块源的生成器列表包括：

- :generator:`Ninja`
- :generator:`Ninja Multi-Config`
- :generator:`Visual Studio 17 2022`

限制
-----------

在CMake中，当前的C++模块支持有许多已知的限制。这没有记录已知的限制或编译器中的这些bug会随着\
时间的推移而改变。

对于所有生成器：

- 不支持标头单元。
- 没有对\ ``import std;``\ 的内置支持，或者是其他编译器提供的模块。

对于Ninja生成器：

- 需要\ ``ninja`` 1.11或更新版本。

对于\ :ref:`Visual Studio Generators`：

- 仅支持Visual Studio 2022和MSVC工具集14.34（Visual Studio 17.4）及更新版本。
- 不支持导出或安装BMI或模块信息。
- 不支持用C++模块从\ ``IMPORTED``\ 的目标编译BMI。
- 没有从\ ``PUBLIC``\ 模块源中使用\ ``PRIVATE``\ 源提供的模块诊断。
