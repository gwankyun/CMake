步骤3：配置和缓存变量
=========================================

CMake项目通常有一些用户和打包者感兴趣的项目特定配置变量。CMake有多种方式可以让调\
用用户或进程传递这些配置选择，但其中最基本的方式是\ :option:`-D <cmake -D>`\ 标志。

在这一步中，我们将深入探讨如何在CML文件中提供项目配置选项，以及如何调用CMake来\
利用CMake和各个项目提供的配置选项。

背景
^^^^^^^^^^

如果我们有一个支持多种压缩算法的压缩软件CMake项目，我们可能希望让项目的打包者在\
构建我们的软件时决定启用哪些算法。我们可以通过使用\ :option:`-D <cmake -D>`\
标志设置的变量来实现这一点。

.. code-block:: cmake

  if(COMPRESSION_SOFTWARE_USE_ZLIB)
    message("I will use Zlib!")
    # ...
  endif()

  if(COMPRESSION_SOFTWARE_USE_ZSTD)
    message("I will use Zstd!")
    # ...
  endif()

.. code-block:: console

  $ cmake -B build \
      -DCOMPRESSION_SOFTWARE_USE_ZLIB=ON \
      -DCOMPRESSION_SOFTWARE_USE_ZSTD=OFF
  ...
  I will use Zlib!

当然，我们会希望为这些配置选项提供合理的默认值，并提供一种方式来传达给定选项的\
目的。这个功能由\ :command:`option`\ 命令提供。

.. code-block:: cmake

  option(COMPRESSION_SOFTWARE_USE_ZLIB "Support Zlib compression" ON)
  option(COMPRESSION_SOFTWARE_USE_ZSTD "Support Zstd compression" ON)

  if(COMPRESSION_SOFTWARE_USE_ZLIB)
    # Same as before
  # ...

.. code-block:: console

  $ cmake -B build \
      -DCOMPRESSION_SOFTWARE_USE_ZLIB=OFF
  ...
  I will use Zstd!

由\ :option:`-D <cmake -D>`\ 标志和\ :command:`option`\ 创建的名称不是普通变量，\
它们是\ **缓存**\ 变量。缓存变量是全局可见的变量，它们是\ *粘性的*，一旦初始设置\
后就很难更改其值。实际上它们非常粘性，在项目模式下，CMake会在多次配置之间保存和\
恢复缓存变量。如果一个缓存变量被设置一次，它将一直存在，直到另一个\
:option:`-D <cmake -D>`\ 标志抢占已保存的变量。

.. note::
  CMake本身有几十个用于配置的普通变量和缓存变量。这些变量在\
  :manual:`cmake-variables(7)`\ 中有文档记录，并且与项目提供的配置变量以相同的\
  方式操作。

:command:`set`\ 也可以用来操作缓存变量，但它不会改变已经创建的变量。

.. code-block:: cmake

  set(StickyCacheVariable "I will not change" CACHE STRING "")
  set(StickyCacheVariable "Overwrite StickyCache" CACHE STRING "")

  message("StickyCacheVariable: ${StickyCacheVariable}")

.. code-block:: console

  $ cmake -P StickyCacheVariable.cmake
  StickyCacheVariable: I will not change

由于\ :option:`-D <cmake -D>`\ 标志在任何其他命令之前处理，它们在设置缓存变量的\
值时具有优先权。

.. code-block:: console

  $ cmake \
    -DStickyCacheVariable="Commandline always wins" \
    -P StickyCacheVariable.cmake
  StickyCacheVariable: Commandline always wins

虽然缓存变量通常不能被更改，但它们可以被普通变量\ *遮蔽*。我们可以通过\
:command:`set`\ 一个与缓存变量同名的变量，然后使用\ :command:`unset`\ 删除普通\
变量来观察这一点。

.. code-block:: cmake

  set(ShadowVariable "In the shadows" CACHE STRING "")
  set(ShadowVariable "Hiding the cache variable")
  message("ShadowVariable: ${ShadowVariable}")

  unset(ShadowVariable)
  message("ShadowVariable: ${ShadowVariable}")

.. code-block:: console

  $ cmake -P ShadowVariable.cmake
  ShadowVariable: Hiding the cache variable
  ShadowVariable: In the shadows

练习1 - 使用选项
^^^^^^^^^^^^^^^^^^^^^^^^^^

我们可以想象一个场景：消费者真正想要的是我们的\ ``MathFunctions``\ 库，而\
``Tutorial``\ 工具只是一个可选的附加组件。在这种情况下，我们可能想要添加一个选项，\
允许消费者禁用构建\ ``Tutorial``\ 二进制文件，只构建\ ``MathFunctions``\ 库。

