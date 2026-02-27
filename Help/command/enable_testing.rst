enable_testing
--------------

启用当前及以下目录的测试。

.. code-block:: cmake

  enable_testing()

This command should be invoked in the top-level source directory because
:manual:`ctest(1)` expects to find a test file in the top-level
build directory.

当包含\ :module:`CTest`\ 模块时，将同样自动调用此命令，除非关闭\ :variable:`BUILD_TESTING`\ 选项。

The following restrictions apply to where ``enable_testing()`` may be called:

* It must be called in file scope, not in a :command:`function` call nor inside
  a :command:`block`.

Examples
^^^^^^^^

In the following example, this command is conditionally called depending on how
the project is used.  For instance, when the Example project is added via the
:module:`FetchContent` module as a subdirectory of a parent project that defines
its own tests, testing for the Example project is disabled.

.. code-block:: cmake
  :caption: ``CMakeLists.txt``

  project(Example)

  option(Example_ENABLE_TESTING "Enable testing" ${PROJECT_IS_TOP_LEVEL})

  if(Example_ENABLE_TESTING)
    enable_testing()
  endif()

  # ...

  if(Example_ENABLE_TESTING)
    add_test(...)
  endif()

See Also
^^^^^^^^

* The :command:`add_test` command.
