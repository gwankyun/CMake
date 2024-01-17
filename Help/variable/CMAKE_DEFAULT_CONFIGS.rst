CMAKE_DEFAULT_CONFIGS
---------------------

.. versionadded:: 3.17

如果没有在\ :generator:`Ninja Multi-Config`\ 生成器中指定\ ``:<Config>``\ 后缀，则在\
``build.ninja``\ 中指定要为目标构建配置\ :ref:`分号分隔列表 <CMake Language Lists>`。\
如果设置为\ ``all``，则使用\ :variable:`CMAKE_CROSS_CONFIGS`\ 中的所有配置。如果未指定，\
则默认为\ :variable:`CMAKE_DEFAULT_BUILD_TYPE`。

For example, if you set :variable:`CMAKE_DEFAULT_BUILD_TYPE` to ``Release``,
but set ``CMAKE_DEFAULT_CONFIGS`` to ``Debug`` or ``all``, all
``<target>`` aliases in ``build.ninja`` will resolve to ``<target>:Debug`` or
``<target>:all``, but custom commands will still use the ``Release``
configuration.

The value of this variable must be a subset of :variable:`CMAKE_CROSS_CONFIGS`
or be the same as :variable:`CMAKE_DEFAULT_BUILD_TYPE`. It must not be
specified if :variable:`CMAKE_DEFAULT_BUILD_TYPE` or
:variable:`CMAKE_CROSS_CONFIGS` is not used.
