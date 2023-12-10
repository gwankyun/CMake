CXX_SCAN_FOR_MODULES
--------------------

.. versionadded:: 3.28

``CXX_SCAN_FOR_MODULES``\ 是一个布尔值，指定CMake是否扫描源代码中的C++模块依赖关系。\
关于目标范围的设置，请参见\ :prop_tgt:`CXX_SCAN_FOR_MODULES`。

When this property is set ``ON``, CMake will scan the source at build time and
add module dependency information to the compile line as necessary.  When this
property is set ``OFF``, CMake will not scan the source at build time.  When
this property is unset, the :prop_tgt:`CXX_SCAN_FOR_MODULES` property is
consulted.

Note that scanning is only performed if C++20 or higher is enabled for the
target and the source uses the ``CXX`` language.  Scanning for modules in
sources belonging to file sets of type ``CXX_MODULES`` is always performed.
