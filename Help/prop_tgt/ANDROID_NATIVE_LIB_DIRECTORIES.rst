ANDROID_NATIVE_LIB_DIRECTORIES
------------------------------

.. versionadded:: 3.4

设置Android属性，指定要搜索\ ``.so``\ 库的目录。

This a string property that contains the directory paths separated
by semicolons.

This property is initialized by the value of the
:variable:`CMAKE_ANDROID_NATIVE_LIB_DIRECTORIES` variable if it is set when a
target is created.

Contents of ``ANDROID_NATIVE_LIB_DIRECTORIES`` may use "generator expressions"
with the syntax ``$<...>``.  See the :manual:`cmake-generator-expressions(7)`
manual for available expressions.
