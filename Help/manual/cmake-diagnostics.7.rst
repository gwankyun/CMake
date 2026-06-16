.. cmake-manual-description: CMake Diagnostics Reference

cmake-diagnostics(7)
********************

.. only:: html

   .. contents::

.. _cmake-diagnostics-intro:

简介
============

.. versionadded:: 4.4

CMake 诊断是 CMake 对项目配置及其构建系统生成过程中的某些建议信息进行分类和呈现的机制。\
这些诊断可以看作是构建系统中等效的编译器警告。诊断针对以下几类潜在问题提供反馈：

* 可能影响构建成功的问题。

* 可能影响构建正确性的问题。

* 可能影响项目打包正确性的问题。

* 可能影响项目使用更新版本依赖项进行构建的能力的问题。

* 可能影响项目使用更新版本 CMake 进行构建的能力的问题。

控制诊断
=======================

每个诊断类别都有一个关联的操作，当该诊断被触发时执行。大多数类别默认会发出警告。可用的操作在
:command:`cmake_diagnostic` 命令文档中有描述。

CMake 维护一个诊断状态栈，类似于策略状态。栈的初始状态由四个因素决定，按优先级顺序为：

* 与诊断关联的默认操作。

* 存储在 CMake 变量缓存中的与诊断关联的操作，用于在 CMake 运行之间持久化初始状态。

* :manual:`CMake Presets <cmake-presets(7)>` 的 :preset:`configurePresets.warnings`
  和 :preset:`configurePresets.errors` 字段。

* :option:`-W[no-][error=] <cmake -W>` 命令行参数。

.. note::

  由于命令行参数以递归方式并按指定顺序操作，某些诊断参数的组合可能导致后面的参数完全覆盖前面\
  参数的操作。例如， ``-Wno-child -Wparent`` 将导致启用 ``child`` 警告，因为 ``-Wparent``
  会将 ``parent`` 和 ``child`` 的严重性都提升到至少 ``WARN`` 级别。CMake 预设按从最早祖先
  到最晚祖先的顺序进行评估。

在脚本执行期间，可以使用 :command:`cmake_diagnostic` 命令查询或更改状态，或执行有限的栈操作。

当诊断在配置期间发出时（或 CMake 在脚本模式下运行时的脚本执行期间），当前的诊断状态控制操作。
在生成期间发出的诊断，或在配置和生成阶段之外发出的诊断，必须使用记录的状态信息。虽然 CMake
努力以匹配记录状态与最终导致诊断发出的 CMake 命令时的状态的方式保留此信息，但 CMake 有时可能
会回退到子目录处理完成时的状态，甚至是根状态。这可能会限制 :command:`cmake_diagnostic`
命令控制此类诊断的能力，尤其是在从函数或包含文件中调用时。对于与 CMake 命令不直接耦合的诊断，
这种情况尤为明显。

诊断类别
=====================

定义了以下类别：

.. toctree::
   :maxdepth: 1

   /diagnostic/CMD_AUTHOR
   /diagnostic/CMD_DEPRECATED
   /diagnostic/CMD_EXPERIMENTAL
   /diagnostic/CMD_INSTALL_ABSOLUTE_DESTINATION
   /diagnostic/CMD_POLICY
   /diagnostic/CMD_UNINITIALIZED
   /diagnostic/CMD_UNUSED_CLI
