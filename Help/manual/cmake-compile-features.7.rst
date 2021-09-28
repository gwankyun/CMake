.. cmake-manual-description: CMake Compile Features Reference

cmake-compile-features(7)
*************************

.. only:: html

   .. contents::

引言
============

项目源代码可能依赖于或有条件地依赖于编译器的某些功能。分别有三种情况：`编译特性需求`_、`可选编译特性`_
以及 `条件编译选项`_。

虽然特性通常在编程语言标准中指定，但CMake提供了一个基于特性的细粒度处理的主要用户界面，而不是引入相应特性的语言标准。

:prop_gbl:`CMAKE_C_KNOWN_FEATURES`、:prop_gbl:`CMAKE_CUDA_KNOWN_FEATURES` 和 :prop_gbl:`CMAKE_CXX_KNOWN_FEATURES` 全局属性包含CMake已知的所有特性，不管编译器是否支持这些特性。 :variable:`CMAKE_C_COMPILE_FEATURES`、:variable:`CMAKE_CUDA_COMPILE_FEATURES` 和 :variable:`CMAKE_CXX_COMPILE_FEATURES` 变量包含CMake知道的编译器所知道的所有特性，不管使用它们需要的语言标准或编译标志。

CMake特性的命名规则与Clang特性测试宏的命名规则相同。也有一些例外，比如CMake使用 ``cxx_final`` 和 ``cxx_override`` 而不是Clang使用的单个 ``cxx_override_control``。

注意，对于 ``OBJC`` 或 ``OBJCXX`` 语言，没有单独的编译特性、属性或变量。它们分别基于 ``C`` 或 ``C++``，因此应该使用它们对应的基本语言的属性和变量。

编译特性需求
============================

Compile feature requirements may be specified with the
:command:`target_compile_features` command.  For example, if a target must
be compiled with compiler support for the
:prop_gbl:`cxx_constexpr <CMAKE_CXX_KNOWN_FEATURES>` feature:

.. code-block:: cmake

  add_library(mylib requires_constexpr.cpp)
  target_compile_features(mylib PRIVATE cxx_constexpr)

In processing the requirement for the ``cxx_constexpr`` feature,
:manual:`cmake(1)` will ensure that the in-use C++ compiler is capable
of the feature, and will add any necessary flags such as ``-std=gnu++11``
to the compile lines of C++ files in the ``mylib`` target.  A
``FATAL_ERROR`` is issued if the compiler is not capable of the
feature.

The exact compile flags and language standard are deliberately not part
of the user interface for this use-case.  CMake will compute the
appropriate compile flags to use by considering the features specified
for each target.

Such compile flags are added even if the compiler supports the
particular feature without the flag. For example, the GNU compiler
supports variadic templates (with a warning) even if ``-std=gnu++98`` is
used.  CMake adds the ``-std=gnu++11`` flag if ``cxx_variadic_templates``
is specified as a requirement.

In the above example, ``mylib`` requires ``cxx_constexpr`` when it
is built itself, but consumers of ``mylib`` are not required to use a
compiler which supports ``cxx_constexpr``.  If the interface of
``mylib`` does require the ``cxx_constexpr`` feature (or any other
known feature), that may be specified with the ``PUBLIC`` or
``INTERFACE`` signatures of :command:`target_compile_features`:

.. code-block:: cmake

  add_library(mylib requires_constexpr.cpp)
  # cxx_constexpr is a usage-requirement
  target_compile_features(mylib PUBLIC cxx_constexpr)

  # main.cpp will be compiled with -std=gnu++11 on GNU for cxx_constexpr.
  add_executable(myexe main.cpp)
  target_link_libraries(myexe mylib)

Feature requirements are evaluated transitively by consuming the link
implementation.  See :manual:`cmake-buildsystem(7)` for more on
transitive behavior of build properties and usage requirements.

.. _`Requiring Language Standards`:

Requiring Language Standards
----------------------------

In projects that use a large number of commonly available features from
a particular language standard (e.g. C++ 11) one may specify a
meta-feature (e.g. ``cxx_std_11``) that requires use of a compiler mode
that is at minimum aware of that standard, but could be greater.
This is simpler than specifying all the features individually, but does
not guarantee the existence of any particular feature.
Diagnosis of use of unsupported features will be delayed until compile time.

For example, if C++ 11 features are used extensively in a project's
header files, then clients must use a compiler mode that is no less
than C++ 11.  This can be requested with the code:

.. code-block:: cmake

  target_compile_features(mylib PUBLIC cxx_std_11)

In this example, CMake will ensure the compiler is invoked in a mode
of at-least C++ 11 (or C++ 14, C++ 17, ...), adding flags such as
``-std=gnu++11`` if necessary.  This applies to sources within ``mylib``
as well as any dependents (that may include headers from ``mylib``).

Availability of Compiler Extensions
-----------------------------------

Because the :prop_tgt:`CXX_EXTENSIONS` target property is ``ON`` by default,
CMake uses extended variants of language dialects by default, such as
``-std=gnu++11`` instead of ``-std=c++11``.  That target property may be
set to ``OFF`` to use the non-extended variant of the dialect flag.  Note
that because most compilers enable extensions by default, this could
expose cross-platform bugs in user code or in the headers of third-party
dependencies.

可选编译特性
=========================

