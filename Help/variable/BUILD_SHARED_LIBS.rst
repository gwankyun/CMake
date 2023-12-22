BUILD_SHARED_LIBS
-----------------

如果开启，导致\ :command:`add_library`\ 创建共享库的全局标志。

If present and true, this will cause all libraries to be built shared
unless the library was explicitly added as a static library.  This
variable is often added to projects as an :command:`option` so that each user
of a project can decide if they want to build the project using shared or
static libraries.
