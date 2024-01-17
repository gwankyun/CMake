CMAKE_DEFAULT_BUILD_TYPE
------------------------

.. versionadded:: 3.17

指定在\ :generator:`Ninja Multi-Config`\ 生成器的\ ``build.ninja``\ 文件中默认使用的配置。\
如果指定了这个变量，\ ``build.ninja``\ 默认使用\ ``build-<Config>.ninja``\ 中的构建规则。\
所有自定义命令都使用此配置执行。如果未指定该变量，则使用\ :variable:`CMAKE_CONFIGURATION_TYPES`\
中的第一项。

The value of this variable must be one of the items from
:variable:`CMAKE_CONFIGURATION_TYPES`.