凭借我们对选项、条件语句和缓存变量的了解，我们已经拥有了实现这种配置所需的所有要素。

目标
----

添加一个名为\ ``TUTORIAL_BUILD_UTILITIES``\ 的选项，用于控制是否配置和构建\
``Tutorial``\ 二进制文件。

.. note::
  CMake允许我们在配置后确定要构建哪些目标。我们的用户可以单独请求\ ``MathFunctions``\
  库而不包含\ ``Tutorial``。CMake也有机制可以将目标排除在\ ``ALL``\ （构建所有\
  其他可用目标的默认目标）之外。

  然而，完全从配置中排除目标的选项是方便且受欢迎的，特别是如果配置这些目标涉及\
  可能需要一些时间的重量级步骤。

  它还简化了\ :command:`install()`\ 逻辑（我们将在后面的步骤中讨论），如果打包者\
  不感兴趣的目标被完全排除。

参考资源
-----------------

* :command:`option`
* :command:`if`

待编辑文件
-------------

* ``CMakeLists.txt``

开始操作
---------------

``Help/guide/tutorial/Step3``\ 文件夹包含了\ ``Step1``\ 的完整推荐解决方案以及\
本步骤的相关\ ``TODO``\ 任务。请花一点时间回顾并重新熟悉\ ``Tutorial``\ 项目。

当你认为已经理解当前代码后，请从\ ``TODO 1``\ 开始，完成到\ ``TODO 2``。

构建和运行
-------------

现在我们可以重新配置项目了。不过，这次我们希望通过\ :option:`-D <cmake -D>`\
标志来控制配置。我们再次导航到\ ``Help/guide/tutorial/Step3``\ 并调用 CMake，\
但这次添加我们的配置选项。

.. code-block:: console

  cmake -B build -DTUTORIAL_BUILD_UTILITIES=OFF

现在我们可以像平常一样构建。

.. code-block:: console

  cmake --build build

构建后，我们应该观察到没有生成 Tutorial 可执行文件。由于缓存变量是粘性的，即使\
重新配置也不会改变这一点，尽管该选项默认为\ ``ON``。

.. code-block:: console

  cmake -B build
  cmake --build build

不会生成Tutorial可执行文件，因为缓存变量已“锁定”。要更改这一点，我们有两个选择。\
首先，我们可以编辑在CMake配置运行之间存储缓存变量的文件，即“CMake Cache”。这个\
文件是\ ``build/CMakeCache.txt``，在其中我们可以找到选项缓存变量。

.. code-block:: text

  //Build the Tutorial executable
  TUTORIAL_BUILD_UTILITIES:BOOL=OFF

我们可以将其从\ ``OFF``\ 更改为\ ``ON``，重新运行构建，这样我们就会得到\
``Tutorial``\ 可执行文件。

.. note::
  ``CMakeCache.txt``\ 条目格式为\ ``<Name>:<Type>=<Value>``，但是“类型”只是一个\
  提示。CMake中的所有对象都是字符串，无论缓存中显示什么。

或者，我们可以在命令行上更改缓存变量的值，因为命令行在\ ``CMakeCache.txt``\
加载之前运行，所以其值优先级高于缓存文件中的值。

.. code-block:: console

  cmake -B build -DTUTORIAL_BUILD_UTILITIES=ON
  cmake --build build

这样做后，我们可以观察到\ ``CMakeCache.txt``\ 中的值已从\ ``OFF``\ 切换为\ ``ON``，\
并且\ ``Tutorial``\ 可执行文件已构建完成。

解决方案
--------

