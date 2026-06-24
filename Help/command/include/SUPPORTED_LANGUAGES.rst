支持的编程语言包括：

``C``

``CXX``
  C++

``CSharp``
  .. versionadded:: 3.8

  C#

``CUDA``
  .. versionadded:: 3.8

``OBJC``
  .. versionadded:: 3.16

  Objective-C

``OBJCXX``
  .. versionadded:: 3.16

  Objective-C++

``Fortran``

``HIP``
  .. versionadded:: 3.21

``ISPC``
  .. versionadded:: 3.18

``Swift``
  .. versionadded:: 3.15

``ASM``
  C 编译器所支持的汇编语言。

  如果启用 ``ASM``，请将其列在最后，以便 CMake 能够检查
  ``C`` 或 ``CXX`` 编译器是否支持汇编。

``ASM_NASM``
  Netwide 汇编器

``ASM_MARMASM``
  .. versionadded:: 3.26

  Microsoft 汇编器（ARM、ARM64）

``ASM_MASM``
  Microsoft 汇编器（x86、x64）

``ASM_POASM``
  .. versionadded:: 4.4

  Pelles C 工具链汇编器。

``ASM-ATT``
