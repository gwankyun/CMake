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

Solution
--------

First we create our :command:`option` to provide our cache variable with a
reasonable default value.

.. raw:: html

  <details><summary>TODO 1: Click to show/hide answer</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-option-TUTORIAL_BUILD_UTILITIES
  :language: cmake
  :start-at: option(TUTORIAL_BUILD_UTILITIES
  :end-at: option(TUTORIAL_BUILD_UTILITIES

.. raw:: html

  </details>

Then we can check the cache variable to conditionally enable the ``Tutorial``
executable (by way of adding its subdirectory).

.. raw:: html

  <details><summary>TODO 2: Click to show/hide answer</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-if-TUTORIAL_BUILD_UTILITIES
  :language: cmake
  :start-at: if(TUTORIAL_BUILD_UTILITIES)
  :end-at: endif()

.. raw:: html

  </details>

Exercise 2 - ``CMAKE`` Variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CMake has several important normal and cache variables provided to allow
packagers to control the build. Decisions such as compilers, default flags,
search locations for packages, and much more are all controlled by CMake's
own configuration variables.

Among the most important are language standards. As the language standard can
have significant impact on the ABI presented by a given package. For example,
it's quite common for libraries to use standard C++ templates on later
standards, and provide polyfills on earlier standards. If a library is consumed
under different standards then ABI incompatibilities between the standard
templates and the polyfills can result in incomprehensible errors and runtime
crashes.

Ensuring all of our targets are built under the same language standard is
achieved with the :variable:`CMAKE_<LANG>_STANDARD` cache variables. For C++,
this is ``CMAKE_CXX_STANDARD``.

.. note::
  Because these variables are so important, it is equally important that
  developers not override or shadow them in their CMLs. Shadowing
  :variable:`CMAKE_<LANG>_STANDARD` in a CML because the library wants C++20,
  when the packager has decided to build the rest of their libraries and
  applications with C++23, can lead to the aforementioned terrible,
  incomprehensible errors.

  Do not :command:`set` ``CMAKE_`` globals without very strong reasons for
  doing so. We'll discuss better methods for targets to communicate
  requirements like definitions and minimum standards in later steps.

In this exercise, we'll introduce some C++20 code into our library and
executable and build them with C++20 by setting the appropriate cache variable.

Goal
----

Use ``std::format`` to format printed strings instead of stream operators. To
ensure availability of ``std::format``, configure CMake to use the C++20
standard for C++ targets.

Helpful Resources
-----------------

* :option:`cmake -D`
* :variable:`CMAKE_<LANG>_STANDARD`
* :variable:`CMAKE_CXX_STANDARD`
* :prop_tgt:`CXX_STANDARD`
* `cppreference \<format\> <https://en.cppreference.com/w/cpp/utility/format/format.html>`_

Files to Edit
-------------

* ``Tutorial/Tutorial.cxx``
* ``MathFunctions/MathFunctions.cxx``

Getting Started
---------------

Continue to edit files from ``Step3``. Complete ``TODO 3`` through ``TODO 7``.
We'll be modifying our prints to use ``std::format`` instead of stream
operators.

Ensure your cache variables are set such that the Tutorial executable will be
built, using any of the methods discussed in the previous exercise.

Build and Run
-------------

We need to reconfigure our project with the new standard, we can do this
using the same method as our ``TUTORIAL_BUILD_UTILITIES`` cache variable.

.. code-block:: console

  cmake -B build -DCMAKE_CXX_STANDARD=20

.. note::
  Configuration variables are, by convention, prefixed with the provider of the
  variable. CMake configuration variables are prefixed with ``CMAKE_``, while
  projects should prefix their variables with ``<PROJECT>_``.

  The tutorial configuration variables follow this convention, and are prefixed
  with ``TUTORIAL_``.

Now that we've configured with C++20, we can build as usual.

.. code-block:: console

  cmake --build build

Solution
--------

We need to include ``<format>`` and then use it.

.. raw:: html

  <details><summary>TODO 3-5: Click to show/hide answer</summary>

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

And again for the ``MathFunctions`` library.

.. raw:: html

  <details><summary>TODO 6-7: Click to show/hide answer</summary>

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

Exercise 3 - CMakePresets.json
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Managing these configuration values can quickly become overwhelming. In CI
systems it is appropriate to record these as part of a given CI step. For
example in a Github Actions CI step we might see something akin to the
following:

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

When developing code locally, typing all these options even once might be error
prone. If a fresh configuration is needed for any reason, doing so multiple
times could be exhausting.

There are many and varied solutions to this problem, and your choice is
ultimately up to your preferences as a developer. CLI-oriented developers
commonly use task runners to invoke CMake with their desired options for a
project. Most IDEs also have a custom mechanism for controlling CMake
configuration.

It would be impossible to fully enumerate every possible configuration workflow
here. Instead we will explore CMake's built-in solution, known as
:manual:`CMake Presets <cmake-presets(7)>`. Presets give us a format to name
and express collections of CMake configuration options.

.. note::
    Presets are capable of expressing entire CMake workflows, from
    configuration, through building, all the way to installing the software
    package.

    They are far more flexible than can we have room for here. We'll limit
    ourselves to using them for configuration.

CMake Presets come in two standard files, ``CMakePresets.json``, which is
intended to be a part of the project and tracked in source control; and
``CMakeUserPresets.json``, which is intended for local user configuration
and should not be tracked in source control.

The simplest preset which would be of use to a developer does nothing more
than configure variables.

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

When invoking CMake, where previously we would have done:

.. code-block:: console

  cmake -B build -DEXAMPLE_FOO=Bar -DEXAMPLE_QUX=Baz

We can now use the preset:

.. code-block:: console

  cmake -B build --preset example-preset

CMake will search for files named ``CMakePresets.json`` and
``CMakeUserPresets.json``, and load the named configuration from them if
available.

.. note::
  Command line flags can be mixed with presets. Command line flags have
  precedence over values found in a preset.

Presets also support limited macros, variables that can be brace-expanded
inside the preset. The only one of interest to us is the ``${sourceDir}`` macro,
which expands to the root directory of the project. We can use this to set our
build directory, skipping the :option:`-B <cmake -B>` flag when configuring
the project.

.. code-block:: json

  {
    "name": "example-preset",
    "binaryDir": "${sourceDir}/build"
  }

Goal
----

Configure and build the tutorial using a CMake Preset instead of command line
flags.

Helpful Resources
-----------------

* :manual:`cmake-presets(7)`

Files to Edit
-------------

* ``CMakePresets.json``

Getting Started
---------------

Continue to edit files from ``Step3``. Complete ``TODO 8`` and ``TODO 9``.

.. note::
  ``TODOs`` inside ``CMakePresets.json`` need to be *replaced*. There should
  be no ``TODO`` keys left inside the file when you have completed the exercise.

You can verify the preset is working correctly by deleting the existing build
folder before you configure, this will ensure you're not reusing the existing
CMake Cache for configuration.

.. note::
  On CMake 3.24 and newer, the same effect can be achieved by configuring with
  :option:`cmake --fresh`.

All future configuration changes will be via the ``CMakePresets.json`` file.

Build and Run
-------------

We can now use the preset file to manage our configuration.

.. code-block:: console

  cmake --preset tutorial

Presets are capable of running the build step for us, but for this tutorial
we'll continue to run the build ourselves.

.. code-block:: console

  cmake --build build

Solution
--------

There are two changes we need to make, first we want to set the build
directory (also called the "binary directory") to the ``build`` subdirectory
of our project folder, and second we need to set the ``CMAKE_CXX_STANDARD`` to
``20``.

.. raw:: html

  <details><summary>TODO 8-9: Click to show/hide answer</summary>

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
