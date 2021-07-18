步骤12：打包调试和发布
====================================

**注意**：这个例子只适用于单配置生成器，而不适用于多配置生成器（例如Visual Studio）。

默认情况下，CMake的模型是一个构建目录只包含一个配置，可以是Debug、Release、MinSizeRel或RelWithDebInfo。但是，可以通过安装CPack来捆绑多个构建目录，并构建一个包含同一项目的多个配置的包。

首先，我们希望确保调试版本和发布版本对将要安装的可执行文件和库使用不同的名称。让我们使用 `d` 作为调试可执行文件和库的后缀。

在顶层 ``CMakeLists.txt`` 文件的开头设置 :variable:`CMAKE_DEBUG_POSTFIX`：

.. literalinclude:: Complete/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-CMAKE_DEBUG_POSTFIX-variable
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: target_compile_features(tutorial_compiler_flags

还有tutorial可执行文件的 :prop_tgt:`DEBUG_POSTFIX` 属性：

.. literalinclude:: Complete/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-DEBUG_POSTFIX-property
  :language: cmake
  :start-after: # add the executable
  :end-before: # add the binary tree to the search path for include files

让我们再向 ``MathFunctions`` 库添加版本号。在 ``MathFunctions/CMakeLists.txt`` 设置  :prop_tgt:`VERSION` 和 :prop_tgt:`SOVERSION` 属性：

.. literalinclude:: Complete/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-VERSION-properties
  :language: cmake
  :start-after: # setup the version numbering
  :end-before: # install rules

在 ``Step12`` 目录中，创建 ``debug`` 和 ``release`` 子目录。布局将看起来像：

.. code-block:: none

  - Step12
     - debug
     - release

现在我们需要设置调试和发布构建。我们可以使用 :variable:`CMAKE_BUILD_TYPE` 来设置配置类型：

.. code-block:: console

  cd debug
  cmake -DCMAKE_BUILD_TYPE=Debug ..
  cmake --build .
  cd ../release
  cmake -DCMAKE_BUILD_TYPE=Release ..
  cmake --build .

现在调试版本和发布版本都已经完成了，我们可以使用一个定制的配置文件将这两个版本打包到一个版本中。在 ``Step12`` 目录中，创建一个名为 ``MultiCPackConfig.cmake`` 的文件。在这个文件中，首先包含 :manual:`cmake  <cmake(1)>` 可执行文件创建的默认配置文件。

接下来，使用 ``CPACK_INSTALL_CMAKE_PROJECTS`` 变量来指定要安装哪些项目。在这种情况下，我们希望同时安装调试和发布。

.. literalinclude:: Complete/MultiCPackConfig.cmake
  :caption: MultiCPackConfig.cmake
  :name: MultiCPackConfig.cmake
  :language: cmake

在 ``Step12`` 目录下，运行 :manual:`cpack <cpack(1)>` ，指定我们的配置文件  ``config`` 选项：

.. code-block:: console

  cpack --config MultiCPackConfig.cmake
