AUTOGEN_BETTER_GRAPH_MULTI_CONFIG
---------------------------------

.. versionadded:: 3.29

``AUTOGEN_BETTER_GRAPH_MULTI_CONFIG``\ 是一个布尔属性，可以在目标上设置，以便为多配置\
生成器提供更好的依赖关系图。当启用此属性时，\ ``CMake``\ 将生成更多的每个配置目标。因此，\
对于多配置生成器，依赖关系图将更加准确，并且可以避免一些重新编译。

If the Qt version is 6.8 or newer, this property is enabled by default.
If the Qt version is older than 6.8, this property is disabled by default.
Consult the Qt documentation to check if the property can be enabled for older
Qt versions.

See the :manual:`cmake-qt(7)` manual for more information on using CMake
with Qt.

This property is initialized by the
:variable:`CMAKE_AUTOGEN_BETTER_GRAPH_MULTI_CONFIG` variable if it is set when
a target is created.
