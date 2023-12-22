CMAKE_BUILD_TYPE
----------------

指定单配置生成器的构建类型（例如\ :ref:`Makefile Generators`\ 或\ :generator:`Ninja`）。\
典型的值包括\ ``Debug``、\ ``Release``、\ ``RelWithDebInfo``\ 和\ ``MinSizeRel``，\
但是也可以定义自定义构建类型。

This variable is initialized by the first :command:`project` or
:command:`enable_language` command called in a project when a new build
tree is first created.  If the :envvar:`CMAKE_BUILD_TYPE` environment
variable is set, its value is used.  Otherwise, a toolchain-specific
default is chosen when a language is enabled.  The default value is often
an empty string, but this is usually not desirable and one of the other
standard build types is usually more appropriate.

Depending on the situation, the value of this variable may be treated
case-sensitively or case-insensitively.  See :ref:`Build Configurations`
for discussion of this and other related topics.

For multi-config generators, see :variable:`CMAKE_CONFIGURATION_TYPES`.
