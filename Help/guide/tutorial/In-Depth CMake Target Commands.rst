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

* ``CMakeLists.txt``
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

解决方案
--------

首先，我们在顶层CML中添加一个新选项。

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-TUTORIAL_USE_STD_SQRT
  :language: cmake
  :start-at: option(TUTORIAL_BUILD_UTILITIES
  :end-at: option(TUTORIAL_USE_STD_SQRT

.. raw:: html

  </details>

然后，我们将编译特性和定义添加到\ ``MathFunctions``。

.. raw:: html

  <details><summary>TODO 2-3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/MathFunctions/CMakeLists.txt
  :caption: TODO 2-3: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_compile_features
  :language: cmake
  :start-at: target_compile_features
  :end-at: endif()

.. raw:: html

  </details>

以及\ ``Tutorial``\ 的编译特性。

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/Tutorial/CMakeLists.txt
  :caption: TODO 4: Tutorial/CMakeLists.txt
  :name: Tutorial/CMakeLists.txt-target_compile_features
  :language: cmake
  :start-at: target_compile_features
  :end-at: target_compile_features

.. raw:: html

  </details>

现在我们可以修改\ ``MathFunctions``\ 以利用新定义。

.. raw:: html

  <details><summary>TODO 5-6: 点击显示/隐藏答案</summary>

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

最后，我们可以更新\ ``CMakePresets.json``。我们不再需要设置\ ``CMAKE_CXX_STANDARD``，\
但我们想要尝试新的编译定义。

.. raw:: html

  <details><summary>TODO 7-8: 点击显示/隐藏答案</summary>

.. code-block:: json
  :caption: TODO 7-8: CMakePresets.json
  :name: CMakePresets.json-std-sqrt

  "cacheVariables": {
    "TUTORIAL_USE_STD_SQRT": "ON"
  }

.. raw:: html

  </details>

练习2 - 编译和链接选项
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

有时，我们需要对编译和链接命令行中传递的确切选项进行特定控制。这些情况可以通过\
:command:`target_compile_options`\ 和\ :command:`target_link_options`\ 来解决。

.. code:: cmake

  target_compile_options(MyApp PRIVATE -Wall -Werror)
  target_link_options(MyApp PRIVATE -T LinksScript.ld)

无条件调用\ :command:`target_compile_options`\ 或\ :command:`target_link_options`\
存在几个问题。主要问题是编译器标志特定于所使用的编译器前端。为了确保我们的项目支\
持多个编译器前端，我们必须只向编译器传递兼容的标志。

我们可以通过检查\ :variable:`CMAKE_<LANG>_COMPILER_FRONTEND_VARIANT`\ 变量来实现\
这一点，该变量告诉我们编译器前端支持的标志风格。

.. note::
  在CMake 3.26之前，\ :variable:`CMAKE_<LANG>_COMPILER_FRONTEND_VARIANT`\ 仅针对\
  具有多个前端变体的编译器设置。在CMake 3.26之后的版本中，仅检查此变量就足够了。

  然而，本教程针对的是CMake 3.23。因此，逻辑比我们在这里有时间讨论的要复杂。\
  本教程步骤已经包含了在CMake 3.23上检查MSVC、GCC、Clang和AppleClang编译器变体的\
  正确逻辑。

即使编译器接受我们传递的标志，编译器标志的语义也会随时间变化。对于警告而言尤其\
如此。项目默认不应启用“警告视为错误”标志，因为这可能会在后续版本中包含的其他无害\
编译器警告上导致构建失败。

.. note::
  对于错误和警告，请考虑在本地开发构建和CI运行期间（通过预设或\
  :option:`-D <cmake -D>`\ 标志）将标志放在\ :variable:`CMAKE_<LANG>_FLAGS`\ 中。\
  我们确切知道在这些上下文中使用的是哪种编译器和工具链，因此我们可以精确地自定义\
  行为，而不会有在其他平台上导致构建失败的风险。

目标
----

为MSVC风格和GNU风格的编译器前端向\ ``Tutorial``\ 可执行文件添加适当的警告标志。

参考资源
-----------------

* :command:`target_compile_options`

待编辑文件
-------------

* ``Tutorial/CMakeLists.txt``

开始操作
---------------

继续编辑\ ``Step4``\ 目录中的文件。检查前端变体的条件语句已经编写完成。完成\
``TODO 9``\ 和\ ``TODO 10``，为\ ``Tutorial``\ 添加警告标志。

构建和运行
-------------

由于我们已经为此步骤进行了配置，因此可以使用常用命令进行构建。

.. code-block:: cmake

  cmake --build build

这应该会在构建过程中显示一个简单的警告。你可以继续修复它。

解决方案
--------

我们需要为\ ``Tutorial``\添 加两个编译选项，一个是MSVC风格的标志，另一个是GNU\
风格的标志。

.. raw:: html

  <details><summary>TODO 9-10: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/Tutorial/CMakeLists.txt
  :caption: TODO 9-10: Tutorial/CMakeLists.txt
  :name: Tutorial/CMakeLists.txt-target_compile_options
  :language: cmake
  :start-at: if(
  :end-at: endif()

.. raw:: html

  </details>

练习3 - 包含和链接目录
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::
  本练习需要使用编译器直接在命令行上构建存档。它不会在后续步骤中使用，仅用于演示\
  :command:`target_include_directories`\ 和\ :command:`target_link_directories`\
  的用例。

  如果由于某种原因无法完成本练习，可以将其视为仅提供信息的内容，或者完全跳过

通常不需要直接描述包含目录和链接目录，因为这些要求会在链接CMake内部生成的目标或\
从外部依赖项（我们将在后续步骤中介绍的命令导入到CMake中）时被继承。

如果我们恰好有一些未被CMake目标描述但需要引入构建的库或头文件，比如供应商提供的\
预编译二进制文件，我们可以使用\ :command:`target_link_directories`\ 和\
:command:`target_include_directories`\ 命令来整合它们。

.. code-block:: cmake

  target_link_directories(MyApp PRIVATE Vendor/lib)
  target_include_directories(MyApp PRIVATE Vendor/include)


这些命令使用的属性映射到\ ``-L``\ 和\ ``-I``\ 编译器标志（或编译器用于链接目录和\
包含目录的任何标志）。

当然，传递链接目录并不会告诉编译器将任何内容链接到构建中。为此，我们需要\
:command:`target_link_libraries`。当\ :command:`target_link_libraries`\ 获得一个\
不映射到目标名称的参数时，它会将该字符串直接添加到链接行中，作为要链接到构建中\
的库（添加任何适当的标志，如\ ``-l``）。

目标
----

描述如何在项目中使用预编译的、供应商提供的静态库及其头文件，使用\
:command:`target_link_directories`\ 和\ :command:`target_include_directories`\
命令。

参考资源
-----------------

* :command:`target_link_directories`
* :command:`target_include_directories`
* :command:`target_link_libraries`

待编辑文件
-------------

* ``Vendor/CMakeLists.txt``
* ``Tutorial/CMakeLists.txt``

开始操作
---------------

要完成本练习，你需要将供应商库构建为静态存档。导航到\
``Help/guide/tutorial/Step4/Vendor/lib``\ 目录，并根据你的平台构建代码。

在类Unix系统上，GCC工具链的典型命令如下：

.. code-block:: console

  g++ -c Vendor.cxx
  ar rvs libVendor.a Vendor.o

同样，在Windows上，MSVC工具链的示例命令如下：

.. code-block:: console

  cl -c Vendor.cxx
  lib -out:Vendor.lib Vendor.obj

在这里，由于你直接调用\ ``cl``\ 和\ ``lib``，请确保使用与本CMake项目相同目标架构\
的Visual Studio开发人员命令提示符。

然后完成\ ``TODO 11``\ 到\ ``TODO 14``

.. note::
  ``VendorLib``\ 是一个\ ``INTERFACE``\ 库，这意味着它没有构建要求（因为它已经被\
  构建）。它的所有属性也应该是接口属性。

  我们将在下一步更深入地讨论\ ``INTERFACE``\ 库。


构建和运行
-------------

如果你已成功构建\ ``libVendor``，可以使用常规命令重新构建\ ``Tutorial``。

.. code-block:: console

  cmake --build build

现在运行\ ``Tutorial``\ 应该会输出一条关于结果对供应商是否可接受的消息。

解决方案
--------

我们需要使用目标链接和包含命令，将存档及其头文件描述为\ ``VendorLib``\ 的\
``INTERFACE``\ 要求。

.. raw:: html

  <details><summary>TODO 11-13: 点击显示/隐藏答案</summary>

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

然后我们可以将\ ``VendorLib``\ 添加到\ ``Tutorial``\ 的链接库中。

.. raw:: html

  <details><summary>TODO 14: 点击显示/隐藏答案</summary>

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
