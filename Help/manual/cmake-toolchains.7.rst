.. cmake-manual-description: CMake Toolchains Reference

cmake-toolchains(7)
*******************

.. only:: html

   .. contents::

引言
============

CMake使用工具链来编译、链接库和创建存档，以及其他任务来驱动构建。可用的工具链实用程序由启用\
的语言决定。在正常构建中，CMake基于系统自省和默认值自动确定主机构建的工具链。在交叉编译场景中，\
可以使用编译器和工具程序路径信息指定工具链文件。

.. versionadded:: 3.19
  可以使用\ :manual:`cmake-presets(7)`\ 来指定工具链文件。

语言
=========

语言是通过\ :command:`project`\ 命令启用的。特定于语言的内置变量，如\
:variable:`CMAKE_CXX_COMPILER <CMAKE_<LANG>_COMPILER>`、\
:variable:`CMAKE_CXX_COMPILER_ID <CMAKE_<LANG>_COMPILER_ID>`\ 等，可以通过调用\
:command:`project`\ 命令来设置。如果顶层CMakeLists文件中没有项目命令，则会隐式生成一个。\
默认情况下，启用的语言是\ ``C``\ 和\ ``CXX``：

.. code-block:: cmake

  project(C_Only C)

特殊值\ ``NONE``\ 也可以与\ :command:`project`\ 命令一起使用，以启用无语言：

.. code-block:: cmake

  project(MyProject NONE)

:command:`enable_language`\ 命令可用于在\ :command:`project`\ 命令之后启用语言：

.. code-block:: cmake

  enable_language(CXX)

当一种语言被启用时，CMake为该语言找到一个编译器，并确定一些信息，如编译器的供应商和版本、目\
标体系结构和位宽、相应实用程序的位置等。

:prop_gbl:`ENABLED_LANGUAGES`\ 全局属性包含当前启用的语言。

变量和属性
========================

有几个变量与工具链的语言组件相关，这些组件是启用的：

:variable:`CMAKE_<LANG>_COMPILER`
  用于\ ``<LANG>``\ 的编译器的完整路径
:variable:`CMAKE_<LANG>_COMPILER_ID`
  CMake使用的编译器标识符
:variable:`CMAKE_<LANG>_COMPILER_VERSION`
  编译器的版本。
:variable:`CMAKE_<LANG>_FLAGS`
  变量和特定于配置的等效物，包含在编译特定语言的文件时将被添加到编译命令中的标志。

CMake需要一种方法来确定使用哪个编译器来调用链接器。这是由\ :manual:`目标 <cmake-buildsystem(7)>`\
源文件的\ :prop_sf:`LANGUAGE`\ 属性决定的，在静态库的情况下，是由依赖库的\ ``LANGUAGE``\
属性决定的。CMake做出的选择可能会被\ :prop_tgt:`LINKER_LANGUAGE`\ 目标属性覆盖。

工具链特性
==================

CMake提供了\ :command:`try_compile`\ 命令和包装器宏，如\ :module:`CheckCXXSourceCompiles`、\
:module:`CheckCXXSymbolExists`\ 和\ :module:`CheckIncludeFile`\ 来测试各种工具链功\
能的能力和可用性。这些API以某种方式测试工具链并缓存结果，以便下次CMake运行时不必再次执行测试。

一些工具链特性在CMake中有内置处理，不需要编译测试。例如，:prop_tgt:`POSITION_INDEPENDENT_CODE`\
允许指定目标应该构建为位置无关的代码，如果编译器支持该特性。:prop_tgt:`<LANG>_VISIBILITY_PRESET`\
和\ :prop_tgt:`VISIBILITY_INLINES_HIDDEN`\ 目标属性添加了隐藏可见性的标志，如果编译器支持的话。

.. _`Cross Compiling Toolchain`:

交叉编译
===============

