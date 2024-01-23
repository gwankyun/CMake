CMAKE_NINJA_OUTPUT_PATH_PREFIX
------------------------------

.. versionadded:: 3.6

告诉\ :ref:`Ninja Generators`\ 在\ ``build.ninja``\ 中的每个输出路径中添加一个前缀。\
如果没有，则在前缀后面添加一个斜杠。

This is useful when the generated ninja file is meant to be embedded as a
``subninja`` file into a *super* ninja project.  For example, the command:

.. code-block:: shell

  cd super-build-dir &&
  cmake -G Ninja -S /path/to/src -B sub -DCMAKE_NINJA_OUTPUT_PATH_PREFIX=sub/
  #                                 ^^^---------- these match -----------^^^

generates a build directory with its top-level (:variable:`CMAKE_BINARY_DIR`)
in ``super-build-dir/sub``.  The path to the build directory ends in the
output path prefix.  This makes it suitable for use in a separately-written
``super-build-dir/build.ninja`` file with a directive like this::

  subninja sub/build.ninja

The ``auto-regeneration`` rule in ``super-build-dir/build.ninja`` must
have an order-only dependency on ``sub/build.ninja``.

.. versionadded:: 3.27

  The :generator:`Ninja Multi-Config` generator supports this variable.

.. note::
  When ``CMAKE_NINJA_OUTPUT_PATH_PREFIX`` is set, the project generated
  by CMake cannot be used as a standalone project.  No default targets
  are specified.

  The value of ``CMAKE_NINJA_OUTPUT_PATH_PREFIX`` must match one or more
  path components at the *end* of :variable:`CMAKE_BINARY_DIR`, or the
  behavior is undefined.  However, this requirement is not checked
  automatically.
