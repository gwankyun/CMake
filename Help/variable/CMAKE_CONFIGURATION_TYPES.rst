CMAKE_CONFIGURATION_TYPES
-------------------------

指定多配置生成器（例如\ :ref:`Visual Studio <Visual Studio Generators>`、\
:generator:`Xcode`\ 或\ :generator:`Ninja Multi-Config`）上可用的构建类型（配置），\
以\ :ref:`分号分隔列表 <CMake Language Lists>`\ 为格式。典型的条目包括\ ``Debug``、\
``Release``、\ ``RelWithDebInfo``\ 和\ ``MinSizeRel``，但是也可以定义自定义构建类型。

This variable is initialized by the first :command:`project` or
:command:`enable_language` command called in a project when a new build
tree is first created.  If the :envvar:`CMAKE_CONFIGURATION_TYPES`
environment variable is set, its value is used.  Otherwise, the default
value is generator-specific.

Depending on the situation, the values in this variable may be treated
case-sensitively or case-insensitively.  See :ref:`Build Configurations`
for discussion of this and other related topics.

For single-config generators, see :variable:`CMAKE_BUILD_TYPE`.
