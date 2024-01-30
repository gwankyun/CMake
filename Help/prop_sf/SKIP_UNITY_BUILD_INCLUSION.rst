SKIP_UNITY_BUILD_INCLUSION
--------------------------

.. versionadded:: 3.16

将此属性设置为true可确保当其关联目标的\ :prop_tgt:`UNITY_BUILD`\ 属性设置为true时，源文\
件将被unity构建跳过。源文件将以与禁用unity构建时相同的方式自行编译。

This property helps with "ODR (One definition rule)" problems where combining
a particular source file with others might lead to build errors or other
unintended side effects.

Note that sources which are scanned for C++ modules (see
:manual:`cmake-cxxmodules(7)`) are not eligible for unity build inclusion and
will automatically be excluded.
