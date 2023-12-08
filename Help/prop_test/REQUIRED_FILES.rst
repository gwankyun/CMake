REQUIRED_FILES
--------------

运行测试所需的文件列表。除非指定了绝对路径，否则文件名是相对于测试\
:prop_test:`WORKING_DIRECTORY`\ 的。

If set to a list of files, the test will not be run unless all of the
files exist.

Examples
~~~~~~~~

Suppose that ``test.txt`` is created by test ``baseTest`` and ``none.txt``
does not exist:

.. code-block:: cmake

  add_test(NAME baseTest ...)   # Assumed to create test.txt
  add_test(NAME fileTest ...)

  # The following ensures that if baseTest is successful, test.txt will
  # have been created before fileTest is run
  set_tests_properties(fileTest PROPERTIES
    DEPENDS baseTest
    REQUIRED_FILES test.txt
  )

  add_test(NAME notRunTest ...)

  # The following makes notRunTest depend on two files. Nothing creates
  # the none.txt file, so notRunTest will fail with status "Not Run".
  set_tests_properties(notRunTest PROPERTIES
    REQUIRED_FILES "test.txt;none.txt"
  )

The above example demonstrates how ``REQUIRED_FILES`` works, but it is not the
most robust way to implement test ordering with failure detection.  For that,
test fixtures are a better alternative (see :prop_test:`FIXTURES_REQUIRED`).
