步骤10：添加生成器表达式
=====================================

:manual:`Generator expressions <cmake-generator-expressions(7)>` 在生成生成系统期间计算，以生成特定于每个生成配置的信息。

:manual:`Generator expressions <cmake-generator-expressions(7)>` 可以在许多目标属性的上下文中使用，比如 :prop_tgt:`LINK_LIBRARIES`、:prop_tgt:`INCLUDE_DIRECTORIES`、:prop_tgt:`COMPILE_DEFINITIONS` 等等。它们也可以在使用命令填充那些属性时使用，比如 :command:`target_link_libraries`、:command:`target_include_directories`、:command:`target_compile_definitions` 等等。

:manual:`Generator expressions <cmake-generator-expressions(7)>` 可用于启用条件链接、编译时使用的条件定义、条件包含目录等等。这些条件可能基于构建配置、目标属性、平台信息或任何其他可查询的信息。

:manual:`generator expressions <cmake-generator-expressions(7)>` 有不同的类型，包括逻辑表达式、信息表达式和输出表达式。

逻辑表达式用于创建条件输出。基本表达式是 ``0`` 和 ``1`` 表达式。``$<0:...>`` 结果为空字符串，而 ``<1:...>`` 则会生成 ``...``。可以嵌套使用。

:manual:`generator expressions <cmake-generator-expressions(7)>` 的常见用法是有条件地添加编译器标志，例如用于语言级别或警告的标志。一个不错的模式是将此信息关联到允许传播此信息的 ``INTERFACE`` 接口目标。让我们首先构造一个 ``INTERFACE`` 目标，并指定所需的C++标准级别为 ``11``，而非用 :variable:`CMAKE_CXX_STANDARD`。

所以下面的代码：

.. literalinclude:: Step10/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-CXX_STANDARD-variable-remove
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: # control where the static and shared libraries are built so that on windows

会被替换成：

.. literalinclude:: Step11/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-cxx_std-feature
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: # add compiler warning flags just when building this project via


接下来，我们为项目添加所需的编译器警告标志。由于警告标志会根据编译器的不同而变化，因此我们使用 ``COMPILE_LANG_AND_ID`` 生成器表达式来控制在给定的语言和一组编译器id中应用哪些标志，如下所示：

.. literalinclude:: Step11/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-target_compile_options-genex
  :language: cmake
  :start-after: # the BUILD_INTERFACE genex
  :end-before: # control where the static and shared libraries are built so that on windows

我们看到警告标志被封装在 ``BUILD_INTERFACE`` 条件中。这样做是为了使已安装项目的使用者不会继承我们的警告标志。

**练习**：修改 ``MathFunctions/CMakeLists.txt`` ，使所有目标都有一个 :command:`target_link_libraries` 调用 ``tutorial_compiler_flags``。
