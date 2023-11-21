SKIP_BUILD_RPATH
----------------

是否为构建树使用rpath。

``SKIP_BUILD_RPATH`` is a boolean specifying whether to skip automatic
generation of an rpath allowing the target to run from the build tree,
see also the :prop_tgt:`BUILD_RPATH` target property.
This property is initialized by the value of the variable
:variable:`CMAKE_SKIP_BUILD_RPATH` if it is set when a target is created.
