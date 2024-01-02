CMAKE_SUBLIME_TEXT_2_EXCLUDE_BUILD_TREE
---------------------------------------

.. versionadded:: 3.8

如果这个变量在顶级的\ ``CMakeLists.txt``\ 文件的末尾计算为\ ``ON``，那么\
:generator:`Sublime Text 2`\ 额外的生成器将从\ ``.sublime-project``\ 中排除构建树，\
如果它在源代码树中。
