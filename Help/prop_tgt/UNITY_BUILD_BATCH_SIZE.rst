UNITY_BUILD_BATCH_SIZE
----------------------

.. versionadded:: 3.16

指定当\ :prop_tgt:`UNITY_BUILD`\ 目标属性启用unity构建时，可以合并到任何一个unity源文\
件中的源文件的最大数量。原始源文件将分布在尽可能多的unity源文件中，以遵守此限制。

The initial value for this property is taken from the
:variable:`CMAKE_UNITY_BUILD_BATCH_SIZE` variable when the target is created.
If that variable has not been set, the initial value will be 8.

The batch size needs to be selected carefully.  If set too high, the size of
the combined source files could result in the compiler using excessive memory
or hitting other similar limits.  In extreme cases, this can even result in
build failure.  On the other hand, if the batch size is too low, there will be
little gain in build performance.

Although strongly discouraged, the batch size may be set to a value of 0 to
combine all the sources for the target into a single unity file, regardless of
how many sources are involved.  This runs the risk of creating an excessively
large unity source file and negatively impacting the build performance, so
a value of 0 is not generally recommended.
