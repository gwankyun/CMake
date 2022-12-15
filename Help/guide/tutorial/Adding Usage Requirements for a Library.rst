步骤3：添加库的使用需求
===============================================

练习1 - 为库添加使用需求
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

目标参数的\ :ref:`Usage requirements <Target Usage Requirements>`\ 允许对库或可执行文件的link和include行进行更好的控制，\
同时也可以对CMake内部目标的传递属性进行更多的控制。利用使用需求的主要命令有：

* :command:`target_compile_definitions`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`


目标
----

为库添加使用需求。

有用的材料
-----------------

* :variable:`CMAKE_CURRENT_SOURCE_DIR`

待编辑的文件
-------------

* ``MathFunctions/CMakeLists.txt``
* ``CMakeLists.txt``

开始
---------------

在本练习中，我们将使用现代的CMake方法重构\ :guide:`tutorial/Adding a Library`\ 中的代码。\
我们将让我们的库定义自己的使用需求，以便在必要时将它们传递给其他目标。\
在本例中，\ ``MathFunctions``\ 将自己指定任何所需的include目录。\
然后，消费目标\ ``Tutorial``\ 只需要链接到\ ``MathFunctions``，而不用担心任何额外的包含目录。

在\ ``Step3``\ 目录中提供了起始源代码。在这个练习中，完成\ ``TODO 1``\ 到\ ``TODO 3``。

首先，在\ ``MathFunctions/CMakeLists``\ 中添加对\ :command:`target_include_directories`\ 的调用。\
请记住，:variable:`CMAKE_CURRENT_SOURCE_DIR`\ 是当前正在处理的源目录的路径。

然后，更新（并简化！）顶层\ ``CMakeLists.txt``\ 中对\ :command:`target_include_directories`\ 的调用。

构建并运行
-------------

Make a new directory called ``Step3_build``, run the :manual:`cmake
<cmake(1)>` executable or the :manual:`cmake-gui <cmake-gui(1)>` to
configure the project and then build it with your chosen build tool or by
using :option:`cmake --build . <cmake --build>` from the build directory.
Here's a refresher of what that looks like from the command line:

.. code-block:: console

  mkdir Step3_build
  cd Step3_build
  cmake ../Step3
  cmake --build .

Next, use the newly built ``Tutorial`` and verify that it is working as
expected.

解决方案
--------

Let's update the code from the previous step to use the modern CMake
approach of usage requirements.

We want to state that anybody linking to ``MathFunctions`` needs to include
the current source directory, while ``MathFunctions`` itself doesn't. This
can be expressed with an ``INTERFACE`` usage requirement. Remember
``INTERFACE`` means things that consumers require but the producer doesn't.

At the end of ``MathFunctions/CMakeLists.txt``, use
:command:`target_include_directories` with the ``INTERFACE`` keyword, as
follows:

.. raw:: html

  <details><summary>TODO 1: Click to show/hide answer</summary>

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :caption: TODO 1: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_include_directories-INTERFACE
  :language: cmake
  :start-after: # 以便查找MathFunctions.h
  :end-before: # TODO 3: Link to

.. raw:: html

  </details>

Now that we've specified usage requirements for ``MathFunctions`` we can
safely remove our uses of the ``EXTRA_INCLUDES`` variable from the top-level
``CMakeLists.txt``, here:

.. raw:: html

  <details><summary>TODO 2: Click to show/hide answer</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: # 添加MathFunctions库
  :end-before: # 添加可执行文件

.. raw:: html

  </details>

And here:

.. raw:: html

  <details><summary>TODO 3: Click to show/hide answer</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: # 以便找到TutorialConfig.h

.. raw:: html

  </details>

Notice that with this technique, the only thing our executable target does to
use our library is call :command:`target_link_libraries` with the name
of the library target. In larger projects, the classic method of specifying
library dependencies manually becomes very complicated very quickly.
