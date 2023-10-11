COMPILE_WARNING_AS_ERROR
------------------------

.. versionadded:: 3.24

指定是否将编译上的警告视为错误。如果启用，则添加一个标志以将编译上的警告视为错误。如果在\
:manual:`cmake(1)`\ 命令行上给出了\ :option:`cmake --compile-no-warning-as-error`\
选项，则忽略此属性。

This property is not implemented for all compilers.  It is silently ignored
if there is no implementation for the compiler being used.  The currently
implemented :variable:`compiler IDs <CMAKE_<LANG>_COMPILER_ID>` are:

* ``GNU``
* ``Clang``
* ``AppleClang``
* ``Fujitsu``
* ``FujitsuClang``
* ``IBMClang``
* ``Intel``
* ``IntelLLVM``
* ``LCC``
* ``MSVC``
* ``NVHPC``
* ``NVIDIA`` (CUDA)
* ``QCC``
* ``SunPro``
* ``Tasking``
* ``TI``
* ``VisualAge``
* ``XL``
* ``XLClang``

This property is initialized by the value of the variable
:variable:`CMAKE_COMPILE_WARNING_AS_ERROR` if it is set when a target is
created.
