ctest_read_custom_files
-----------------------

读取CTestCustom文件。

.. code-block:: cmake

  ctest_read_custom_files(<directory>...)

Read all the CTestCustom.ctest or CTestCustom.cmake files from the
given directory.

By default, invoking :manual:`ctest(1)` without a script will read custom
files from the binary directory.
