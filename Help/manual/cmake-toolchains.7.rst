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

CMake需要一种方法来确定使用哪个编译器来调用链接器。这是由\
:manual:`目标 <cmake-buildsystem(7)>`\ 源文件的\ :prop_sf:`LANGUAGE`\ 属性决定的，\
在静态库的情况下，是由依赖库的\ ``LANGUAGE``\ 属性决定的。CMake做出的选择可能会被\
:prop_tgt:`LINKER_LANGUAGE`\ 目标属性覆盖。

工具链特性
==================

CMake提供了\ :command:`try_compile`\ 命令和包装器宏，如\
:module:`CheckSourceCompiles`、\ :module:`CheckCXXSymbolExists`\ 和\
:module:`CheckIncludeFile`\ 来测试各种工具链功能的能力和可用性。这些API以某种方式测试工\
具链并缓存结果，以便下次CMake运行时不必再次执行测试。

一些工具链特性在CMake中有内置处理，不需要编译测试。例如，\
:prop_tgt:`POSITION_INDEPENDENT_CODE`\ 允许指定目标应该构建为位置无关的代码，如果编译\
器支持该特性。:prop_tgt:`<LANG>_VISIBILITY_PRESET`\ 和\
:prop_tgt:`VISIBILITY_INLINES_HIDDEN`\ 目标属性添加了隐藏可见性的标志，如果编译器支持的话。

.. _`Cross Compiling Toolchain`:

交叉编译
===============

如果使用命令行参数\ :option:`--toolchain path/to/file <cmake --toolchain>`\ 或\
:option:`-DCMAKE_TOOLCHAIN_FILE=path/to/file <cmake -D>`\ 调用\
:manual:`cmake(1)`，文件将提前加载以为编译器设置值。当CMake进行交叉编译时，\
:variable:`CMAKE_CROSSCOMPILING`\ 变量被设置为true。

注意，在工具链文件中使用\ :variable:`CMAKE_SOURCE_DIR`\ 或\
:variable:`CMAKE_BINARY_DIR`\ 变量通常是不可取的。工具链文件用于这些变量在不同地方使用时\
具有不同值的上下文中（例如，作为调用\ :command:`try_compile`\ 的一部分）。在大多数情况下，\
当需要计算工具链文件中的路径时，更合适的变量是\ :variable:`CMAKE_CURRENT_LIST_DIR`，因\
为它总是有一个明确的、可预测的值。

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

一些编译器（如Clang）本质上是交叉编译器。:variable:`CMAKE_<LANG>_COMPILER_TARGET`\
可以设置为在编译时向支持的编译器传递一个值：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Linux)
  set(CMAKE_SYSTEM_PROCESSOR arm)

  set(triple arm-linux-gnueabihf)

  set(CMAKE_C_COMPILER clang)
  set(CMAKE_C_COMPILER_TARGET ${triple})
  set(CMAKE_CXX_COMPILER clang++)
  set(CMAKE_CXX_COMPILER_TARGET ${triple})

类似地，一些编译器不附带它们自己的补充工具，比如链接器，但提供了一种方法来指定编译器驱动程序将\
使用的外部工具链的位置。:variable:`CMAKE_<LANG>_COMPILER_EXTERNAL_TOOLCHAIN`\ 变量可\
以在工具链文件中设置，以将路径传递给编译器驱动程序。

QNX交叉编译
-----------------------

作为Clang编译器，QNX QCC编译器本质上是一个交叉编译器。\
:variable:`CMAKE_<LANG>_COMPILER_TARGET`\ 可以设置为在编译时向支持的编译器传递一个值：

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

Windows CE的交叉编译需要在系统上安装相应的SDK。这些SDK通常安装在\
``C:/Program Files (x86)/Windows CE Tools/SDKs``\ 下。

为Windows CE配置Visual Studio生成器的工具链文件可能如下所示：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME WindowsCE)

  set(CMAKE_SYSTEM_VERSION 8.0)
  set(CMAKE_SYSTEM_PROCESSOR arm)

  set(CMAKE_GENERATOR_TOOLSET CE800) # Can be omitted for 8.0
  set(CMAKE_GENERATOR_PLATFORM SDK_AM335X_SK_WEC2013_V310)