如果使用命令行参数\ :option:`--toolchain path/to/file <cmake --toolchain>`\ 或\
:option:`-DCMAKE_TOOLCHAIN_FILE=path/to/file <cmake -D>`\ 调用\ :manual:`cmake(1)`，\
文件将提前加载以为编译器设置值。当CMake进行交叉编译时，\ :variable:`CMAKE_CROSSCOMPILING`\
变量被设置为true。

注意，在工具链文件中使用\ :variable:`CMAKE_SOURCE_DIR`\ 或\ :variable:`CMAKE_BINARY_DIR`\
变量通常是不可取的。工具链文件用于这些变量在不同地方使用时具有不同值的上下文中（例如，作为调用\
:command:`try_compile`\ 的一部分）。在大多数情况下，当需要计算工具链文件中的路径时，更合适\
的变量是\ :variable:`CMAKE_CURRENT_LIST_DIR`，因为它总是有一个明确的、可预测的值。

Linux交叉编译
-------------------------

典型的Linux交叉编译工具链包含如下内容：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Linux)
  set(CMAKE_SYSTEM_PROCESSOR arm)

  set(CMAKE_SYSROOT /home/devel/rasp-pi-rootfs)
  set(CMAKE_STAGING_PREFIX /home/devel/stage)

  set(tools /home/devel/gcc-4.7-linaro-rpi-gnueabihf)
  set(CMAKE_C_COMPILER ${tools}/bin/arm-linux-gnueabihf-gcc)
  set(CMAKE_CXX_COMPILER ${tools}/bin/arm-linux-gnueabihf-g++)

  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

Where:

:variable:`CMAKE_SYSTEM_NAME`
  是要构建的目标平台的CMake标识符。
:variable:`CMAKE_SYSTEM_PROCESSOR`
  是目标体系结构的CMake标识符。
:variable:`CMAKE_SYSROOT`
  是可选的，如果sysroot可用，则可以指定。
:variable:`CMAKE_STAGING_PREFIX`
  也是可选的。它可以用来指定要安装到的主机上的路径。:variable:`CMAKE_INSTALL_PREFIX`\
  始终是运行时安装位置，即使在交叉编译时也是如此。
:variable:`CMAKE_<LANG>_COMPILER`
  变量可以设置为完整路径，也可以设置为要在标准位置中搜索的编译器的名称。对于不支持链接没有自\
  定义标志或脚本的二进制文件的工具链，可以将\ :variable:`CMAKE_TRY_COMPILE_TARGET_TYPE`\
  变量设置为\ ``STATIC_LIBRARY``，以告诉CMake在检查期间不要尝试链接可执行文件。

默认情况下，CMake的\ ``find_*``\ 命令将查找sysroot和\ :variable:`CMAKE_FIND_ROOT_PATH`\
条目，以及查找主机系统根前缀。虽然这可以根据具体情况进行控制，但是在交叉编译时，排除在主机或目\
标中查找特定工件是很有用的。通常，includes、库和包应该在目标系统前缀中找到，而必须作为构建的一\
部分运行的可执行文件应该只在主机上找到，而不是在目标系统上。这就是\
``CMAKE_FIND_ROOT_PATH_MODE_*``\ 变量的目的。

.. _`Cray Cross-Compile`:

Cray Linux环境交叉编译
----------------------------------------------

在Cray Linux环境中，计算节点的交叉编译无需单独的工具链文件即可完成。在CMake命令行中指定\
``-DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment``\ 将确保配置适当的构建设置和搜索路径。平台\
将从当前环境变量中提取其配置，并将配置项目以使用Cray编程环境的\ ``PrgEnv-*``\ 模块中的编译\
器包装器，如果存在并已加载。

Cray编程环境的默认配置是只支持静态库。可以通过将\ ``CRAYPE_LINK_TYPE``\ 环境变量设置为\
``dynamic``\ 来覆盖和启用共享库。

