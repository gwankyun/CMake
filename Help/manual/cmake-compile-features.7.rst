.. cmake-manual-description: CMake Compile Features Reference

cmake-compile-features(7)
*************************

.. only:: html

   .. contents::

引言
============

项目源代码可能依赖于或有条件地依赖于编译器的某些功能。分别有三种情况：\ `编译特性需求`_、\
`可选编译特性`_\ 以及\ `条件编译选项`_。

虽然特性通常在编程语言标准中指定，但CMake提供了一个基于特性的细粒度处理的主要用户界面，而不\
是引入相应特性的语言标准。

:prop_gbl:`CMAKE_C_KNOWN_FEATURES`、:prop_gbl:`CMAKE_CUDA_KNOWN_FEATURES`\ 和\
:prop_gbl:`CMAKE_CXX_KNOWN_FEATURES`\ 全局属性包含CMake已知的所有特性，\
不管编译器是否支持这些特性。:variable:`CMAKE_C_COMPILE_FEATURES`、\
:variable:`CMAKE_CUDA_COMPILE_FEATURES`\ 和\ :variable:`CMAKE_CXX_COMPILE_FEATURES`\
变量包含CMake知道的编译器所知道的所有特性，不管使用它们需要的语言标准或编译标志。

CMake特性的命名规则与Clang特性测试宏的命名规则相同。也有一些例外，比如CMake使用\
``cxx_final``\ 和\ ``cxx_override``\ 而不是Clang使用的单个\ ``cxx_override_control``。

注意，对于\ ``OBJC``\ 或\ ``OBJCXX``\ 语言，没有单独的编译特性、属性或变量。它们分别基于\
``C``\ 或\ ``C++``，因此应该使用它们对应的基本语言的属性和变量。

编译特性需求
============================

编译特性需求可以通过\ :command:`target_compile_features`\ 命令指定。例如，假设一个目标\
必须在编译器的\ :prop_gbl:`cxx_constexpr <CMAKE_CXX_KNOWN_FEATURES>`\ 特性支持下编译：

.. code-block:: cmake

  add_library(mylib requires_constexpr.cpp)
  target_compile_features(mylib PRIVATE cxx_constexpr)

在处理\ ``cxx_constexpr``\ 特性需求时，:manual:`cmake(1)`\ 将确保正在使用的C++编译器\
能够实现该特性，并将在\ ``mylib``\ 目标中的C++文件的编译命令中添加任何必要的标志，例如\
``-std=gnu++11``。如果编译器不能实现该特性，则引发\ ``FATAL_ERROR``。

准确的编译标志和语言标准并不是这个用例的用户界面的一部分。CMake将计算每个目标指定的特性来得\
出适当编译标志。

即使编译器没有该特定特性的标志，也会添加这样的编译标志。例如，即使使用了\ ``-std=gnu++98``, \
GNU编译器也支持可变参数模板（带有警告）。如果\ ``cxx_variadic_templates``\ 被指定为需求，\
CMake会添加\ ``-std=gnu++11``\ 标志。

在上面的例子中，``mylib``\ 在自己构建时需要\ ``cxx_constexpr``，但是\ ``mylib``\ 的消\
费者不需要使用支持\ ``cxx_constexpr``\ 的编译器。如果\ ``mylib``\ 的接口确实需要\
``cxx_constexpr``\ 特性（或任何其他已知特性），则可以使用\
:command:`target_compile_features`\ 的\ ``PUBLIC``\ 或\ ``INTERFACE``\ 签名来指定：

.. code-block:: cmake

  add_library(mylib requires_constexpr.cpp)
  # cxx_constexpr is a usage-requirement
  target_compile_features(mylib PUBLIC cxx_constexpr)

  # main.cpp will be compiled with -std=gnu++11 on GNU for cxx_constexpr.
  add_executable(myexe main.cpp)
  target_link_libraries(myexe mylib)

特性需求是通过消费链接实现来计算的。请参阅\ :manual:`cmake-buildsystem(7)`\ 了解更多关\
于构建属性和使用需求的传递行为。

.. _`Requiring Language Standards`:

指定语言标准
----------------------------