首先，我们创建一个\ :command:`option`\ 来为我们的缓存变量提供合理的默认值。

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-option-TUTORIAL_BUILD_UTILITIES
  :language: cmake
  :start-at: option(TUTORIAL_BUILD_UTILITIES
  :end-at: option(TUTORIAL_BUILD_UTILITIES

.. raw:: html

  </details>

然后，我们可以检查这个缓存变量，以有条件地启用\ ``Tutorial``\ 可执行文件（通过\
添加它的子目录）。

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-if-TUTORIAL_BUILD_UTILITIES
  :language: cmake
  :start-at: if(TUTORIAL_BUILD_UTILITIES)
  :end-at: endif()

.. raw:: html

  </details>

练习2 - ``CMAKE``\ 变量
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CMake提供了几个重要的普通变量和缓存变量，允许打包者控制构建过程。诸如编译器、\
默认标志、包搜索位置等决策都由CMake自己的配置变量控制。

其中最重要的是语言标准。因为语言标准会对给定包呈现的ABI产生重大影响。例如，库在\
较新版本标准中使用标准C++模板，而在较早版本标准中提供polyfill实现是很常见的。\
如果库在不同标准下被使用，那么标准模板和polyfill之间的ABI不兼容性可能会导致难以\
理解的错误和运行时崩溃。

确保所有目标都在相同的语言标准下构建是通过\ :variable:`CMAKE_<LANG>_STANDARD`\
缓存变量实现的。对于C++，这是\ ``CMAKE_CXX_STANDARD``。

.. note::
  由于这些变量非常重要，开发人员同样重要的是不要在其CML中覆盖或隐藏它们。当打包\
  者决定使用C++23构建其余库和应用程序时，如果库因为需要C++20而在CML中隐藏\
  :variable:`CMAKE_<LANG>_STANDARD`，可能会导致前面提到的可怕且难以理解的错误。

  除非有非常充分的理由，否则不要使用\ :command:`set`\ 命令设置\ ``CMAKE_``\ 全局\
  变量。我们将在后续步骤中讨论更好的方法，让目标能够传达诸如定义和最低标准等要求。

在本练习中，我们将向库和可执行文件中引入一些C++20代码，并通过设置适当的缓存变量，\
使它们使用C++20进行构建。

目标
----

使用\ ``std::format``\ 格式化打印的字符串，而不是流操作符。为确保\ ``std::format``\
的可用性，请配置CMake为C++目标使用C++20标准。

参考资源
-----------------

* :option:`cmake -D`
* :variable:`CMAKE_<LANG>_STANDARD`
* :variable:`CMAKE_CXX_STANDARD`
* :prop_tgt:`CXX_STANDARD`
* `cppreference \<format\> <https://en.cppreference.com/w/cpp/utility/format/format.html>`_

待编辑文件
-------------

* ``Tutorial/Tutorial.cxx``
* ``MathFunctions/MathFunctions.cxx``

开始操作
---------------

继续编辑\ ``Step3``\ 中的文件。完成\ ``TODO 3``\ 到\ ``TODO 7``。我们将修改打印\
语句，使用\ ``std::format``\ 替代流操作符。

确保你的缓存变量已设置，以便构建Tutorial可执行文件，可以使用上一个练习中讨论的\
任何方法。

构建和运行
-------------

我们需要使用新标准重新配置项目，可以使用与设置\ ``TUTORIAL_BUILD_UTILITIES``\
缓存变量相同的方法。

.. code-block:: console

  cmake -B build -DCMAKE_CXX_STANDARD=20

.. note::
  按照惯例，配置变量以变量提供者的名称为前缀。CMake配置变量以\ ``CMAKE_``\
  为前缀，而项目应使用\ ``<PROJECT>_``\ 作为其变量的前缀。

  本教程的配置变量遵循此惯例，以\ ``TUTORIAL_``\ 为前缀。

现在我们已经配置为使用C++20，可以像往常一样构建项目。

.. code-block:: console

  cmake --build build

解决方案
--------

我们需要包含\ ``<format>``\ 头文件，然后使用它。

.. raw:: html

  <details><summary>TODO 3-5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/Tutorial/Tutorial.cxx
  :caption: TODO 3: Tutorial/Tutorial.cxx
  :name: Tutorial/Tutorial.cxx-include-format
  :language: c++
  :start-at: #include <format>
  :end-at: #include <string>

.. literalinclude:: Step4/Tutorial/Tutorial.cxx
  :caption: TODO 4: Tutorial/Tutorial.cxx
  :name: Tutorial/Tutorial.cxx-format1
  :language: c++
  :start-at: if (argc < 2) {
  :end-at: return 1;
  :append: }
  :dedent: 2

.. literalinclude:: Step4/Tutorial/Tutorial.cxx
  :caption: TODO 5: Tutorial/Tutorial.cxx
  :name: Tutorial/Tutorial.cxx-format3
  :language: c++
  :start-at: // calculate square root
  :end-at: outputValue);
  :dedent: 2

.. raw:: html

  </details>

然后对\ ``MathFunctions``\ 库进行同样的修改。

.. raw:: html

  <details><summary>TODO 6-7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/MathFunctions/MathFunctions.cxx
  :caption: TODO 6: MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-include-format
  :language: c++
  :start-at: #include <format>
  :end-at: #include <iostream>

.. literalinclude:: Step4/MathFunctions/MathFunctions.cxx
  :caption: TODO 7: MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-format
  :language: c++
  :start-at: double delta
  :end-at: std::format
  :dedent: 4

.. raw:: html

  </details>

练习3 - CMakePresets.json
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

管理这些配置值很快就会变得让人难以应付。在CI系统中，将这些配置记录为给定CI步骤的\
一部分是合适的。例如，在Github Actions CI步骤中，我们可能会看到类似以下内容： 

.. code-block:: yaml

  - name: Configure and Build
    run: |
      cmake \
        -B build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_STANDARD=20 \
        -DCMAKE_CXX_EXTENSIONS=ON \
        -DTUTORIAL_BUILD_UTILITIES=OFF \
        # Possibly many more options
        # ...

      cmake --build build

在本地开发代码时，即使只输入一次所有这些选项也可能容易出错。如果由于任何原因需要\
重新配置，多次这样做可能会让人疲惫不堪。

解决这个问题的方案有很多种，最终选择取决于你作为开发者的偏好。面向CLI的开发者通常\
使用任务运行器来调用带有项目所需选项的CMake。大多数IDE也有控制CMake配置的自定义机制。

在这里不可能完全列举所有可能的配置工作流程。相反，我们将探索CMake的内置解决方案，\
称为\ :manual:`CMake Presets <cmake-presets(7)>`。预设为我们提供了一种命名和表达\
CMake配置选项集合的格式。 

.. note::
    预设能够表达完整的CMake工作流程，从配置、构建，一直到安装软件包。 

    它们的灵活性远超我们在这里所能涵盖的范围。我们将仅限于使用它们进行配置。 

CMake预设包含两个标准文件：\ ``CMakePresets.json``\ 旨在作为项目的一部分并在版本\
控制中跟踪；而\ ``CMakeUserPresets.json``\ 旨在用于本地用户配置，不应在版本控制\
中跟踪。 

对开发者有用的最简单的预设只是配置变量。

.. code-block:: json

  {
    "version": 4,
    "configurePresets": [
      {
        "name": "example-preset",
        "cacheVariables": {
          "EXAMPLE_FOO": "Bar",
          "EXAMPLE_QUX": "Baz"
        }
      }
    ]
  }

在调用CMake时，以前我们会这样做： 

.. code-block:: console

  cmake -B build -DEXAMPLE_FOO=Bar -DEXAMPLE_QUX=Baz

现在我们可以使用预设：

.. code-block:: console

  cmake -B build --preset example-preset

CMake将搜索名为\ ``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 的文件，\
如果可用，则从中加载命名的配置。 

.. note::
  命令行标志可以与预设混合使用。命令行标志的优先级高于预设中的值。

预设还支持有限的宏，即可以在预设内部进行大括号扩展的变量。我们感兴趣的只有\
``${sourceDir}``\ 宏， 它会扩展为项目的根目录。我们可以使用它来设置构建目录，\
从而在配置项目时跳过\ :option:`-B <cmake -B>`\ 标志。 

.. code-block:: json

  {
    "name": "example-preset",
    "binaryDir": "${sourceDir}/build"
  }

目标
----

使用CMake Preset配置并构建教程，而不是使用命令行标志。

参考资源
-----------------

* :manual:`cmake-presets(7)`

待编辑文件
-------------

* ``CMakePresets.json``

开始操作
---------------

继续编辑\ ``Step3``\ 中的文件。完成\ ``TODO 8``\ 和\ ``TODO 9``。

.. note::
  ``CMakePresets.json``\ 中的\ ``TODOs``\ 需要被\ **替换**。完成练习后，文件中\
  不应有剩余的\ ``TODO``\ 键。

你可以通过在配置前删除现有的构建文件夹来验证预设是否正常工作，这将确保你不会重复\
使用现有的CMake缓存进行配置。

.. note::
   CMake 3.24及更新版本上，可以通过使用\ :option:`cmake --fresh`\ 进行配置来实现\
   相同的效果。

所有未来的配置更改都将通过\ ``CMakePresets.json``\ 文件进行。

构建和运行
-------------

我们现在可以使用预设文件来管理我们的配置。

.. code-block:: console

  cmake --preset tutorial

预设能够为我们运行构建步骤，但在本教程中，我们将继续自己运行构建。

.. code-block:: console

  cmake --build build

解决方案
--------

我们需要进行两项更改，首先是将构建目录（也称为“二进制目录”）设置为项目文件夹的\
``build``\ 子目录，其次是将\ ``CMAKE_CXX_STANDARD``\ 设置为\ ``20``。

.. raw:: html

  <details><summary>TODO 8-9: 点击显示/隐藏答案</summary>

.. code-block:: json
  :caption: TODO 8-9: CMakePresets.json
  :name: CMakePresets.json-initial

  {
    "version": 4,
    "configurePresets": [
      {
        "name": "tutorial",
        "displayName": "Tutorial Preset",
        "description": "Preset to use with the tutorial",
        "binaryDir": "${sourceDir}/build",
        "cacheVariables": {
          "CMAKE_CXX_STANDARD": "20"
        }
      }
    ]
  }

.. raw:: html

  </details>
