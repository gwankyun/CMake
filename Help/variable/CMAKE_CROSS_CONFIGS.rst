CMAKE_CROSS_CONFIGS
-------------------

.. versionadded:: 3.17

指定\ :generator:`Ninja Multi-Config`\ 生成器中所有\ ``build-<Config>.ninja``\
文件中可用配置的\ :ref:`分号分隔列表 <CMake Language Lists>`。这个变量激活交叉配置模式。\
可以从任何\ ``build-<Config>.ninja``\ 文件构建来自该变量中指定的每个配置的目标。自定义命\
令将使用本地配置来\ ``build-<Config>.ninja``。如果设置为\ ``all``，则\
:variable:`CMAKE_CONFIGURATION_TYPES`\ 中的所有配置都是交叉配置。如果未指定或为空，\
则每个\ ``build-<Config>.ninja``\ 文件将只包含其自身配置的构建规则。

The value of this variable must be a subset of
:variable:`CMAKE_CONFIGURATION_TYPES`.