运行CMake而不指定\ :variable:`CMAKE_SYSTEM_NAME`\ 将在主机模式下运行配置步骤（假设是标\
准Linux环境）。如果不重写，\ ``PrgEnv-*``\ 编译器包装器最终将被使用，如果针对登录节点或计\
算节点，这可能不是期望的行为。如果你直接在NID上构建，而不是从登录节点进行交叉编译，则会出现例\
外。如果试图为登录节点构建软件，你需要首先卸载当前加载的\ ``PrgEnv-*``\ 模块，或者显式地告\
诉CMake使用\ ``/usr/bin``\ 中的系统编译器而不是Cray包装器。如果希望以计算节点为目标，只需\
像上面提到的那样指定\ :variable:`CMAKE_SYSTEM_NAME`。

使用Clang交叉编译
---------------------------

Some compilers such as Clang are inherently cross compilers.
The :variable:`CMAKE_<LANG>_COMPILER_TARGET` can be set to pass a
value to those supported compilers when compiling:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Linux)
  set(CMAKE_SYSTEM_PROCESSOR arm)

  set(triple arm-linux-gnueabihf)

  set(CMAKE_C_COMPILER clang)
  set(CMAKE_C_COMPILER_TARGET ${triple})
  set(CMAKE_CXX_COMPILER clang++)
  set(CMAKE_CXX_COMPILER_TARGET ${triple})

Similarly, some compilers do not ship their own supplementary utilities
such as linkers, but provide a way to specify the location of the external
toolchain which will be used by the compiler driver. The
:variable:`CMAKE_<LANG>_COMPILER_EXTERNAL_TOOLCHAIN` variable can be set in a
toolchain file to pass the path to the compiler driver.

QNX交叉编译
-----------------------

As the Clang compiler the QNX QCC compile is inherently a cross compiler.
And the :variable:`CMAKE_<LANG>_COMPILER_TARGET` can be set to pass a
value to those supported compilers when compiling:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME QNX)

  set(arch gcc_ntoarmv7le)

  set(CMAKE_C_COMPILER qcc)
  set(CMAKE_C_COMPILER_TARGET ${arch})
  set(CMAKE_CXX_COMPILER QCC)
  set(CMAKE_CXX_COMPILER_TARGET ${arch})

  set(CMAKE_SYSROOT $ENV{QNX_TARGET})


Windows CE交叉编译
------------------------------

Cross compiling for Windows CE requires the corresponding SDK being
installed on your system.  These SDKs are usually installed under
``C:/Program Files (x86)/Windows CE Tools/SDKs``.

A toolchain file to configure a Visual Studio generator for
Windows CE may look like this:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME WindowsCE)

  set(CMAKE_SYSTEM_VERSION 8.0)
  set(CMAKE_SYSTEM_PROCESSOR arm)

  set(CMAKE_GENERATOR_TOOLSET CE800) # Can be omitted for 8.0
  set(CMAKE_GENERATOR_PLATFORM SDK_AM335X_SK_WEC2013_V310)

The :variable:`CMAKE_GENERATOR_PLATFORM` tells the generator which SDK to use.
Further :variable:`CMAKE_SYSTEM_VERSION` tells the generator what version of
Windows CE to use.  Currently version 8.0 (Windows Embedded Compact 2013) is
supported out of the box.  Other versions may require one to set
:variable:`CMAKE_GENERATOR_TOOLSET` to the correct value.

Windows 10通用应用交叉编译
-----------------------------------------------------

A toolchain file to configure a Visual Studio generator for a
Windows 10 Universal Application may look like this:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME WindowsStore)
  set(CMAKE_SYSTEM_VERSION 10.0)

A Windows 10 Universal Application targets both Windows Store and
Windows Phone.  Specify the :variable:`CMAKE_SYSTEM_VERSION` variable
to be ``10.0`` to build with the latest available Windows 10 SDK.
Specify a more specific version (e.g. ``10.0.10240.0`` for RTM)
to build with the corresponding SDK.

Windows Phone交叉编译
---------------------------------

