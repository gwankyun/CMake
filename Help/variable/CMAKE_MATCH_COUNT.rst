CMAKE_MATCH_COUNT
-----------------

.. versionadded:: 3.2

与最后一个正则表达式匹配的数目。

When a regular expression match is used, CMake fills in
:variable:`CMAKE_MATCH_<n>` variables with the match contents.
The ``CMAKE_MATCH_COUNT`` variable holds the number of match
expressions when these are filled.
