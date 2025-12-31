步骤4：深入CMake目标命令
======================================

CMake中有几个目标命令可以用来描述需求。提醒一下，目标命令是应用于目标并修改其属\
性的命令。这些属性描述了构建软件所需的条件，例如源文件、编译标志和输出名称；\
或者描述了使用目标所必需的属性，例如头文件包含、库目录和链接规则。

.. note::
  正如在\ ``Step1``\ 中讨论的那样，构建目标所需的属性应该用\ ``PRIVATE``\
  :ref:`作用域关键字 <Target Command Scope>`\ 来描述，消费目标所需的属性用\
  ``INTERFACE``\ 描述，而两者都需要的属性用\ ``PUBLIC``\ 描述。

在这一步中，我们将介绍CMake中所有可用的目标命令。并非所有目标命令都是相同的。\
我们已经讨论了两个最重要的目标命令：\
:command:`target_sources`\ 和\ :command:`target_link_libraries`。在其余的命令中，\
有些几乎与这两个一样常见，有些具有更高级的应用，还有几个应该只在其他选项不可用时\
作为最后手段使用。

背景
^^^^^^^^^^

在继续深入之前，让我们先列出所有的CMake目标命令。我们将这些命令分为三组：推荐且\
常用的命令、高级及需要注意的命令，以及除非必要否则应避免使用的“危险”命令。

+-----------------------------------------+--------------------------------------+---------------------------------------+
| 常用/推荐                               | 高级/注意                            | 晦涩/危险                             |
+=========================================+======================================+=======================================+
| :command:`target_compile_definitions`   | :command:`get_target_property`       | :command:`target_include_directories` |
| :command:`target_compile_features`      | :command:`set_target_properties`     | :command:`target_link_directories`    |
| :command:`target_link_libraries`        | :command:`target_compile_options`    |                                       |
| :command:`target_sources`               | :command:`target_link_options`       |                                       |
|                                         | :command:`target_precompile_headers` |                                       |
+-----------------------------------------+--------------------------------------+---------------------------------------+

.. note::
    没有所谓的“坏”CMake目标命令。它们都有有效的使用场景。这种分类是为了给新手\
    提供简单的直觉，让他们在解决问题时首先考虑哪些命令。

我们将在接下来的练习中演示大部分命令。我们不会使用的是\ :command:`get_target_property`、\
:command:`set_target_properties`\ 和\ :command:`target_precompile_headers`，\
所以我们在这里简要讨论它们的用途。

:command:`get_target_property`\ 和\ :command:`set_target_properties`\ 命令通过\
名称直接访问目标的属性。它们甚至可以用来为目标附加任意的属性名称。

.. code-block:: cmake

  add_library(Example)
  set_target_properties(Example
    PROPERTIES
      Key Value
      Hello World
  )

  get_target_property(KeyVar Example Key)
  get_target_property(HelloVar Example Hello)

  message("Key: ${KeyVar}")
  message("Hello: ${HelloVar}")

.. code-block:: console

  $ cmake -B build
  ...
  Key: Value
  Hello: World

对CMake语义上有意义的目标属性完整列表记录在\ :manual:`cmake-properties(7)`\ 中，\
但大多数这些属性应该通过它们的专用命令来修改。例如，没有必要直接操作\
``LINK_LIBRARIES``\ 和\ ``INTERFACE_LINK_LIBRARIES``，因为这些由\
:command:`target_link_libraries`\ 处理。

相反，一些较少使用的属性只能通过这些命令访问。用于为目标附加弃用通知的\
:prop_tgt:`DEPRECATION`\ 属性只能通过\ :command:`set_target_properties`\ 设置；\
同样地，用于描述要由CMake的\ ``clean``\ 目标删除的额外文件的\
:prop_tgt:`ADDITIONAL_CLEAN_FILES`\ 也只能通过这种方式设置；以及其他类似的属性。

:command:`target_precompile_headers`\ 命令接受一个头文件列表，类似于\
:command:`target_sources`，并从中创建预编译头文件。这个预编译头文件随后会被强制\
包含到目标中的所有翻译单元中。这对于构建性能来说是有用的。

