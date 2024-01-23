CMAKE_MSVC_RUNTIME_LIBRARY
--------------------------

.. versionadded:: 3.15

选择以MSVC ABI为目标的编译器使用的MSVC运行时库。该变量用于在创建所有目标时初始化\
:prop_tgt:`MSVC_RUNTIME_LIBRARY`\ 属性。它还通过调用\ :command:`try_compile`\ 命令\
传播到测试项目中。

The allowed values are:

.. include:: ../prop_tgt/MSVC_RUNTIME_LIBRARY-VALUES.txt

Use :manual:`generator expressions <cmake-generator-expressions(7)>` to
support per-configuration specification.  For example, the code:

.. code-block:: cmake

  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

selects for all following targets a multi-threaded statically-linked runtime
library with or without debug information depending on the configuration.

If this variable is not set then the :prop_tgt:`MSVC_RUNTIME_LIBRARY` target
property will not be set automatically.  If that property is not set then
CMake uses the default value ``MultiThreaded$<$<CONFIG:Debug>:Debug>DLL``
to select a MSVC runtime library.

.. note::

  This variable has effect only when policy :policy:`CMP0091` is set to ``NEW``
  prior to the first :command:`project` or :command:`enable_language` command
  that enables a language using a compiler targeting the MSVC ABI.
