IDE集成指南
*********************

.. only:: html

  .. contents::

引言
============

集成开发环境（IDE）可能需要与CMake集成，以改善CMake用户的开发体验。本文档列出了此类集成的推荐最佳实践。

捆绑
========

许多IDE厂商想要在他们的IDE中捆绑一个CMake的副本。捆绑CMake的IDE应该向用户提供使用外部CMake安装而不是捆绑的CMake安装的选项，以防捆绑的副本过时而用户想要使用一个新的版本。

虽然IDE供应商可能会试图将不同版本的CMake与他们的应用程序捆绑在一起，但不建议这样做。CMake有强大的向后兼容性保证，没有理由不使用比项目需要的更新版本的CMake，或者实际上是最新版本的CMake。因此，建议将CMake与他们的应用程序捆绑在一起的IDE供应商在发布时始终包含最新的CMake补丁版本。

作为建议，IDE也可以在CMake的同时提供一个Ninja构建系统的副本。Ninja在所有支持CMake的平台上性能和兼容性都不错。IDE应该捆绑Ninja 1.10或更高版本，以包含支持Fortran构建所需的特性。

预设
=======

CMake支持一种名为 ``CMakePresets.json`` 的文件格式，以及与之对应的特定于用户的 ``CMakeUserPresets.json``。这个文件包含用户可能需要的各种配置预设的信息。每个预设可能有一个不同的编译器，构建标志，等等。该格式的细节在 :manual:`cmake(1)` 手册中解释。

我们鼓励IDE厂商像CMake一样阅读和评估这个文件，并向用户提供文件中列出的预设。用户应该能够看到（可能也可以编辑）为给定预设定义的CMake缓存变量、环境变量和命令行选项。IDE应该根据这些设置构造适当的 :manual:`cmake(1)` 命令行参数列表，而不是直接使用 ``--preset=`` 选项。``--preset=`` 选项仅供命令行用户方便使用，而不应该被IDE使用。

例如，如果一个名为 ``ninja`` 的预设值指定 ``Ninja`` 为生成器，并指定 ``${sourceDir}/build`` 为构建目录，而不是运行目录：

.. code-block:: console

  cmake -S /path/to/source --preset=ninja

IDE应该计算 ``ninja`` 预设的设置，然后运行：

.. code-block:: console

  cmake -S /path/to/source -B /path/to/source/build -G Ninja

虽然读取、解析和计算 ``CMakePresets.json`` 的内容很容易，但它并不简单。除了文档之外，IDE厂商可能还希望参考CMake源代码和测试用例，以更好地理解如何实现这种格式。:download:`该文件 <../../manual/presets/schema.json>` 为 ``CMakePresets.json`` 格式提供了一个机器可读的JSON模式，IDE供应商可能会发现该模式对于验证和提供编辑帮助很有用。

配置
===========

调用 :manual:`cmake(1)` 来运行配置步骤的IDE可能希望接收关于构建将生成的构件的信息，以及用于构建构件的包含目录、编译定义等。这些信息可以通过使用 :manual:`File API <cmake-file-api(7)>` 获得。File API的手册页包含了关于API以及如何调用它的更多信息。:manual:`Server mode <cmake-server(7)>` 从CMake 3.20起被删除，不该在CMake 3.14或更高版本上使用。

IDE应该避免创建多余的构建树，只在用户希望切换到不同的编译器、使用不同的编译标志等情况下才创建多个构建树。特别是，IDE不应该创建多个单配置构建树，这些树除了 :variable:`CMAKE_BUILD_TYPE` 不同外，都具有相同的属性，从而等效创建一个多配置环境。相反，应该使用 :generator:`Ninja Multi-Config` 生成器和 :manual:`File API <cmake-file-api(7)>` 来获得构建配置列表。

IDE不应该在Makefile或Ninja生成器中使用“额外的生成器”，这些生成器除了生成Makefile或Ninja文件外还生成IDE项目文件。相反，应该使用 :manual:`File API <cmake-file-api(7)>` 来获取构建构件的列表。

编译
========

如果使用Makefile或Ninja生成器生成构建树，不建议直接调用 ``make`` make或 ``ninja``。相反，建议IDE使用 ``--build`` 参数调用 :manual:`cmake(1)`，该参数将反过来调用适当的构建工具。

如果使用了IDE项目生成器，比如 :generator:`Xcode` 或Visual Studio生成器，并且IDE理解所使用的项目格式，那么IDE应该读取项目文件，并以相同的方式构建它。

:manual:`File API <cmake-file-api(7)>` 可以用于从构建树中获取构建配置的列表，IDE应该将此列表呈现给用户以选择构建配置。

测试
=======

:manual:`ctest(1)` 支持输出包含可用测试和测试配置信息的JSON格式。想要运行CTest的IDE应该获得此信息，并使用它向用户提供测试列表。

IDE不应调用构建系统生成的 ``test`` 目标，而是应该直接调用 :manual:`ctest(1)`。
