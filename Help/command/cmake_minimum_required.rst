cmake_minimum_required
----------------------

cmake版本的最低要求。

.. code-block:: cmake

  cmake_minimum_required(VERSION <min>[...<policy_max>] [FATAL_ERROR])

.. versionadded:: 3.12
  可选的\ ``<policy_max>``\ 版本行为；在旧版本的CMake中会被忽略。

为项目设置所需的CMake最低版本。\
同时按如下说明更新策略设置。

``<min>``\ 和可选的\ ``<policy_max>``\ 均为CMake版本号，格式为\
``major.minor[.patch[.tweak]]``，其中\ ``...``\ 为字面符号。

如果当前运行的CMake版本低于所需的\ ``<min>``\ 版本，它将停止处理该项目并报告错误。\
可选的\ ``<policy_max>``\ 版本（若指定）必须至少与\ ``<min>``\ 版本相同，并且会设置\
`Policy Version`_。\
如果运行的CMake版本早于3.12，额外的\ ``...``\ 会被视为版本号组件的分隔符，导致\ ``...<max>``\
部分被忽略，从而保留3.12之前基于\ ``<min>``\ 设置策略的行为。

此命令会将\ :variable:`CMAKE_MINIMUM_REQUIRED_VERSION`\ 变量的值设置为\ ``<min>``。

``FATAL_ERROR``\ 选项可被CMake 2.6及更高版本接受，但会被忽略。不过仍应指定该选项，这样在\
使用CMake 2.4及更低版本时，系统会报错而非仅给出警告。

.. note::
  请在顶层\ ``CMakeLists.txt``\ 文件开头调用\ ``cmake_minimum_required()``\ 命令，\
  甚至要在调用\ :command:`project`\ 命令之前执行。在调用其他可能受版本和策略设置影响的命令\
  之前，先确定版本和策略设置至关重要。另请参阅策略\ :policy:`CMP0000`。

  在\ :command:`function`\ 内调用\ ``cmake_minimum_required()``\ 时，部分效果会被限制\
  在函数作用域内。例如，:variable:`CMAKE_MINIMUM_REQUIRED_VERSION`\ 变量不会在调用作用\
  域中被设置。不过，函数不会引入自己的策略作用域，因此调用者的策略设置\ *会*\ 受到影响（见下文）。\
  由于这种部分影响调用作用域、部分不影响的情况，通常不建议在函数内调用\
  ``cmake_minimum_required()``。

.. _`Policy Version`:

策略版本
^^^^^^^^^^^^^^

``cmake_minimum_required(VERSION <min>[...<max>])``\ 会隐式调用

.. code-block:: cmake

  cmake_policy(VERSION <min>[...<max>])

.. include:: POLICY_VERSION.txt

.. include:: DEPRECATED_POLICY_VERSIONS.txt

另请参阅
^^^^^^^^

* :command:`cmake_policy`
