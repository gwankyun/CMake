
支持的语言包括 ``C``、\ ``CXX``\ （即C++）、\ ``CSharp``\ （即C#）、\ ``CUDA``、\
``OBJC``\ （即Objective-C）、\ ``OBJCXX``\ （即Objective-C++）、\ ``Fortran``、\
``HIP``、\ ``ISPC``、\ ``Swift``、\ ``ASM``、\ ``ASM_NASM``、\ ``ASM_MARMASM``、\
``ASM_MASM``\ 和\ ``ASM-ATT``。

  .. versionadded:: 3.8
    增加了对\ ``CSharp``\ 和\ ``CUDA``\ 的支持。

  .. versionadded:: 3.15
    增加了对\ ``Swift``\ 的支持。

  .. versionadded:: 3.16
    增加了对\ ``OBJC``\ 和\ ``OBJCXX``\ 的支持。

  .. versionadded:: 3.18
    增加了对\ ``ISPC``\ 的支持。

  .. versionadded:: 3.21
    增加了对\ ``HIP``\ 的支持。

  .. versionadded:: 3.26
    增加了对\ ``ASM_MARMASM``\ 的支持。

如果要启用\ ``ASM``，请将其列在最后，以便CMake能够检查其他语言（如\ ``C``\ ）的编译器是否\
也适用于汇编语言。
