CMAKE_CXX_COMPILER_IMPORT_STD
-----------------------------

.. versionadded:: 3.30

当前C++工具链中支持\ ``import std``\ 的C++标准级别列表。可以使用\ :command:`if`\ 命令的\
``<NN> IN_LIST CMAKE_CXX_COMPILER_IMPORT_STD``\ 谓词来检测对C++\<NN\>的支持。

.. note ::

   This variable is meaningful only when experimental support for ``import
   std;`` has been enabled by the ``CMAKE_EXPERIMENTAL_CXX_IMPORT_STD`` gate.