:variable:`CMAKE_GENERATOR_PLATFORM`\ 告诉生成器要使用哪个SDK。进一步\
:variable:`CMAKE_SYSTEM_VERSION`\ 告诉生成器要使用哪个版本的Windows CE。目前版本8.0 \
（Windows Embedded Compact 2013）是开箱即用的。其他版本可能需要将\
:variable:`CMAKE_GENERATOR_TOOLSET`\ 设置为正确的值。

Windows 10通用应用交叉编译
-----------------------------------------------------

为Windows 10通用应用程序配置\ :ref:`Visual Studio Generators`\ 的工具链文件可能如下所示：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME WindowsStore)
  set(CMAKE_SYSTEM_VERSION 10.0)

Windows 10通用应用程序同时针对Windows Store和Windows Phone。将\
:variable:`CMAKE_SYSTEM_VERSION`\ 变量指定为\ ``10.0``\ 或更高。

CMake根据\ :variable:`CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION`\ 变量的文档描述选择\
Windows SDK。

Windows Phone交叉编译
---------------------------------

为Windows Phone配置Visual Studio生成器的工具链文件可能是这样的：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME WindowsPhone)
  set(CMAKE_SYSTEM_VERSION 8.1)

Windows Store交叉编译
---------------------------------

为Windows Store配置Visual Studio生成器的工具链文件可能如下所示：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME WindowsStore)
  set(CMAKE_SYSTEM_VERSION 8.1)

.. _`Cross Compiling for ADSP SHARC/Blackfin`:

ADSP SHARC/Blackfin交叉编译
---------------------------------------

可以通过将\ :variable:`CMAKE_SYSTEM_NAME`\ 变量设置为\ ``ADSP``，将\
:variable:`CMAKE_SYSTEM_PROCESSOR`\ 变量设置为“部件号”来配置ADSP SHARC或Blackfin的交\
叉编译，不包括\ ``ADSP-``\ 前缀，例如\ ``21594``、\ ``SC589``\ 等。此值不区分大小写。

CMake将自动在默认安装位置搜索CCES或VDSP++安装，并选择找到的最新版本。如果安装了CCES，则将选\
择CCES而不是VDSP++。可以通过\ :variable:`CMAKE_ADSP_ROOT`\ 变量或\
:envvar:`ADSP_ROOT`\ 环境变量设置自定义安装路径。

编译器（\ ``cc21k``\ 或者\ ``ccblkfn``）是根据提供的\
:variable:`CMAKE_SYSTEM_PROCESSOR`\ 值自动选择的。

.. _`Cross Compiling for Android`:

Android交叉编译
---------------------------

工具链文件可以通过将\ :variable:`CMAKE_SYSTEM_NAME`\ 变量设置为\ ``Android``\ 来配置\
Android的交叉编译。进一步的配置特定于要使用的Android开发环境。

对于\ :ref:`Visual Studio Generators`，CMake希望安装\ :ref:`NVIDIA Nsight Tegra
Visual Studio Edition <Cross Compiling for Android with NVIDIA Nsight Tegra
Visual Studio Edition>`\ 或\ :ref:`Visual Studio tools for Android
<Cross Compiling for Android with the NDK>`。有关进一步的配置细节，请参阅这些小节。

对于\ :ref:`Makefile Generators`\ 和\ :generator:`Ninja`\ 生成器，CMake期望下列环境\
之一：

* :ref:`NDK <Cross Compiling for Android with the NDK>`
* :ref:`Standalone Toolchain <Cross Compiling for Android with a Standalone Toolchain>`

CMake使用以下步骤选择一个环境：

* 如果设置了\ :variable:`CMAKE_ANDROID_NDK`\ 变量，将使用指定位置的NDK。

