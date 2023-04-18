ctest_empty_binary_directory
----------------------------

清空二进制目录

.. code-block:: cmake

  ctest_empty_binary_directory(<directory>)

Removes a binary directory.  This command will perform some checks
prior to deleting the directory in an attempt to avoid malicious or
accidental directory deletion.
