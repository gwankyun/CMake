CMAKE_MSVC_DEBUG_INFORMATION_FORMAT
-----------------------------------

.. versionadded:: 3.25

选择针对MSVC ABI的MSVC调试信息格式。该变量用于在创建所有目标时初始化它们的\
:prop_tgt:`MSVC_DEBUG_INFORMATION_FORMAT`\ 属性。它还通过调用\ :command:`try_compile`\
命令传播到测试项目中。

The allowed values are:

.. include:: ../prop_tgt/MSVC_DEBUG_INFORMATION_FORMAT-VALUES.txt

Use :manual:`generator expressions <cmake-generator-expressions(7)>` to
support per-configuration specification.  For example, the code:

.. code-block:: cmake

  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>")

selects for all following targets the program database debug information format
for the Debug configuration.

If this variable is not set, the :prop_tgt:`MSVC_DEBUG_INFORMATION_FORMAT`
target property will not be set automatically.  If that property is not set,
CMake selects a debug information format using the default value
``$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>``, if supported by the
compiler, and otherwise ``$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>``.

.. note::

  This variable has effect only when policy :policy:`CMP0141` is set to ``NEW``
  prior to the first :command:`project` or :command:`enable_language` command
  that enables a language using a compiler targeting the MSVC ABI.
