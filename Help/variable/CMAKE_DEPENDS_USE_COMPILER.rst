CMAKE_DEPENDS_USE_COMPILER
--------------------------

.. versionadded:: 3.20

对于\ :ref:`Makefile Generators`，对于选择的编译器，源依赖项现在由编译器本身生成。\
通过将这个变量定义为\ ``FALSE``，你可以恢复遗留行为（即使用CMake进行依赖项发现）。
