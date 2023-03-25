中文翻译说明
************

依赖
=====

* `CMake`_
* `Python`_
* Python的\ `Sphinx`_\ 包

.. _`CMake`: https://cmake.org/download/
.. _`Python`: https://www.python.org/downloads/
.. _`Sphinx`: https://pypi.org/project/Sphinx/

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

* `cmake(1) <Help/manual/ctest.1.rst>`_\ ：部分
* `cpack(1) <Help/manual/cpack.1.rst>`_\ ：部分

交互式对话框
------------

* `ccmake(1) <Help/manual/ccmake.1.rst>`_\ ：部分

参考手册
--------

* `cmake-buildsystem(7) <Help/manual/cmake-buildsystem.7.rst>`_\ ：完成
* `cmake-commands(7) <Help/manual/cmake-commands.7.rst>`_\ ：完成，不包括子页面
* `cmake-compile-features(7) <Help/manual/cmake-compile-features.7.rst>`_\ ：完成
* `cmake-env-variables(7) <Help/manual/cmake-env-variables.7.rst>`_\ ：完成，不包括子页面
* `cmake-generators(7) <Help/manual/cmake-generators.7.rst>`_\ ：完成，不包括子页面
* `cmake-language(7) <Help/manual/cmake-language.7.rst>`_\ ：完成
* `cmake-modules(7) <Help/manual/cmake-modules.7.rst>`_\ ：完成，不包括子页面
* `cmake-packages(7) <Help/manual/cmake-packages.7.rst>`_\ ：完成，不包括子页面
* `cmake-properties(7) <Help/manual/cmake-properties.7.rst>`_\ ：完成，不包括子页面
* `cmake-server(7) <Help/manual/cmake-server.7.rst>`_\ ：完成
* `cpack-variables(7) <Help/manual/cpack-variables.7.rst>`_\ ：完成，不包括子页面
* `cpack-generators(7) <Help/manual/cpack-generators.7.rst>`_\ ：完成，不包括子页面
* `cmake-generator-expressions(7) <Help/manual/cmake-generator-expressions.7.rst>`_\ ：部分
* `cmake-gui(1) <Help/manual/cmake-gui.1.rst>`_\ ：完成
* `ccmake(1) <Help/manual/ccmake.1.rst>`_\ ：完成

指南
-----

* `CMake教程 <Help/guide/tutorial/index.rst>`_\ ：完成
* `用户交互指南 <Help/guide/user-interaction/index.rst>`_\ ：完成
* `使用依赖项指南 <Help/guide/using-dependencies/index.rst>`_\ ：完成
* `导入导出指南 <Help/guide/importing-exporting/index.rst>`_\ ：完成
* `IDE集成指南 <Help/guide/ide-integration/index.rst>`_\ ：完成
