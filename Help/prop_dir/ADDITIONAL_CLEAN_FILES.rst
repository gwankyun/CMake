ADDITIONAL_CLEAN_FILES
----------------------

.. versionadded:: 3.15

作为全局\ ``clean``\ 目标的一部分将被删除的文件或目录\ :ref:`;-list <CMake Language Lists>`。\
它对于指定由多个目标或CMake本身使用的生成文件或目录，或者以无法作为自定义命令的输出或副产品\
捕获的方式生成的文件或目录非常有用。

If an additional clean file is specific to a single target only, then the
:prop_tgt:`ADDITIONAL_CLEAN_FILES` target property would usually be a better
choice than this directory property.

Relative paths are allowed and are interpreted relative to the
current binary directory.

Contents of ``ADDITIONAL_CLEAN_FILES`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.

This property only works for the :generator:`Ninja` and the Makefile
generators.  It is ignored by other generators.
