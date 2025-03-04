CMAKE_POLICY_VERSION_MINIMUM
----------------------------

.. versionadded:: 4.0

为项目指定一个最小的\ :ref:`Policy Version`，而无需修改其对\
:command:`cmake_minimum_required(VERSION)`\ 和\ :command:`cmake_policy(VERSION)`\
的调用。

This variable should not be set by a project in CMake code as a way to
set its own policy version.  Use :command:`cmake_minimum_required(VERSION)`
and/or :command:`cmake_policy(VERSION)` for that.  This variable is meant
to externally set policies for which a project has not itself been updated:

* Users running CMake may set this variable in the cache, e.g.,
  ``-DCMAKE_POLICY_VERSION_MINIMUM=3.5``, to try configuring a project
  that has not been updated to set at least that policy version itself.

  Alternatively, users may set the :envvar:`CMAKE_POLICY_VERSION_MINIMUM`
  environment variable to initialize the cache entry in new build trees
  automatically.

* Projects may set this variable before a call to :command:`add_subdirectory`
  that adds a third-party project in order to set its policy version without
  modifying third-party code.

See :variable:`CMAKE_POLICY_DEFAULT_CMP<NNNN>` to set individual policies.