* 否则，如果设置了\ :variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`\ 变量，则将使用指\
  定位置的独立工具链。

* 否则，如果\ :variable:`CMAKE_SYSROOT`\ 变量被设置为一个形式为\
  ``<ndk>/platforms/android-<api>/arch-<arch>``\ 的目录，\ ``<ndk>``\ 部分将被用作\
  :variable:`CMAKE_ANDROID_NDK`\ 的值，并且NDK将被使用。

* 否则，如果\ :variable:`CMAKE_SYSROOT`\ 变量被设置为一个形式为\
  ``<standalone-toolchain>/sysroot``\ 的目录，\ ``<standalone-toolchain>``\ 部分将\
  被用作\ :variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`\ 的值，并且将使用独立工具链。

* 否则，如果设置了cmake变量\ ``ANDROID_NDK``，它将被用作\
  :variable:`CMAKE_ANDROID_NDK`\ 的值，并且NDK将被使用。

* 否则，如果设置了cmake变量\ ``ANDROID_STANDALONE_TOOLCHAIN``，它将被用作\
  :variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`\ 的值，并且将使用独立工具链。

* 否则，如果设置了环境变量\ ``ANDROID_NDK_ROOT``\ 或\ ``ANDROID_NDK``，它将被用作\
  :variable:`CMAKE_ANDROID_NDK`\ 的值，并且NDK将被使用。

* 否则，如果设置了环境变量\ ``ANDROID_STANDALONE_TOOLCHAIN``，那么它将被用作\
  :variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`\ 的值，并且将使用独立工具链。

* 否则，将发出错误诊断，NDK或独立工具链都无法找到。

.. versionadded:: 3.20
  如果选择了Android NDK，则会在\ :variable:`CMAKE_ANDROID_NDK_VERSION`\ 变量中报告其\
  版本号。

.. _`Cross Compiling for Android with the NDK`:

使用NDK交叉编译Android
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

工具链文件可以配置\ :ref:`Makefile Generators`、:ref:`Ninja Generators`\ 或\
:ref:`Visual Studio Generators`\ 来针对Android进行交叉编译。

使用以下变量配置Android NDK的使用：

:variable:`CMAKE_SYSTEM_NAME`
  设置为\ ``Android``。必须指定以启用Android的交叉编译。

:variable:`CMAKE_SYSTEM_VERSION`
  设置为Android API级别。如果不指定，则确定值如下：

  * 如果设置了\ :variable:`CMAKE_ANDROID_API`\ 变量，则使用其值作为API级别。
  * 如果设置了\ :variable:`CMAKE_SYSROOT`\ 变量，则从包含sysroot的NDK目录结构中检测API级别。
  * 否则，将使用NDK中可用的最新API级别。

:variable:`CMAKE_ANDROID_ARCH_ABI`
  设置为Android ABI（架构）。如果未指定，该变量将默认为\ ``armeabi``、\ ``armeabi-v7a``\
  和\ ``arm64-v8a``\ 列表中第一个支持的ABI。:variable:`CMAKE_ANDROID_ARCH`\ 变量将从\
  ``CMAKE_ANDROID_ARCH_ABI``\ 自动计算。也请参阅\ :variable:`CMAKE_ANDROID_ARM_MODE`\
  和\ :variable:`CMAKE_ANDROID_ARM_NEON`\ 变量。

:variable:`CMAKE_ANDROID_NDK`
  设置为Android NDK根目录的绝对路径。如果未指定，则如\
  :ref:`上 <Cross Compiling for Android>`\ 所述选择此变量的默认值。

:variable:`CMAKE_ANDROID_NDK_DEPRECATED_HEADERS`
  设置为true值以使用已弃用的每个api级别的标头而不是统一的标头。如果未指定，默认值将为false，\
  除非使用不提供统一头文件的NDK。

:variable:`CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION`
  在NDK r19或更高版本上，这个变量必须取消设置或设置为\ ``clang``。在NDK r18或以下版本上，\
  将此设置为要选择作为编译器的NDK工具链的版本。如果未指定，则默认为最新可用的GCC工具链。

:variable:`CMAKE_ANDROID_STL_TYPE`
  设置为指定要使用的C++标准库。如果未指定，将按照变量文档中的描述选择默认值。

