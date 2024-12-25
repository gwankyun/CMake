include
-------

从文件或者模块中加载并执行CMake代码。

.. code-block:: cmake

  include(<file|module> [OPTIONAL] [RESULT_VARIABLE <var>]
                        [NO_POLICY_SCOPE])

加载并运行给定文件中的CMake代码。变量读写访问调用者的作用域（动态作用域）。如果\ ``OPTIONAL``\
存在，那么如果文件不存在，则不会引发错误。如果给定了\ ``RESULT_VARIABLE``，变量\ ``<var>``\
将被设置为已包含的完整文件名，如果失败则为\ ``NOTFOUND``。

如果指定的是模块而不是文件，则首先在\ :variable:`CMAKE_MODULE_PATH`\ 中搜索名为\
``<modulename>.cmake``\ 的文件，然后在CMake模块目录中搜索。有一个例外：如果调用\
``include()``\ 的文件本身位于CMake内置模块目录中，那么首先搜索CMake内置模块目录，然后搜索\
:variable:`CMAKE_MODULE_PATH`。另见策略\ :policy:`CMP0017`。

有关\ ``NO_POLICY_SCOPE``\ 选项的讨论，请参阅\ :command:`cmake_policy`\ 命令文档。
