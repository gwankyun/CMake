CMAKE_CLANG_VFS_OVERLAY
-----------------------

.. versionadded:: 3.19

当使用clang-cl对windows进行交叉编译时，该变量可以是指向clang虚拟文件系统yaml文件的绝对路径，\
这将使clang-cl能够在区分大小写的文件系统上解析windows头文件名称。
