WRAP_EXCLUDE
------------

将此源文件排除在任何代码包装技术之外。

Some packages can wrap source files into alternate languages to
provide additional functionality.

For example, C++ code can be wrapped into Java or Python, using SWIG.
If ``WRAP_EXCLUDE`` is set to ``True``, that indicates that this
source file should not be wrapped.
