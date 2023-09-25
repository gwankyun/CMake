USE_FOLDERS
-----------

控制是否使用\ :prop_tgt:`FOLDER`\ 目标属性将目标组织到文件夹中。在顶层\ ``CMakeLists.txt``\
文件末尾的\ ``USE_FOLDERS``\ 的值决定了行为。

.. versionchanged:: 3.26

  CMake treats this property as ``ON`` by default.
  See policy :policy:`CMP0143`.

Not all CMake generators support recording folder details for targets.
The :generator:`Xcode` and :ref:`Visual Studio <Visual Studio Generators>`
generators are examples of generators that do.  Similarly, not all IDEs
support presenting targets using folder hierarchies, even if the CMake
generator used provides the necessary information.