A toolchain file to configure a Visual Studio generator for
Windows Phone may look like this:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME WindowsPhone)
  set(CMAKE_SYSTEM_VERSION 8.1)

Windows Store交叉编译
---------------------------------

A toolchain file to configure a Visual Studio generator for
Windows Store may look like this:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME WindowsStore)
  set(CMAKE_SYSTEM_VERSION 8.1)

.. _`Cross Compiling for ADSP SHARC/Blackfin`:

Cross Compiling for ADSP SHARC/Blackfin
---------------------------------------

Cross-compiling for ADSP SHARC or Blackfin can be configured
by setting the :variable:`CMAKE_SYSTEM_NAME` variable to ``ADSP``
and the :variable:`CMAKE_SYSTEM_PROCESSOR` variable
to the "part number", excluding the ``ADSP-`` prefix,
for example, ``21594``, ``SC589``, etc.
This value is case insensitive.

CMake will automatically search for CCES or VDSP++ installs
in their default install locations
and select the most recent version found.
CCES will be selected over VDSP++ if both are installed.
Custom install paths can be set via the :variable:`CMAKE_ADSP_ROOT` variable
or the :envvar:`ADSP_ROOT` environment variable.

The compiler (``cc21k`` vs. ``ccblkfn``) is selected automatically
based on the :variable:`CMAKE_SYSTEM_PROCESSOR` value provided.

.. _`Cross Compiling for Android`:

Android交叉编译
---------------------------

A toolchain file may configure cross-compiling for Android by setting the
:variable:`CMAKE_SYSTEM_NAME` variable to ``Android``.  Further configuration
is specific to the Android development environment to be used.

For :ref:`Visual Studio Generators`, CMake expects :ref:`NVIDIA Nsight Tegra
Visual Studio Edition <Cross Compiling for Android with NVIDIA Nsight Tegra
Visual Studio Edition>` or the :ref:`Visual Studio tools for Android
<Cross Compiling for Android with the NDK>` to be installed. See those sections
for further configuration details.

For :ref:`Makefile Generators` and the :generator:`Ninja` generator,
CMake expects one of these environments:

* :ref:`NDK <Cross Compiling for Android with the NDK>`
* :ref:`Standalone Toolchain <Cross Compiling for Android with a Standalone Toolchain>`

CMake uses the following steps to select one of the environments:

* If the :variable:`CMAKE_ANDROID_NDK` variable is set, the NDK at the
  specified location will be used.

* Else, if the :variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN` variable
  is set, the Standalone Toolchain at the specified location will be used.

* Else, if the :variable:`CMAKE_SYSROOT` variable is set to a directory
  of the form ``<ndk>/platforms/android-<api>/arch-<arch>``, the ``<ndk>``
  part will be used as the value of :variable:`CMAKE_ANDROID_NDK` and the
  NDK will be used.

* Else, if the :variable:`CMAKE_SYSROOT` variable is set to a directory of the
  form ``<standalone-toolchain>/sysroot``, the ``<standalone-toolchain>`` part
  will be used as the value of :variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`
  and the Standalone Toolchain will be used.

* Else, if a cmake variable ``ANDROID_NDK`` is set it will be used
  as the value of :variable:`CMAKE_ANDROID_NDK`, and the NDK will be used.

* Else, if a cmake variable ``ANDROID_STANDALONE_TOOLCHAIN`` is set, it will be
  used as the value of :variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`, and the
  Standalone Toolchain will be used.

* Else, if an environment variable ``ANDROID_NDK_ROOT`` or
  ``ANDROID_NDK`` is set, it will be used as the value of
  :variable:`CMAKE_ANDROID_NDK`, and the NDK will be used.

* Else, if an environment variable ``ANDROID_STANDALONE_TOOLCHAIN`` is
  set then it will be used as the value of
  :variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`, and the Standalone
  Toolchain will be used.

* Else, an error diagnostic will be issued that neither the NDK or
  Standalone Toolchain can be found.