Compile features may be preferred if available, without creating a hard
requirement.   This can be achieved by *not* specifying features with
:command:`target_compile_features` and instead checking the compiler
capabilities with preprocessor conditions in project code.

In this use-case, the project may wish to establish a particular language
standard if available from the compiler, and use preprocessor conditions
to detect the features actually available.  A language standard may be
established by `Requiring Language Standards`_ using
:command:`target_compile_features` with meta-features like ``cxx_std_11``,
or by setting the :prop_tgt:`CXX_STANDARD` target property or
:variable:`CMAKE_CXX_STANDARD` variable.

See also policy :policy:`CMP0120` and legacy documentation on
:ref:`Example Usage <WCDH Example Usage>` of the deprecated
:module:`WriteCompilerDetectionHeader` module.

条件编译选项
===============================

Libraries may provide entirely different header files depending on
requested compiler features.

For example, a header at ``with_variadics/interface.h`` may contain:

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

while a header at ``no_variadics/interface.h`` may contain:

.. code-block:: c++

  template<int I1, int I2 = 0, int I3 = 0, int I4 = 0>
  struct Interface
  {
    static int accumulate() { return I1 + I2 + I3 + I4; }
  };

It may be possible to write an abstraction ``interface.h`` header
containing something like:

.. code-block:: c++

  #ifdef HAVE_CXX_VARIADIC_TEMPLATES
  #include "with_variadics/interface.h"
  #else
  #include "no_variadics/interface.h"
  #endif

However this could be unmaintainable if there are many files to
abstract. What is needed is to use alternative include directories
depending on the compiler capabilities.

CMake provides a ``COMPILE_FEATURES``
:manual:`generator expression <cmake-generator-expressions(7)>` to implement
such conditions.  This may be used with the build-property commands such as
:command:`target_include_directories` and :command:`target_link_libraries`
to set the appropriate :manual:`buildsystem <cmake-buildsystem(7)>`
properties:

.. code-block:: cmake

  add_library(foo INTERFACE)
  set(with_variadics ${CMAKE_CURRENT_SOURCE_DIR}/with_variadics)
  set(no_variadics ${CMAKE_CURRENT_SOURCE_DIR}/no_variadics)
  target_include_directories(foo
    INTERFACE
      "$<$<COMPILE_FEATURES:cxx_variadic_templates>:${with_variadics}>"
      "$<$<NOT:$<COMPILE_FEATURES:cxx_variadic_templates>>:${no_variadics}>"
    )

Consuming code then simply links to the ``foo`` target as usual and uses
the feature-appropriate include directory

.. code-block:: cmake

  add_executable(consumer_with consumer_with.cpp)
  target_link_libraries(consumer_with foo)
  set_property(TARGET consumer_with CXX_STANDARD 11)

  add_executable(consumer_no consumer_no.cpp)
  target_link_libraries(consumer_no foo)

Supported Compilers
===================

CMake is currently aware of the :prop_tgt:`C++ standards <CXX_STANDARD>`
and :prop_gbl:`compile features <CMAKE_CXX_KNOWN_FEATURES>` available from
the following :variable:`compiler ids <CMAKE_<LANG>_COMPILER_ID>` as of the
versions specified for each:

* ``AppleClang``: Apple Clang for Xcode versions 4.4+.
* ``Clang``: Clang compiler versions 2.9+.
* ``GNU``: GNU compiler versions 4.4+.
* ``MSVC``: Microsoft Visual Studio versions 2010+.
* ``SunPro``: Oracle SolarisStudio versions 12.4+.
* ``Intel``: Intel compiler versions 12.1+.

CMake is currently aware of the :prop_tgt:`C standards <C_STANDARD>`
and :prop_gbl:`compile features <CMAKE_C_KNOWN_FEATURES>` available from
the following :variable:`compiler ids <CMAKE_<LANG>_COMPILER_ID>` as of the
versions specified for each:

* all compilers and versions listed above for C++.
* ``GNU``: GNU compiler versions 3.4+

CMake is currently aware of the :prop_tgt:`C++ standards <CXX_STANDARD>` and
their associated meta-features (e.g. ``cxx_std_11``) available from the
following :variable:`compiler ids <CMAKE_<LANG>_COMPILER_ID>` as of the
versions specified for each:

* ``Cray``: Cray Compiler Environment version 8.1+.
* ``Fujitsu``: Fujitsu HPC compiler 4.0+.
* ``PGI``: PGI version 12.10+.
* ``NVHPC``: NVIDIA HPC compilers version 11.0+.
* ``TI``: Texas Instruments compiler.
* ``XL``: IBM XL version 10.1+.

CMake is currently aware of the :prop_tgt:`C standards <C_STANDARD>` and
their associated meta-features (e.g. ``c_std_99``) available from the
following :variable:`compiler ids <CMAKE_<LANG>_COMPILER_ID>` as of the
versions specified for each:

* all compilers and versions listed above with only meta-features for C++.

CMake is currently aware of the :prop_tgt:`CUDA standards <CUDA_STANDARD>` and
their associated meta-features (e.g. ``cuda_std_11``) available from the
following :variable:`compiler ids <CMAKE_<LANG>_COMPILER_ID>` as of the
versions specified for each:

* ``Clang``: Clang compiler 5.0+.
* ``NVIDIA``: NVIDIA nvcc compiler 7.5+.
