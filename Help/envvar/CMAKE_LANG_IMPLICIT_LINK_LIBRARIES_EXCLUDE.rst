CMAKE_<LANG>_IMPLICIT_LINK_LIBRARIES_EXCLUDE
--------------------------------------------

.. versionadded:: 4.1

.. include:: include/ENV_VAR.rst

一个\ :ref:`以分号分隔的列表 <CMake Language Lists>`，用于在从\ ``<LANG>``\ 编译器\
自动检测\ :variable:`CMAKE_<LANG>_IMPLICIT_LINK_LIBRARIES`\ 变量时，排除其中的库。

This may be used to work around detection limitations that result in
extraneous implicit link libraries, e.g., when using compiler driver
flags that affect the set of implicitly linked libraries.

See also the :envvar:`CMAKE_<LANG>_IMPLICIT_LINK_DIRECTORIES_EXCLUDE`
environment variable.