.. versionadded:: 3.20
  If an Android NDK is selected, its version number is reported
  in the :variable:`CMAKE_ANDROID_NDK_VERSION` variable.

.. _`Cross Compiling for Android with the NDK`:

使用NDK交叉编译Android
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A toolchain file may configure :ref:`Makefile Generators`,
:ref:`Ninja Generators`, or :ref:`Visual Studio Generators` to target
Android for cross-compiling.

Configure use of an Android NDK with the following variables:

:variable:`CMAKE_SYSTEM_NAME`
  Set to ``Android``.  Must be specified to enable cross compiling
  for Android.

:variable:`CMAKE_SYSTEM_VERSION`
  Set to the Android API level.  If not specified, the value is
  determined as follows:

  * If the :variable:`CMAKE_ANDROID_API` variable is set, its value
    is used as the API level.
  * If the :variable:`CMAKE_SYSROOT` variable is set, the API level is
    detected from the NDK directory structure containing the sysroot.
  * Otherwise, the latest API level available in the NDK is used.

:variable:`CMAKE_ANDROID_ARCH_ABI`
  Set to the Android ABI (architecture).  If not specified, this
  variable will default to the first supported ABI in the list of
  ``armeabi``, ``armeabi-v7a`` and ``arm64-v8a``.
  The :variable:`CMAKE_ANDROID_ARCH` variable will be computed
  from ``CMAKE_ANDROID_ARCH_ABI`` automatically.
  Also see the :variable:`CMAKE_ANDROID_ARM_MODE` and
  :variable:`CMAKE_ANDROID_ARM_NEON` variables.

:variable:`CMAKE_ANDROID_NDK`
  Set to the absolute path to the Android NDK root directory.
  If not specified, a default for this variable will be chosen
  as specified :ref:`above <Cross Compiling for Android>`.

:variable:`CMAKE_ANDROID_NDK_DEPRECATED_HEADERS`
  Set to a true value to use the deprecated per-api-level headers
  instead of the unified headers.  If not specified, the default will
  be false unless using a NDK that does not provide unified headers.

:variable:`CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION`
  On NDK r19 or above, this variable must be unset or set to ``clang``.
  On NDK r18 or below, set this to the version of the NDK toolchain to
  be selected as the compiler.  If not specified, the default will be
  the latest available GCC toolchain.

:variable:`CMAKE_ANDROID_STL_TYPE`
  Set to specify which C++ standard library to use.  If not specified,
  a default will be selected as described in the variable documentation.

The following variables will be computed and provided automatically:

:variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_PREFIX`
  The absolute path prefix to the binutils in the NDK toolchain.

:variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_SUFFIX`
  The host platform suffix of the binutils in the NDK toolchain.


For example, a toolchain file might contain:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Android)
  set(CMAKE_SYSTEM_VERSION 21) # API level
  set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)
  set(CMAKE_ANDROID_NDK /path/to/android-ndk)
  set(CMAKE_ANDROID_STL_TYPE gnustl_static)

Alternatively one may specify the values without a toolchain file:

.. code-block:: console

  $ cmake ../src \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=21 \
    -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
    -DCMAKE_ANDROID_NDK=/path/to/android-ndk \
    -DCMAKE_ANDROID_STL_TYPE=gnustl_static

.. _`Cross Compiling for Android with a Standalone Toolchain`:

使用单独工具链交叉编译Android
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A toolchain file may configure :ref:`Makefile Generators` or the
:generator:`Ninja` generator to target Android for cross-compiling
using a standalone toolchain.

Configure use of an Android standalone toolchain with the following variables:

:variable:`CMAKE_SYSTEM_NAME`
  Set to ``Android``.  Must be specified to enable cross compiling
  for Android.

:variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`
  Set to the absolute path to the standalone toolchain root directory.
  A ``${CMAKE_ANDROID_STANDALONE_TOOLCHAIN}/sysroot`` directory
  must exist.
  If not specified, a default for this variable will be chosen
  as specified :ref:`above <Cross Compiling for Android>`.

:variable:`CMAKE_ANDROID_ARM_MODE`
  When the standalone toolchain targets ARM, optionally set this to ``ON``
  to target 32-bit ARM instead of 16-bit Thumb.
  See variable documentation for details.

:variable:`CMAKE_ANDROID_ARM_NEON`
  When the standalone toolchain targets ARM v7, optionally set thisto ``ON``
  to target ARM NEON devices.  See variable documentation for details.

The following variables will be computed and provided automatically:

:variable:`CMAKE_SYSTEM_VERSION`
  The Android API level detected from the standalone toolchain.

:variable:`CMAKE_ANDROID_ARCH_ABI`
  The Android ABI detected from the standalone toolchain.

:variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_PREFIX`
  The absolute path prefix to the ``binutils`` in the standalone toolchain.

:variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_SUFFIX`
  The host platform suffix of the ``binutils`` in the standalone toolchain.

For example, a toolchain file might contain:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Android)
  set(CMAKE_ANDROID_STANDALONE_TOOLCHAIN /path/to/android-toolchain)

Alternatively one may specify the values without a toolchain file:

.. code-block:: console

  $ cmake ../src \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=/path/to/android-toolchain

.. _`Cross Compiling for Android with NVIDIA Nsight Tegra Visual Studio Edition`:

使用NVIDIA Nsight Tegra Visual Studio版本交叉编译Android
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A toolchain file to configure one of the :ref:`Visual Studio Generators`
to build using NVIDIA Nsight Tegra targeting Android may look like this:

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Android)

The :variable:`CMAKE_GENERATOR_TOOLSET` may be set to select
the Nsight Tegra "Toolchain Version" value.

See also target properties:

* :prop_tgt:`ANDROID_ANT_ADDITIONAL_OPTIONS`
* :prop_tgt:`ANDROID_API_MIN`
* :prop_tgt:`ANDROID_API`
* :prop_tgt:`ANDROID_ARCH`
* :prop_tgt:`ANDROID_ASSETS_DIRECTORIES`
* :prop_tgt:`ANDROID_GUI`
* :prop_tgt:`ANDROID_JAR_DEPENDENCIES`
* :prop_tgt:`ANDROID_JAR_DIRECTORIES`
* :prop_tgt:`ANDROID_JAVA_SOURCE_DIR`
* :prop_tgt:`ANDROID_NATIVE_LIB_DEPENDENCIES`
* :prop_tgt:`ANDROID_NATIVE_LIB_DIRECTORIES`
* :prop_tgt:`ANDROID_PROCESS_MAX`
* :prop_tgt:`ANDROID_PROGUARD_CONFIG_PATH`
* :prop_tgt:`ANDROID_PROGUARD`
* :prop_tgt:`ANDROID_SECURE_PROPS_PATH`
* :prop_tgt:`ANDROID_SKIP_ANT_STEP`
* :prop_tgt:`ANDROID_STL_TYPE`

.. _`Cross Compiling for iOS, tvOS, or watchOS`:

iOS、tvOS或者watchOS交叉编译
-----------------------------------------

For cross-compiling to iOS, tvOS, or watchOS, the :generator:`Xcode`
generator is recommended.  The :generator:`Unix Makefiles` or
:generator:`Ninja` generators can also be used, but they require the
project to handle more areas like target CPU selection and code signing.

Any of the three systems can be targeted by setting the
:variable:`CMAKE_SYSTEM_NAME` variable to a value from the table below.
By default, the latest Device SDK is chosen.  As for all Apple platforms,
a different SDK (e.g. a simulator) can be selected by setting the
:variable:`CMAKE_OSX_SYSROOT` variable, although this should rarely be
necessary (see :ref:`Switching Between Device and Simulator` below).
A list of available SDKs can be obtained by running ``xcodebuild -showsdks``.

=======  ================= ==================== ================
OS       CMAKE_SYSTEM_NAME Device SDK (default) Simulator SDK
=======  ================= ==================== ================
iOS      iOS               iphoneos             iphonesimulator
tvOS     tvOS              appletvos            appletvsimulator
watchOS  watchOS           watchos              watchsimulator
=======  ================= ==================== ================

For example, to create a CMake configuration for iOS, the following
command is sufficient:

.. code-block:: console

  cmake .. -GXcode -DCMAKE_SYSTEM_NAME=iOS

Variable :variable:`CMAKE_OSX_ARCHITECTURES` can be used to set architectures
for both device and simulator. Variable :variable:`CMAKE_OSX_DEPLOYMENT_TARGET`
can be used to set an iOS/tvOS/watchOS deployment target.

Next configuration will install fat 5 architectures iOS library
and add the ``-miphoneos-version-min=9.3``/``-mios-simulator-version-min=9.3``
flags to the compiler:

.. code-block:: console

  $ cmake -S. -B_builds -GXcode \
      -DCMAKE_SYSTEM_NAME=iOS \
      "-DCMAKE_OSX_ARCHITECTURES=armv7;armv7s;arm64;i386;x86_64" \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=9.3 \
      -DCMAKE_INSTALL_PREFIX=`pwd`/_install \
      -DCMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH=NO \
      -DCMAKE_IOS_INSTALL_COMBINED=YES

Example:

.. code-block:: cmake

  # CMakeLists.txt
  cmake_minimum_required(VERSION 3.14)
  project(foo)
  add_library(foo foo.cpp)
  install(TARGETS foo DESTINATION lib)

Install:

.. code-block:: console

    $ cmake --build _builds --config Release --target install

Check library:

.. code-block:: console

    $ lipo -info _install/lib/libfoo.a
    Architectures in the fat file: _install/lib/libfoo.a are: i386 armv7 armv7s x86_64 arm64

.. code-block:: console

    $ otool -l _install/lib/libfoo.a | grep -A2 LC_VERSION_MIN_IPHONEOS
          cmd LC_VERSION_MIN_IPHONEOS
      cmdsize 16
      version 9.3

代码签名
^^^^^^^^^^^^

Some build artifacts for the embedded Apple platforms require mandatory
code signing.  If the :generator:`Xcode` generator is being used and
code signing is required or desired, the development team ID can be
specified via the ``CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM`` CMake variable.
This team ID will then be included in the generated Xcode project.
By default, CMake avoids the need for code signing during the internal
configuration phase (i.e compiler ID and feature detection).

.. _`Switching Between Device and Simulator`:

在设备和模拟器之间切换
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When configuring for any of the embedded platforms, one can target either
real devices or the simulator.  Both have their own separate SDK, but CMake
only supports specifying a single SDK for the configuration phase.  This
means the developer must select one or the other at configuration time.
When using the :generator:`Xcode` generator, this is less of a limitation
because Xcode still allows you to build for either a device or a simulator,
even though configuration was only performed for one of the two.  From
within the Xcode IDE, builds are performed for the selected "destination"
platform.  When building from the command line, the desired sdk can be
specified directly by passing a ``-sdk`` option to the underlying build
tool (``xcodebuild``).  For example:

.. code-block:: console

  $ cmake --build ... -- -sdk iphonesimulator

Please note that checks made during configuration were performed against
the configure-time SDK and might not hold true for other SDKs.  Commands
like :command:`find_package`, :command:`find_library`, etc. store and use
details only for the configured SDK/platform, so they can be problematic
if wanting to switch between device and simulator builds. You can follow
the next rules to make device + simulator configuration work:

- Use explicit ``-l`` linker flag,
  e.g. ``target_link_libraries(foo PUBLIC "-lz")``

- Use explicit ``-framework`` linker flag,
  e.g. ``target_link_libraries(foo PUBLIC "-framework CoreFoundation")``

- Use :command:`find_package` only for libraries installed with
  :variable:`CMAKE_IOS_INSTALL_COMBINED` feature
