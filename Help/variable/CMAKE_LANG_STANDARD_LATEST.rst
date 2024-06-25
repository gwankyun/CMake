CMAKE_<LANG>_STANDARD_LATEST
-----------------------------

.. versionadded:: 3.30

该变量表示当前编译器支持的语言\ ``<LANG>``\ 标准的最新版本与CMake支持的最新版本之间的最小值。\
它的值将设置为对应的\ :prop_tgt:`<LANG>_STANDARD`\ 目标属性支持的值之一；有关支持的语言\
列表，请参阅该属性的文档。

See the :manual:`cmake-compile-features(7)` manual for information on compile
features and a list of supported compilers.

.. note::

  ``CMAKE_<LANG>_STANDARD_LATEST`` will never be set to a language standard
  which CMake recognizes but provides no support for. Unless explicitly
  stated otherwise, every value which is supported by the corresponding
  :prop_tgt:`<LANG>_STANDARD` target property represents a standard of
  language ``<LANG>`` which is both recognized and supported by CMake.

Checking for Language Standard Support
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It is possible to use the value of the ``CMAKE_<LANG>_STANDARD_LATEST``
variable to check for language standard support. This can be used to, e.g.,
conditionally enable optional features for a distributed library.

When doing so, one should be careful to **not** rely on integer value
comparisons between standard levels. This is because some older standards of
a given language which are supported by CMake (e.g., C++98, represented as
``98``) will have a higher numerical value than newer standards of that same
language.

The following code sample demonstrates how one might correctly check for
C++17 support:

.. code-block:: cmake

  # Careful! We cannot do direct integer comparisons with
  # CMAKE_CXX_STANDARD_LATEST because some earlier C++ standards (e.g.,
  # C++98) will have a higher numerical value than our requirement (C++17).
  #
  # Instead, we keep a list of unsupported C++ standards and check if
  # CMAKE_CXX_STANDARD_LATEST appears in that list.
  set(UNSUPPORTED_CXX_STANDARDS
    98
    11
    14
  )

  list(FIND UNSUPPORTED_CXX_STANDARDS ${CMAKE_CXX_STANDARD_LATEST} UNSUPPORTED_CXX_STANDARDS_INDEX)

  if(UNSUPPORTED_CXX_STANDARDS_INDEX EQUAL -1)
    # We know that the current compiler supports at least C++17. Enabling
    # some optional feature...
  else()
    message(STATUS
      "Feature X is disabled because it requires C++17, but the current "
      "compiler only supports C++${CMAKE_CXX_STANDARD_LATEST}."
    )
  endif()
