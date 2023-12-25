CMAKE_DEPENDS_IN_PROJECT_ONLY
-----------------------------

.. versionadded:: 3.6

当在目录中设置为\ ``TRUE``\ 时，由\ :ref:`Makefile Generators`\ 生成的构建系统将被设\
置为仅考虑对出现在源文件或二进制目录中的源文件的依赖。对这些目录之外的源文件的更改不会导致重\
新构建。

This should be used carefully in cases where some source files are picked up
through external headers during the build.
