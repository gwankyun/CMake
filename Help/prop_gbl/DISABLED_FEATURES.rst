DISABLED_FEATURES
-----------------

在CMake运行期间禁用的功能列表。

List of features which are disabled during the CMake run.  By default
it contains the names of all packages which were not found.  This is
determined using the ``<NAME>_FOUND`` variables.  Packages which are
searched ``QUIET`` are not listed.  A project can add its own features to
this list.  This property is used by the macros in
``FeatureSummary.cmake``.
