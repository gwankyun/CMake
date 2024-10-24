FIXTURES_SETUP
--------------

.. versionadded:: 3.7

指定要将测试作为安装测试处理的fixture列表。这些fixture名称与测试用例名称不同，并且不需要与\
其关联的测试名称有任何相似之处。

Fixture setup tests are ordinary tests with all of the usual test
functionality. Setting the ``FIXTURES_SETUP`` property for a test has two
primary effects:

- CTest will ensure the test executes before any other test which lists the
  fixture name(s) in its :prop_test:`FIXTURES_REQUIRED` property.

- If CTest is asked to run only a subset of tests (e.g. using regular
  expressions or the ``--rerun-failed`` option) and the setup test is not in
  the set of tests to run, it will automatically be added if any tests in the
  set require any fixture listed in ``FIXTURES_SETUP``.

A setup test can have multiple fixtures listed in its ``FIXTURES_SETUP``
property. It will execute only once for the whole CTest run, not once for each
fixture. A fixture can also have more than one setup test defined. If there are
multiple setup tests for a fixture, projects can control their order with the
usual :prop_test:`DEPENDS` test property if necessary.

A setup test is allowed to require other fixtures, but not any fixture listed
in its ``FIXTURES_SETUP`` property. For example:

.. code-block:: cmake

  # Ok: dependent fixture is different to setup
  set_tests_properties(setupFoo PROPERTIES
    FIXTURES_SETUP    Foo
    FIXTURES_REQUIRED Bar
  )

  # Error: cannot require same fixture as setup
  set_tests_properties(setupFoo PROPERTIES
    FIXTURES_SETUP    Foo
    FIXTURES_REQUIRED Foo
  )

If any of a fixture's setup tests fail, none of the tests listing that fixture
in its :prop_test:`FIXTURES_REQUIRED` property will be run. Cleanup tests will,
however, still be executed.

See :prop_test:`FIXTURES_REQUIRED` for a more complete discussion of how to use
test fixtures.
