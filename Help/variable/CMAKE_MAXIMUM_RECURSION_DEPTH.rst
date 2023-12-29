CMAKE_MAXIMUM_RECURSION_DEPTH
-----------------------------

.. versionadded:: 3.14

CMake脚本的最大递归深度。它旨在通过\ ``-DCMAKE_MAXIMUM_RECURSION_DEPTH=<x>``\ 在命令\
行上设置，或者在需要大递归深度的项目的\ ``CMakeLists.txt``\ 中设置。设置此变量的项目应该\
为用户提供覆盖该变量的方法。例如：

.. code-block:: cmake

  # About to perform deeply recursive actions
  if(NOT CMAKE_MAXIMUM_RECURSION_DEPTH)
    set(CMAKE_MAXIMUM_RECURSION_DEPTH 2000)
  endif()

If it is not set, or is set to a non-integer value, a sensible default limit is
used. If the recursion limit is reached, the script terminates immediately with
a fatal error.

Calling any of the following commands increases the recursion depth:

* :command:`include`
* :command:`find_package`
* :command:`add_subdirectory`
* :command:`try_compile`
* :command:`ctest_read_custom_files`
* :command:`ctest_run_script` (unless ``NEW_PROCESS`` is specified)
* User-defined :command:`function`'s and :command:`macro`'s (note that
  :command:`function` and :command:`macro` themselves don't increase recursion
  depth)
* Reading or writing variables that are being watched by a
  :command:`variable_watch`

See also the :envvar:`CMAKE_MAXIMUM_RECURSION_DEPTH` environment variable.
