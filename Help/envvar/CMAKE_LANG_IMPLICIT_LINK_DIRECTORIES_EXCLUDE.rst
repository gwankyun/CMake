CMAKE_<LANG>_IMPLICIT_LINK_DIRECTORIES_EXCLUDE
----------------------------------------------

.. versionadded:: 3.27

.. include:: ENV_VAR.txt

表现为一个\ :ref:`分号分隔的列表 <CMake Language Lists>`\ 的目录，当\ ``<LANG>``\ 编\
译器自动检测到\ :variable:`CMAKE_<LANG>_IMPLICIT_LINK_DIRECTORIES`\ 变量时，它将从该\
变量中排除。

This may be used to work around misconfigured compiler drivers that pass
extraneous implicit link directories to their linker.
