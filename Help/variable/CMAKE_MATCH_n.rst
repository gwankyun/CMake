CMAKE_MATCH_<n>
---------------

.. versionadded:: 3.9

捕获与最后一个正则表达式匹配的组\ ``<n>``，对于组0到9。0组是整个匹配。第1到第9组是\ ``()``\
语法捕获的子表达式。

When a regular expression match is used, CMake fills in ``CMAKE_MATCH_<n>``
variables with the match contents.  The :variable:`CMAKE_MATCH_COUNT`
variable holds the number of match expressions when these are filled.
