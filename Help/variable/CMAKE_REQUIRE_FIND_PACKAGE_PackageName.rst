CMAKE_REQUIRE_FIND_PACKAGE_<PackageName>
----------------------------------------

.. versionadded:: 3.22

进行\ :command:`find_package`\ 调用的变量\ ``REQUIRED``。

Every non-``REQUIRED`` :command:`find_package` call in a project can be
turned into ``REQUIRED`` by setting the variable
``CMAKE_REQUIRE_FIND_PACKAGE_<PackageName>`` to ``TRUE``.
This can be used to assert assumptions about build environment and to
ensure the build will fail early if they do not hold.

See also the :variable:`CMAKE_DISABLE_FIND_PACKAGE_<PackageName>` variable.