在使用大量来自特定语言标准（如C++ 11）的通用特性的项目中，可以指定一个元特性（如\
``cxx_std_11``），该元特性需要使用最低限度但可能更高的知道该标准的编译器模式。这比单独指定\
所有特性要简单，但这不能保证任何特定特性的存在。对不受支持特性的使用的诊断将延迟到编译时。

例如，如C++ 11特性在项目的头文件中广泛使用，那么客户端必须使用不低于C++ 11的编译器模式。代\
码中可以这样指定：

.. code-block:: cmake

  target_compile_features(mylib PUBLIC cxx_std_11)

在这个例子中，CMake将确保编译器以至少C++ 11（或C++ 14、c++ 17等等）的模式调用，并在必要时\
添加诸如\ ``-std=gnu++11``\ 的标志。这适用于\ ``mylib``\ 中的源文件以及任何依赖文件\
（可能包括来自\ ``mylib``\ 的头文件）。

.. include:: ../prop_gbl/CMAKE_LANG_STD_FLAGS.txt

编译器扩展是否可用
-----------------------------------

:prop_tgt:`<LANG>_EXTENSIONS`\ 目标属性默认为编译器的默认值（参见\
:variable:`CMAKE_<LANG>_EXTENSIONS_DEFAULT`）。注意，因为大多数编译器默认启用扩展，这\
可能会暴露用户代码或第三方依赖项头中的可移植性错误。

:prop_tgt:`<LANG>_EXTENSIONS`\ 默认设置为\ ``ON``。可查阅\ :policy:`CMP0128`。

可选编译特性
=========================

如果可以的话，编译特性可能是首选，而不是硬性需求。这可以通过\ *不*\ 使用\
:command:`target_compile_features`\ 指定特性，而是在项目代码中使用预处理器条件检查编译\
器功能来实现。

在这个用例中，如果编译器提供，项目可能希望建立一个特定的语言标准，并使用预处理器条件来检测实\
际可用的特性。语言标准可以通过\ `指定语言标准`_\ 使用带有\ ``cxx_std_11``\ 等元特性的\
:command:`target_compile_features`\ 来建立，或者通过设置\ :prop_tgt:`CXX_STANDARD`\
目标属性或\ :variable:`CMAKE_CXX_STANDARD`\ 变量。

请参考\ :policy:`CMP0120`\ 和已弃用的\ :module:`WriteCompilerDetectionHeader`\
模块的\ :ref:`示例用法 <WCDH Example Usage>`\ 的遗留文档。

条件编译选项
===============================

库可以根据所请求的编译器特性提供完全不同的头文件。

例如，``with_variadics/interface.h``\ 头文件可能包含：

.. code-block:: c++

  template<int I, int... Is>
  struct Interface;

  template<int I>
  struct Interface<I>
  {
    static int accumulate()
    {
      return I;
    }
  };

  template<int I, int... Is>
  struct Interface
  {
    static int accumulate()
    {
      return I + Interface<Is...>::accumulate();
    }
  };

而\ ``no_variadics/interface.h``\ 头文件可能包含：

.. code-block:: c++

  template<int I1, int I2 = 0, int I3 = 0, int I4 = 0>
  struct Interface
  {
    static int accumulate() { return I1 + I2 + I3 + I4; }
  };

可以抽象出一个\ ``interface.h``\ 头文件，其中包含如下内容：

.. code-block:: c++

  #ifdef HAVE_CXX_VARIADIC_TEMPLATES
  #include "with_variadics/interface.h"
  #else
  #include "no_variadics/interface.h"
  #endif

然而，如果有许多文件要抽象，这也许难以维护。我们需要的是根据编译器的能力使用替代的include目录。

CMake提供了一个\ ``COMPILE_FEATURES``\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 来实现这些条件。这可以与诸如\
:command:`target_include_directories`\ 和\ :command:`target_link_libraries`\ 这\
样的构建属性命令一起使用，以设置适当的\ :manual:`构建系统 <cmake-buildsystem(7)>`\ 属性：

.. code-block:: cmake

  add_library(foo INTERFACE)
  set(with_variadics ${CMAKE_CURRENT_SOURCE_DIR}/with_variadics)
  set(no_variadics ${CMAKE_CURRENT_SOURCE_DIR}/no_variadics)
  target_include_directories(foo
    INTERFACE
      "$<$<COMPILE_FEATURES:cxx_variadic_templates>:${with_variadics}>"
      "$<$<NOT:$<COMPILE_FEATURES:cxx_variadic_templates>>:${no_variadics}>"
    )

