CMAKE_TRY_COMPILE_CONFIGURATION
-------------------------------

用于\ :command:`try_compile`\ 和\ :command:`try_run`\ 项目的构建配置。

Projects built by :command:`try_compile` and :command:`try_run` are built
synchronously during the CMake configuration step.  Therefore a specific build
configuration must be chosen even if the generated build system
supports multiple configurations.
