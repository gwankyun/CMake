CMAKE_<LANG>_CREATE_SHARED_LIBRARY_ARCHIVE
------------------------------------------

.. versionadded:: 3.31

规则变量来创建具有存档的共享库。

This is a rule variable that tells CMake how to create a shared
library with an archive for the language <LANG>.  This rule variable
is a ; delimited list of commands to run to perform the linking step.
