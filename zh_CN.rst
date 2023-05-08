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