练习1 - 特性和定义
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

在前面的步骤中，我们警告过不要全局设置\ :variable:`CMAKE_<LANG>_STANDARD`\ 并覆盖\
打包者关于使用哪种语言标准的决定。另一方面，许多库在构建时需要一组最低要求的特性，\
对于这些库，使用\ :command:`target_compile_features`\ 命令来传达这些要求是合适的。

.. code-block:: cmake

  target_compile_features(MyApp PRIVATE cxx_std_20)

:command:`target_compile_features`\ 命令将最低语言标准描述为目标属性。如果\
:variable:`CMAKE_<LANG>_STANDARD`\ 高于此版本，或者编译器默认已提供此语言标准，\
则不采取任何操作。如果需要额外的标志来启用该标准，CMake会添加这些标志。

.. note::
  :command:`target_compile_features`\ 操作的接口和非接口属性与其他目标命令相同。\
  这意味着可以\ *继承*\ 使用\ ``INTERFACE``\ 或\ ``PUBLIC``\ 作用域关键字指定的\
  语言标准要求。

  如果语言特性仅在实现文件中使用，则相应的编译特性应设为\ ``PRIVATE``。如果目标\
  的头文件使用了这些特性，则应使用\ ``PUBLIC``\ 或\ ``INTERFACE``。

对于C++，编译特性的形式为\ ``cxx_std_YY``，其中\ ``YY``\ 是标准化年份，例如\
``14``、\ ``17``、\ ``20``\ 等。

:command:`target_compile_definitions`\ 命令将编译定义描述为目标属性。它是将构建\
配置信息传达给源代码本身的最常见机制。与所有属性一样，我们讨论过的作用域关键字都\
适用。

.. code-block:: cmake

  target_compile_definitions(MyLibrary
    PRIVATE
      MYLIBRARY_USE_EXPERIMENTAL_IMPLEMENTATION

    PUBLIC
      MYLIBRARY_EXCLUDE_DEPRECATED_FUNCTIONS
  )

我们不需要也不希望在使用\ :command:`target_compile_definitions`\ 描述的编译定义\
前附加\ ``-D``\ 前缀。CMake会为当前编译器确定正确的标志。

目标
----

使用\ :command:`target_compile_features`\ 和\ :command:`target_compile_definitions`\
来传达语言标准和编译定义要求。

参考资源
-----------------

* :command:`target_compile_features`
* :command:`target_compile_definitions`
* :command:`option`
* :command:`if`

待编辑文件
-------------

* ``Tutorial/CMakeLists.txt``
* ``MathFunctions/CMakeLists.txt``
* ``MathFunctions/MathFunctions.cxx``
* ``CMakePresets.json``

开始操作
---------------

``Help/guide/tutorial/Step4``\ 目录包含了\ ``Step3``\ 的完整推荐解决方案以及此\
步骤相关的\ ``TODOs``。完成\ ``TODO 1``\ 到\ ``TODO 8``。

构建和运行
-------------

我们可以使用\ ``tutorial``\ 预设运行CMake，然后像往常一样构建。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

验证\ ``Tutorial``\ 的输出是否符合我们对\ ``std::sqrt``\ 的预期。

Solution
--------

First we add a new option to the top-level CML.

