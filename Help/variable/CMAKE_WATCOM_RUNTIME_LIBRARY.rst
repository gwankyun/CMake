CMAKE_WATCOM_RUNTIME_LIBRARY
----------------------------

.. versionadded:: 3.24

选择Watcom运行时库，供针对Watcom ABI的编译器使用。该变量用于在创建所有目标时初始化它们的\
:prop_tgt:`WATCOM_RUNTIME_LIBRARY`\ 属性。它还通过调用\ :command:`try_compile`\
命令传播到测试项目中。

The allowed values are:

.. include:: ../prop_tgt/WATCOM_RUNTIME_LIBRARY-VALUES.txt

Use :manual:`generator expressions <cmake-generator-expressions(7)>` to
support per-configuration specification.

For example, the code:

.. code-block:: cmake

  set(CMAKE_WATCOM_RUNTIME_LIBRARY "MultiThreaded")

selects for all following targets a multi-threaded statically-linked runtime
library.

If this variable is not set then the :prop_tgt:`WATCOM_RUNTIME_LIBRARY` target
property will not be set automatically.  If that property is not set then
CMake uses the default value ``MultiThreadedDLL`` on Windows and
``SingleThreaded`` on other platforms to select a Watcom runtime library.

.. note::

  This variable has effect only when policy :policy:`CMP0136` is set to ``NEW``
  prior to the first :command:`project` or :command:`enable_language` command
  that enables a language using a compiler targeting the Watcom ABI.
