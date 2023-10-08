ADDITIONAL_CLEAN_FILES
----------------------

.. versionadded:: 3.15

作为全局\ ``clean``\ 目标的一部分将被删除的文件或目录\ :ref:`;-list <CMake Language Lists>`。\
它可以用来指定作为构建目标的一部分生成的文件和目录，或者以某种方式直接与目标相关联的文件和目\
录（例如，作为运行目标的结果创建的文件和目录）。

For custom targets, if such files can be captured as outputs or byproducts
instead, then that should be preferred over adding them to this property.
If an additional clean file is used by multiple targets or isn't
target-specific, then the :prop_dir:`ADDITIONAL_CLEAN_FILES` directory
property may be the more appropriate property to use.

Relative paths are allowed and are interpreted relative to the
current binary directory.

Contents of ``ADDITIONAL_CLEAN_FILES`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.

This property only works for the :generator:`Ninja` and the Makefile
generators.  It is ignored by other generators.
