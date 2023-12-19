CMAKE_FIND_PACKAGE_REDIRECTS_DIR
--------------------------------

.. versionadded:: 3.24

这个只读变量指定了一个目录，\ :command:`find_package`\ 命令在其他地方搜索模块或配置包文\
件之前首先检查这个目录。这个目录中的配置包文件总是优先于任何其他查找模块文件或配置包文件。

The primary purpose of this variable is to facilitate integration between
:command:`find_package` and :command:`FetchContent_MakeAvailable`.  The latter
command may create files in the ``CMAKE_FIND_PACKAGE_REDIRECTS_DIR`` directory
when it populates a dependency.  This allows subsequent calls to
:command:`find_package` for the same dependency to reuse the populated
contents instead of trying to satisfy the dependency from somewhere external
to the build.  Projects may also want to write files into this directory in
some situations (see :ref:`FetchContent-find_package-integration-examples`
for examples).

The directory that ``CMAKE_FIND_PACKAGE_REDIRECTS_DIR`` points to will always
be erased and recreated empty at the start of every CMake run.  Any files
written into this directory during the CMake run will be lost the next time
CMake configures the project.

``CMAKE_FIND_PACKAGE_REDIRECTS_DIR`` is only set in CMake project mode.
It is not set when CMake is run in script mode
(i.e. :option:`cmake -P`).
