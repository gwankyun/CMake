CMAKE_GENERATOR
---------------

.. versionadded:: 3.15

.. include:: ENV_VAR.txt

指定CMake默认生成器，当没有提供\ :option:`-G <cmake -G>`\ 的生成器时使用。如果提供的值\
没有命名CMake知道的生成器，则使用内部默认值。无论哪种方式，生成的生成器选择都存储在\
:variable:`CMAKE_GENERATOR`\ 变量中。

Some generators may be additionally configured using the environment
variables:

* :envvar:`CMAKE_GENERATOR_PLATFORM`
* :envvar:`CMAKE_GENERATOR_TOOLSET`
* :envvar:`CMAKE_GENERATOR_INSTANCE`