以下变量将自动计算并提供：

:variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_PREFIX`
  NDK工具链中binutils的绝对路径前缀。

:variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_SUFFIX`
  NDK工具链中binutils的主机平台后缀。


例如，一个工具链文件可能包含：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Android)
  set(CMAKE_SYSTEM_VERSION 21) # API level
  set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)
  set(CMAKE_ANDROID_NDK /path/to/android-ndk)
  set(CMAKE_ANDROID_STL_TYPE gnustl_static)

或者可以不使用工具链文件指定值：

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

工具链文件可以配置\ :ref:`Makefile Generators`\ 或\ :generator:`Ninja`\ 生成器，以\
Android为目标，使用独立的工具链进行交叉编译。

使用以下变量配置Android独立工具链：

:variable:`CMAKE_SYSTEM_NAME`
  设置为\ ``Android``。必须指定以启用Android的交叉编译。

:variable:`CMAKE_ANDROID_STANDALONE_TOOLCHAIN`
  设置为独立工具链根目录的绝对路径。必须存在\
  ``${CMAKE_ANDROID_STANDALONE_TOOLCHAIN}/sysroot``\ 目录。如果未指定，则如\
  :ref:`上 <Cross Compiling for Android>`\ 所述选择此变量的默认值。

:variable:`CMAKE_ANDROID_ARM_MODE`
  当独立工具链以ARM为目标时，可选择将此设置为\ ``ON``\ 以瞄准32位ARM而不是16位Thumb。有关\
  详细信息，请参阅变量文档。

:variable:`CMAKE_ANDROID_ARM_NEON`
  当独立工具链针对ARM v7时，可选择将这里设置为\ ``ON``\ 以针对ARM NEON设备。有关详细信息，\
  请参阅变量文档。

以下变量将自动计算并提供：

:variable:`CMAKE_SYSTEM_VERSION`
  从独立工具链中检测到的Android API级别。

:variable:`CMAKE_ANDROID_ARCH_ABI`
  从独立工具链中检测到的Android ABI。

:variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_PREFIX`
  独立工具链中\ ``binutils``\ 的绝对路径前缀。

:variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_SUFFIX`
  独立工具链中\ ``binutils``\ 的主机平台后缀。

例如，一个工具链文件可能包含：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Android)
  set(CMAKE_ANDROID_STANDALONE_TOOLCHAIN /path/to/android-toolchain)

或者可以不使用工具链文件指定值：

.. code-block:: console

  $ cmake ../src \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=/path/to/android-toolchain

.. _`Cross Compiling for Android with NVIDIA Nsight Tegra Visual Studio Edition`:

使用NVIDIA Nsight Tegra Visual Studio版本交叉编译Android
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

一个工具链文件，用来配置一个\ :ref:`Visual Studio Generators`，使用NVIDIA Nsight Tegra\
针对Android构建，可能是这样的：

.. code-block:: cmake

  set(CMAKE_SYSTEM_NAME Android)

:variable:`CMAKE_GENERATOR_TOOLSET`\ 可以设置为选择Nsight Tegra的“工具链版本”值。

参见目标属性：

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

.. _`Cross Compiling for iOS, tvOS, visionOS, or watchOS`:

交叉编译iOS、tvOS、visionOS或watchOS
---------------------------------------------------

对于交叉编译到iOS、tvOS、visionOS或watchOS，建议使用\ :generator:`Xcode`\ 生成器。也\
可以使用\ :generator:`Unix Makefiles`\ 或\ :generator:`Ninja`\ 生成器，但它们要求项\
目处理更多的领域，如目标CPU选择和代码签名。

通过将\ :variable:`CMAKE_SYSTEM_NAME`\ 变量设置为下表中的值，可以将任何苹果设备平台\
作为目标。默认情况下，选择最新的Device SDK。对于所有的Apple平台，可以通过设置\
:variable:`CMAKE_OSX_SYSROOT`\ 变量来选择不同的SDK（例如模拟器），尽管这很少是必要的（\
参见下面的\ :ref:`Switching Between Device and Simulator`\ ）。一个可用SDK的列表可以\
通过运行\ ``xcodebuild -showsdks``\ 获得。

