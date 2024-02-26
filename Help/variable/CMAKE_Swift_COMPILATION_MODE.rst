CMAKE_Swift_COMPILATION_MODE
----------------------------

.. versionadded:: 3.29

指定Swift如何编译目标。该变量用于在创建目标时初始化目标的\
:prop_tgt:`Swift_COMPILATION_MODE`\ 属性。

The allowed values are:

.. include:: ../prop_tgt/Swift_COMPILATION_MODE-VALUES.txt

Use :manual:`generator expressions <cmake-generator-expressions(7)>` to support
per-configuration specification. For example, the code:

.. code-block:: cmake

   set(CMAKE_Swift_COMPILATION_MODE
     "$<IF:$<CONFIG:Release>,wholemodule,incremental>")

sets the default Swift compilation mode to wholemodule mode when building a
release configuration and to incremental mode in other configurations.

If this variable is not set then the :prop_tgt:`Swift_COMPILATION_MODE` target
property will not be set automatically. If that property is unset then CMake
uses the default value ``incremental`` to build the Swift source files.

.. note::

   This property only has effect when policy :policy:`CMP0157` is set to ``NEW``
   prior to the first :command:`project` or :command:`enable_language` command
   that enables the Swift language.
