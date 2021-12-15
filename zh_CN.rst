中文翻译说明
************

依赖
=====

* CMake
* Python
* Python的Sphinx包

生成工程
========

  .. code-block:: console

    $ mkdir ../build/CMake
    $ cmake -S . -B ../build/CMake -DSPHINX_HTML=ON

编译文档
========

  .. code-block:: console

    $ cmake --build ../build/CMake --target documentation --config Debug

输出路径
========

  ``../build/CMake/Utilities/Sphinx/html``

翻译进度
========

命令行工具
----------

* :manual:`cmake(1)`：部分

交互式对话框
------------

* :manual:`ccmake(1)`：部分

参考手册
--------

* :manual:`cmake-commands(7)`：完成，不包括子页面
* :manual:`cmake-compile-features(7)`：完成
* :manual:`cmake-env-variables(7)`：完成，不包括子页面
* :manual:`cmake-generators(7)`：完成，不包括子页面
* :manual:`cmake-language(7)`：完成
* :manual:`cmake-modules(7)`：完成，不包括子页面
* :manual:`cmake-packages(7)`：完成，不包括子页面
* :manual:`cmake-properties(7)`：完成，不包括子页面
* :manual:`cmake-server(7)`：完成
* :manual:`cmake-variables(7)`：完成，不包括子页面
* :manual:`cpack-generators(7)`：完成，不包括子页面

指南
-----

* `CMake教程 <Help/guide/tutorial/index.rst>`_ ：完成
* :guide:`用户交互指南`：完成
* :guide:`使用依赖项指南`：完成
* :guide:`导入导出指南`：完成
* :guide:`IDE集成指南`：完成
