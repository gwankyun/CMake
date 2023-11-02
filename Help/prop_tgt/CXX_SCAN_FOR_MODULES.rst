CXX_SCAN_FOR_MODULES
--------------------

.. versionadded:: 3.28

``CXX_SCAN_FOR_MODULES``\ 是一个布尔值，指定CMake是否扫描目标中的C++源以查找模块依赖关系。\
另请参阅\ :prop_sf:`CXX_SCAN_FOR_MODULES`，了解每个源的设置，如果设置了，将覆盖目标范围\
的设置。

This property is initialized by the value of the
:variable:`CMAKE_CXX_SCAN_FOR_MODULES` variable if it is set when a target is
created.

When this property is set ``ON`` or unset, CMake will scan the target's
``CXX`` sources at build time and add module dependency information to the
compile line as necessary.  When this property is set ``OFF``, CMake will not
scan the target's ``CXX`` sources at build time.

Note that scanning is only performed if C++20 or higher is enabled for the
target.  Scanning for modules in the target's sources belonging to file sets
of type ``CXX_MODULES`` is always performed.
