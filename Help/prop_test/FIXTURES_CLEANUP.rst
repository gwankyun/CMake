FIXTURES_CLEANUP
----------------

.. versionadded:: 3.7

指定要将测试作为清理测试处理的fixture列表。这些fixture名称与测试用例名称不同，并且不需要与\
其关联的测试名称有任何相似之处。

Fixture cleanup tests are ordinary tests with all of the usual test
functionality. Setting the ``FIXTURES_CLEANUP`` property for a test has two
primary effects:

- CTest will ensure the test executes after all other tests which list any of
  the fixtures in its :prop_test:`FIXTURES_REQUIRED` property.

- If CTest is asked to run only a subset of tests (e.g. using regular
  expressions or the ``--rerun-failed`` option) and the cleanup test is not in
  the set of tests to run, it will automatically be added if any tests in the
  set require any fixture listed in ``FIXTURES_CLEANUP``.

A cleanup test can have multiple fixtures listed in its ``FIXTURES_CLEANUP``
property. It will execute only once for the whole CTest run, not once for each
fixture. A fixture can also have more than one cleanup test defined. If there
are multiple cleanup tests for a fixture, projects can control their order with
the usual :prop_test:`DEPENDS` test property if necessary.

A cleanup test is allowed to require other fixtures, but not any fixture listed
in its ``FIXTURES_CLEANUP`` property. For example:

.. code-block:: cmake

  # Ok: Dependent fixture is different to cleanup
  set_tests_properties(cleanupFoo PROPERTIES
    FIXTURES_CLEANUP  Foo
    FIXTURES_REQUIRED Bar
  )

  # Error: cannot require same fixture as cleanup
  set_tests_properties(cleanupFoo PROPERTIES
    FIXTURES_CLEANUP  Foo
    FIXTURES_REQUIRED Foo
  )

Cleanup tests will execute even if setup or regular tests for that fixture fail
or are skipped.

See :prop_test:`FIXTURES_REQUIRED` for a more complete discussion of how to use
test fixtures.
