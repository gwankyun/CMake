JOB_POOL_PRECOMPILE_HEADER
--------------------------

.. versionadded:: 3.17

Ninja专用：用于生成预编译头文件的池。

The number of parallel compile processes could be limited by defining
pools with the global :prop_gbl:`JOB_POOLS`
property and then specifying here the pool name.

For instance:

.. code-block:: cmake

  set_property(TARGET myexe PROPERTY JOB_POOL_PRECOMPILE_HEADER two_jobs)

This property is initialized by the value of
:variable:`CMAKE_JOB_POOL_PRECOMPILE_HEADER`.

If neither ``JOB_POOL_PRECOMPILE_HEADER`` nor
:variable:`CMAKE_JOB_POOL_PRECOMPILE_HEADER` are set then
:prop_tgt:`JOB_POOL_COMPILE` will be used for this task.