然后使用代码简单地像往常一样链接到\ ``foo``\ 目标，并使用适合特性的include目录。

.. code-block:: cmake

  add_executable(consumer_with consumer_with.cpp)
  target_link_libraries(consumer_with foo)
  set_property(TARGET consumer_with CXX_STANDARD 11)

  add_executable(consumer_no consumer_no.cpp)
  target_link_libraries(consumer_no foo)

支持的编译器
===================

CMake目前知道的\ :prop_tgt:`C++标准 <CXX_STANDARD>`\ 和\
:prop_gbl:`编译特性 <CMAKE_CXX_KNOWN_FEATURES>`，可以从以下\
:variable:`编译器标识 <CMAKE_<LANG>_COMPILER_ID>`\ 中获取，每个编译器相关版本如下：

* ``AppleClang``: Apple Clang for Xcode 版本 4.4+。
* ``Clang``: Clang 编译器版本 2.9+。
* ``GNU``: GNU 编译器版本 4.4+。
* ``MSVC``: Microsoft Visual Studio 版本 2010+。
* ``SunPro``: Oracle SolarisStudio 版本 12.4+。
* ``Intel``: Intel 编译器版本 12.1+。

CMake目前知道的\ :prop_tgt:`C标准 <C_STANDARD>`\ 和\
:prop_gbl:`编译特性 <CMAKE_C_KNOWN_FEATURES>`，可以从以下\
:variable:`编译器标识 <CMAKE_<LANG>_COMPILER_ID>`\ 中获取，每个编译器相关版本如下：

* 以上列出的所有C++编译器及版本。
* ``GNU``: GNU 编译器版本 3.4+。

CMake目前知道的\ :prop_tgt:`C++标准 <CXX_STANDARD>`\ 及其相关的元特性（例如\
``cxx_std_11``），这些元特性可以从以下\
:variable:`编译器标识 <CMAKE_<LANG>_COMPILER_ID>`\ 中获得：

* ``Cray``: Cray 编译器环境版本 8.1+。
* ``Fujitsu``: 富士通 HPC 编译器 4.0+。
* ``PGI``: PGI 版本 12.10+。
* ``NVHPC``: NVIDIA HPC 编译器版本 11.0+。
* ``TI``: 德州仪器编译器。
* ``TIClang``: 德州仪器基于 Clang 的编译器.
* ``XL``: IBM XL 版本 10.1+。

CMake目前知道的\ :prop_tgt:`C标准 <C_STANDARD>`\ 及其相关的元特性（例如\ ``c_std_99``）\
可以从以下\ :variable:`编译器标识 <CMAKE_<LANG>_COMPILER_ID>`\ 中获得，每个编译器相关\
版本如下：

* 上面列的所有编译器及版本，只有C++的元特性。

CMake目前知道的\ :prop_tgt:`CUDA标准 <CUDA_STANDARD>`\ 及其相关的元特性（例如\
``cuda_std_11``），可以从以下\ :variable:`编译器标识 <CMAKE_<LANG>_COMPILER_ID>`\
中获取每个标准相关版本：

* ``Clang``: Clang 编译器 5.0+。
* ``NVIDIA``: NVIDIA nvcc 编译器 7.5+。

.. _`Language Standard Flags`:

语言标准标志
=======================

为了满足\ :command:`target_compile_features`\ 命令或\
:variable:`CMAKE_<LANG>_STANDARD`\ 变量指定的要求，CMake可以向编译器传递一个语言标准标\
志，例如\ ``-std=c++11``。

对于\ :ref:`Visual Studio Generators`，CMake不能精确地控制编译器命令行上语言标准标志的\
位置。对于\ :ref:`Ninja Generators`、:ref:`Makefile Generators`\ 和\
:generator:`Xcode`, CMake将语言标准标志放在\ :variable:`CMAKE_<LANG>_FLAGS`\和\
:variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`\ 的语言范围标志之后。

.. versionchanged:: 3.26
  语言标准标志被放置在其他抽象指定的标志之前，例如\ :command:`target_compile_options`\
  命令。在CMake 3.26之前，语言标准标志放在它们之后。
