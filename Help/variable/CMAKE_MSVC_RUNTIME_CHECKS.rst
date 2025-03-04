CMAKE_MSVC_RUNTIME_CHECKS
-------------------------

.. versionadded:: 4.0

当目标平台采用MSVC ABI时，用于选择要启用的运行时检查列表。\
此变量用于在所有目标创建时初始化其\ :prop_tgt:`MSVC_RUNTIME_CHECKS`\ 属性。\
它也会通过调用\ :command:`try_compile`\ 命令传递到测试项目中。

The allowed values are:

.. include:: ../prop_tgt/MSVC_RUNTIME_CHECKS-VALUES.txt

Use :manual:`generator expressions <cmake-generator-expressions(7)>` to
support per-configuration specification. For example, the code:

.. code-block:: cmake

  set(CMAKE_MSVC_RUNTIME_CHECKS "$<$<CONFIG:Debug,RelWithDebInfo>:PossibleDataLoss;UninitializedVariable>")

enables for the target ``foo`` the possible data loss and uninitialized variables checks
for the ``Debug`` and ``RelWithDebInfo`` configurations.

If this variable is not set, the :prop_tgt:`MSVC_RUNTIME_CHECKS`
target property will not be set automatically.  If that property is not set,
CMake selects runtime checks using the default value
``$<$<CONFIG:Debug>:StackFrameErrorCheck;UninitializedVariable>``,
if supported by the compiler, or empty value otherwise.

.. note::

  This variable has effect only when policy :policy:`CMP0184` is set to ``NEW``
  prior to the first :command:`project` or :command:`enable_language` command
  that enables a language using a compiler targeting the MSVC ABI.
