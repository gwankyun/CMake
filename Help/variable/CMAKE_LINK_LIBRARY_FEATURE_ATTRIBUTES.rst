CMAKE_LINK_LIBRARY_<FEATURE>_ATTRIBUTES
---------------------------------------

.. versionadded:: 3.30

这个变量定义了指定的链接库\ ``<FEATURE>``\ 的行为。它指定了\ ``<FEATURE>``\ 如何与其他\
功能交互，何时应该应用\ ``<FEATURE>``，以及当CMake组装最终链接器命令行时如何处理\
``<FEATURE>``\ 的方面（例如，去重）。

The syntax of the linker flags for the ``<FEATURE>`` are controlled by the
:variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>` and
:variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>` variables.
The :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED` and
:variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED` variables
control whether the ``<FEATURE>`` is available at all.

When linking for a particular language ``<LANG>``,
``CMAKE_LINK_LIBRARY_<FEATURE>_ATTRIBUTES`` is ignored if the
:variable:`CMAKE_<LANG>_LINK_LIBRARY_<FEATURE>_ATTRIBUTES` variable is also
defined for the same ``<FEATURE>``.

The value of ``CMAKE_LINK_LIBRARY_<FEATURE>_ATTRIBUTES`` and
:variable:`CMAKE_<LANG>_LINK_LIBRARY_<FEATURE>_ATTRIBUTES` at the end of the
directory scope in which a target is defined is what matters.

Feature Attributes Definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A feature attributes definition is a
:ref:`semicolon-separated list <CMake Language Lists>` of
``attribute=value(s)`` items. If an attribute has multiple values, those values
must be comma-separated.

The following attributes are supported:

``LIBRARY_TYPE=<library-type-list>``
  Specify the library types supported by the feature. Supported values are:
  ``STATIC``, ``SHARED``, ``MODULE``, and ``EXECUTABLE``.

  If this attribute is not specified, the default is
  ``LIBRARY_TYPE=STATIC,SHARED,MODULE,EXECUTABLE``.

  If the feature is used with an unsupported library type, CMake will emit a
  developer warning and the feature will be ignored.

``OVERRIDE=<feature-list>``
  Specify which features this one replaces in the event of a conflict.
  This override mechanism is superseded by
  :prop_tgt:`LINK_LIBRARY_OVERRIDE` or
  :prop_tgt:`LINK_LIBRARY_OVERRIDE_<LIBRARY>` target property definitions,
  if defined.

  If this attribute is not specified, the default is an empty list.

``DEDUPLICATION=YES|NO|DEFAULT``
  Specify the de-duplication strategy for a library using this feature.

  ``YES``
    The library is always de-duplicated. The default strategy CMake would
    normally apply is ignored.

  ``NO``
    The library is never de-duplicated. The default strategy CMake would
    normally apply is ignored.

  ``DEFAULT``
    Let CMake determine a de-duplication strategy automatically.

  If this attribute is not specified, ``DEFAULT`` will be used.

Example
^^^^^^^

A common need is the loading of a full archive as part of the creation of a
shared library. The built-in ``WHOLE_ARCHIVE`` feature can be used for that
purpose. The implementation of that built-in feature sets the following
link library feature attributes:

.. code-block:: cmake

  set(CMAKE_LINK_LIBRARY_WHOLE_ARCHIVE_ATTRIBUTES
    LIBRARY_TYPE=STATIC
    OVERRIDE=DEFAULT
    DEDUPLICATION=YES
  )

``LIBRARY_TYPE=STATIC``
  This feature is only meaningful for static libraries.
``OVERRIDE=DEFAULT``
  The ``DEFAULT`` feature will be overridden by the ``WHOLE_ARCHIVE`` feature
  because they are compatible and enhance the user's experience: standard
  library specification and ``$<LINK_LIBRARY:WHOLE_ARCHIVE>`` can be used
  freely.
``DEDUPLICATION=YES``
  When this feature is used, the linker loads all symbols from the static
  library, so there is no need to repeat the library on the linker
  command line.

The ``WHOLE_ARCHIVE`` feature can be used like so:

.. code-block:: cmake

  add_library(A STATIC ...)
  add_library(B STATIC ...)

  target_link_libraries(B PUBLIC A)
  target_link_libraries(A PUBLIC B)

  add_library(global SHARED ...)
  target_link_libraries(global PRIVATE $<LINK_LIBRARY:WHOLE_ARCHIVE,A>)

The resulting link command will only have one instance of the ``A`` library
specified, and the linker flags will ensure that all symbols are loaded from
the ``A`` library.