========  ================= ==================== ================
OS        CMAKE_SYSTEM_NAME Device SDK (default) Simulator SDK
========  ================= ==================== ================
iOS       iOS               iphoneos             iphonesimulator
tvOS      tvOS              appletvos            appletvsimulator
visionOS  visionOS          xros                 xrsimulator
watchOS   watchOS           watchos              watchsimulator
========  ================= ==================== ================

例如，要为iOS创建CMake配置，以下命令就足够了：

.. code-block:: console

  cmake .. -GXcode -DCMAKE_SYSTEM_NAME=iOS

变量\ :variable:`CMAKE_OSX_ARCHITECTURES`\ 可用于设置设备和模拟器的体系结构。变量\
:variable:`CMAKE_OSX_DEPLOYMENT_TARGET`\ 用于设置iOS/tvOS/visionOS/watchOS的部署目标。

The next example installs five architectures in a universal binary for an iOS
library.  It adds the relevant ``-miphoneos-version-min=9.3`` or
``-mios-simulator-version-min=9.3`` compiler flag where appropriate.
Note that the :variable:`CMAKE_IOS_INSTALL_COMBINED` variable used in the
example is now deprecated, so this approach is no longer recommended.

.. code-block:: console

  $ cmake -S. -B_builds -GXcode \
      -DCMAKE_SYSTEM_NAME=iOS \
      "-DCMAKE_OSX_ARCHITECTURES=armv7;armv7s;arm64;i386;x86_64" \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=9.3 \
      -DCMAKE_INSTALL_PREFIX=`pwd`/_install \
      -DCMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH=NO \
      -DCMAKE_IOS_INSTALL_COMBINED=YES

例子：

.. code-block:: cmake

  # CMakeLists.txt
  cmake_minimum_required(VERSION 3.14)
  project(foo)
  add_library(foo foo.cpp)
  install(TARGETS foo DESTINATION lib)

安装：

.. code-block:: console

    $ cmake --build _builds --config Release --target install

检查库：

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

嵌入式Apple平台的一些构建构件需要强制代码签名。如果正在使用\ :generator:`Xcode`\ 生成器，\
并且需要或希望代码签名，则可以通过\ ``CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM`` CMake\
变量指定开发团队ID。这个团队ID将被包含在生成的Xcode项目中。默认情况下，CMake在内部配置阶段\
（即编译器ID和特性检测）避免了代码签名的需要。

.. _`Switching Between Device and Simulator`:

在设备和模拟器之间切换
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

在为任何嵌入式平台配置时，可以针对实际设备或模拟器进行配置。两者都有自己独立的SDK，但CMake只\
支持在配置阶段指定单个SDK。这意味着开发人员必须在配置时选择其中一个。当使用\
:generator:`Xcode`\ 生成器时，这不是一个限制，因为Xcode仍然允许你为设备或模拟器构建，即使\
配置只对两者中的一个执行。在Xcode IDE中，为选定的“目标”平台执行构建。当从命令行构建时，可以\
通过向底层构建工具（\ ``xcodebuild``）传递\ ``-sdk``\ 选项来直接指定所需的sdk。例如：

.. code-block:: console

  $ cmake --build ... -- -sdk iphonesimulator

请注意，配置期间所做的检查是针对配置时SDK执行的，可能不适用于其他SDK。\
:command:`find_package`、\ :command:`find_library`\ 等命令只存储和使用配置的SDK/平台\
的详细信息，所以如果想在设备和模拟器构建之间切换，它们可能会出现问题。你可以遵循以下规则使设\
备+模拟器配置工作：

- 使用明确的\ ``-l``\ 链接器标志，例如\ ``target_link_libraries(foo PUBLIC "-lz")``

- 使用显式的\ ``-framework``\ 链接器标志，例如\
  ``target_link_libraries(foo PUBLIC "-framework CoreFoundation")``

- :command:`find_package`\ 仅用于安装了\ :variable:`CMAKE_IOS_INSTALL_COMBINED`\
  特性的库