.. raw:: html

  <details><summary>TODO 1: Click to show/hide answer</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-TUTORIAL_USE_STD_SQRT
  :language: cmake
  :start-at: option(TUTORIAL_BUILD_UTILITIES
  :end-at: option(TUTORIAL_USE_STD_SQRT

.. raw:: html

  </details>

Then we add the compile feature and definitions to ``MathFunctions``.

.. raw:: html

  <details><summary>TODO 2-3: Click to show/hide answer</summary>

.. literalinclude:: Step5/MathFunctions/CMakeLists.txt
  :caption: TODO 2-3: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_compile_features
  :language: cmake
  :start-at: target_compile_features
  :end-at: endif()

.. raw:: html

  </details>

And the compile feature for ``Tutorial``.

.. raw:: html

  <details><summary>TODO 4: Click to show/hide answer</summary>

.. literalinclude:: Step5/Tutorial/CMakeLists.txt
  :caption: TODO 4: Tutorial/CMakeLists.txt
  :name: Tutorial/CMakeLists.txt-target_compile_features
  :language: cmake
  :start-at: target_compile_features
  :end-at: target_compile_features

.. raw:: html

  </details>

Now we can modify ``MathFunctions`` to take advantage of the new definition.

.. raw:: html

  <details><summary>TODO 5-6: Click to show/hide answer</summary>

.. literalinclude:: Step5/MathFunctions/MathFunctions.cxx
  :caption: TODO 5: MathFunctions/MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-cmath
  :language: c++
  :start-at: cmath
  :end-at: format
  :append: #include <iostream>

.. literalinclude:: Step5/MathFunctions/MathFunctions.cxx
  :caption: TODO 6: MathFunctions/MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-std-sqrt
  :language: c++
  :start-at: double sqrt(double x)
  :end-at: }

.. raw:: html

  </details>

Finally we can update our ``CMakePresets.json``. We don't need to set
``CMAKE_CXX_STANDARD`` anymore, but we do want to try out our new
compile definition.

.. raw:: html

  <details><summary>TODO 7-8: Click to show/hide answer</summary>

.. code-block:: json
  :caption: TODO 7-8: CMakePresets.json
  :name: CMakePresets.json-std-sqrt

  "cacheVariables": {
    "TUTORIAL_USE_STD_SQRT": "ON"
  }

.. raw:: html

  </details>

Exercise 2 - Compile and Link Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes, we need to exercise specific control over the exact options being
passed on the compile and link line. These situations are addressed by
:command:`target_compile_options` and :command:`target_link_options`.

.. code:: cmake

  target_compile_options(MyApp PRIVATE -Wall -Werror)
  target_link_options(MyApp PRIVATE -T LinksScript.ld)

There are several problems with unconditionally calling
:command:`target_compile_options` or :command:`target_link_options`. The primary
problem is compiler flags are specific to the compiler frontend being used. In
order to ensure that our project supports multiple compiler frontends, we must
only pass compatible flags to the compiler.

We can achieve this by checking the :variable:`CMAKE_<LANG>_COMPILER_FRONTEND_VARIANT`
variable which tells us the style of flags supported by the compiler frontend.

.. note::
  Prior to CMake 3.26, :variable:`CMAKE_<LANG>_COMPILER_FRONTEND_VARIANT` was
  only set for compilers with multiple frontend variants. In versions after
  CMake 3.26 checking this variable alone is sufficient.

  However this tutorial targets CMake 3.23. As such, the logic is more
  complicated than we have time for here. This tutorial step already includes
  correct logic for checking the compiler variant for MSVC, GCC, Clang, and
  AppleClang on CMake 3.23.

Even if a compiler accepts the flags we pass, the semantics of compiler flags
change over time. This is especially true with regards to warnings. Projects
should not turn warnings-as-error flags by default, as this can break their
build on otherwise innocuous compiler warnings included in later releases.

.. note::
  For errors and warnings, consider placing flags in :variable:`CMAKE_<LANG>_FLAGS`
  for local development builds and during CI runs (via preset or
  :option:`-D <cmake -D>` flags). We know exactly which compiler and
  toolchain are being used in these contexts, so we can customize the behavior
  precisely without risking build breakages on other platforms.

Goal
----

Add appropriate warning flags to the ``Tutorial`` executable for MSVC-style and
GNU-style compiler frontends.

Helpful Resources
-----------------

* :command:`target_compile_options`

Files to Edit
-------------

* ``Tutorial/CMakeLists.txt``

Getting Started
---------------

Continue editing files in the ``Step4`` directory. The conditional for checking
the frontend variant has already been written. Complete ``TODO 9`` and
``TODO 10`` to add warning flags to ``Tutorial``.

Build and Run
-------------

Since we have already configured for this step, we can build with the usual
command.

.. code-block:: cmake

  cmake --build build

This should reveal a simple warning in the build. You can go ahead and fix it.

Solution
--------

We need to add two compile options to ``Tutorial``, one MSVC-style flag and
one GNU-style flag.

.. raw:: html

  <details><summary>TODO 9-10: Click to show/hide answer</summary>

.. literalinclude:: Step5/Tutorial/CMakeLists.txt
  :caption: TODO 9-10: Tutorial/CMakeLists.txt
  :name: Tutorial/CMakeLists.txt-target_compile_options
  :language: cmake
  :start-at: if(
  :end-at: endif()

.. raw:: html

  </details>

Exercise 3 - Include and Link Directories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::
  This exercise requires building an archive using a compiler directly on the
  command line. It is not used in later steps. It is included only to
  demonstrate a use case for :command:`target_include_directories` and
  :command:`target_link_directories`.

  If you cannot complete this exercise for whatever reason feel free to treat
  it as informational-only, or skip it entirely.

It is generally unnecessary to directly describe include and link directories,
as these requirements are inherited when linking together targets generated
within CMake, or from external dependencies imported into CMake with commands
we will cover in later steps.

If we happen to have some libraries or header files which are not described
by a CMake target which we need to bring into the build, perhaps pre-compiled
binaries provided by a vendor, we can incorporate with the
:command:`target_link_directories` and :command:`target_include_directories`
commands.

.. code-block:: cmake

  target_link_directories(MyApp PRIVATE Vendor/lib)
  target_include_directories(MyApp PRIVATE Vendor/include)


These commands use properties which map to the ``-L`` and ``-I`` compiler flags
(or whatever flags the compiler uses for link and include directories).

Of course, passing a link directory doesn't tell the compiler to link anything
into the build. For that we need :command:`target_link_libraries`. When
:command:`target_link_libraries` is given an argument which does not map to
a target name, it will add the string directly to the link line as a library
to be linked into the build (prepending any appropriate flags, such a ``-l``).

Goal
----

Describe a pre-compiled, vendored, static library and its headers inside a
project using :command:`target_link_directories` and
:command:`target_include_directories`.

Helpful Resources
-----------------

* :command:`target_link_directories`
* :command:`target_include_directories`
* :command:`target_link_libraries`

Files to Edit
-------------

* ``Vendor/CMakeLists.txt``
* ``Tutorial/CMakeLists.txt``

Getting Started
---------------

You will need to build the vendor library into a static archive to complete this
exercise. Navigate to the ``Help/guide/tutorial/Step4/Vendor/lib`` directory
and build the code as appropriate for your platform. On Unix-like operating
systems the appropriate commands are usually:

.. code-block:: console

  g++ -c Vendors.cxx
  ar rvs libVendor.a Vendor.o

Then complete ``TODO 11`` through ``TODO 14``.

.. note::
  ``VendorLib`` is an ``INTERFACE`` library, meaning it has no build requirements
  (because it has already been built). All of its properties should also be
  interface properties.

  We'll discuss ``INTERFACE`` libraries in greater depth during the next step.


Build and Run
-------------

If you have successfully built ``libVendor``, you can rebuild ``Tutorial``
using the normal command.

.. code-block:: console

  cmake --build build

Running ``Tutorial`` should now output a message about the acceptability of the
result to the vendor.

Solution
--------

We need to use the target link and include commands to describe the archive
and its headers as ``INTERFACE`` requirements of ``VendorLib``.

.. raw:: html

  <details><summary>TODO 11-13: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 11-13: Vendor/CMakeLists.txt
  :name: Vendor/CMakeLists.txt

  target_include_directories(VendorLib
    INTERFACE
      include
  )

  target_link_directories(VendorLib
    INTERFACE
      lib
  )

  target_link_libraries(VendorLib
    INTERFACE
      Vendor
  )

.. raw:: html

  </details>

Then we can add ``VendorLib`` to ``Tutorial``'s linked libraries.

.. raw:: html

  <details><summary>TODO 14: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 14: Tutorial/CMakeLists.txt
  :name: Tutorial/CMakeLists.txt-VendorLib

  target_link_libraries(Tutorial
    PRIVATE
      MathFunctions
      VendorLib
  )

.. raw:: html

  </details>
