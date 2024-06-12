target_sources
--------------

.. versionadded:: 3.1

向目标添加源文件。

.. code-block:: cmake

  target_sources(<target>
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

指定在构建目标和/或其依赖项时要使用的源。命名的\ ``<target>``\ 必须是由\
:command:`add_executable`\ 或\ :command:`add_library`\ 或\
:command:`add_custom_target`\ 等命令创建的，并且不能是\
:ref:`别名目标 <Alias Targets>`。\ ``<items>``\ 可以使用\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。

.. versionadded:: 3.20
  ``<target>`` can be a custom target.

The ``INTERFACE``, ``PUBLIC`` and ``PRIVATE`` keywords are required to
specify the :ref:`scope <Target Command Scope>` of the source file paths
(``<items>``) that follow them.  ``PRIVATE`` and ``PUBLIC`` items will
populate the :prop_tgt:`SOURCES` property of ``<target>``, which are used when
building the target itself. ``PUBLIC`` and ``INTERFACE`` items will populate the
:prop_tgt:`INTERFACE_SOURCES` property of ``<target>``, which are used
when building dependents.  A target created by :command:`add_custom_target`
can only have ``PRIVATE`` scope.

Repeated calls for the same ``<target>`` append items in the order called.

.. versionadded:: 3.3
  Allow exporting targets with :prop_tgt:`INTERFACE_SOURCES`.

.. versionadded:: 3.11
  Allow setting ``INTERFACE`` items on
  :ref:`IMPORTED targets <Imported Targets>`.

.. versionchanged:: 3.13
  Relative source file paths are interpreted as being relative to the current
  source directory (i.e. :variable:`CMAKE_CURRENT_SOURCE_DIR`).
  See policy :policy:`CMP0076`.

A path that begins with a generator expression is left unmodified.
When a target's :prop_tgt:`SOURCE_DIR` property differs from
:variable:`CMAKE_CURRENT_SOURCE_DIR`, use absolute paths in generator
expressions to ensure the sources are correctly assigned to the target.

.. code-block:: cmake

  # WRONG: starts with generator expression, but relative path used
  target_sources(MyTarget PRIVATE "$<$<CONFIG:Debug>:dbgsrc.cpp>")

  # CORRECT: absolute path used inside the generator expression
  target_sources(MyTarget PRIVATE "$<$<CONFIG:Debug>:${CMAKE_CURRENT_SOURCE_DIR}/dbgsrc.cpp>")

See the :manual:`cmake-buildsystem(7)` manual for more on defining
buildsystem properties.

.. _`File Sets`:

文件集
^^^^^^^^^

.. versionadded:: 3.23

.. code-block:: cmake

  target_sources(<target>
    [<INTERFACE|PUBLIC|PRIVATE>
     [FILE_SET <set> [TYPE <type>] [BASE_DIRS <dirs>...] [FILES <files>...]]...
    ]...)

将文件集添加到目标，或将文件添加到现有文件集。目标有零个或多个命名文件集。每个文件集都有名称、\
类型、\ ``INTERFACE``\ 、\ ``PUBLIC``\ 或\ ``PRIVATE``\ 范围、一个或多个基本目录以及\
这些目录中的文件。可接受的类型包括：

``HEADERS``

  Sources intended to be used via a language's ``#include`` mechanism.

``CXX_MODULES``
  .. versionadded:: 3.28

  Sources which contain C++ interface module or partition units (i.e., those
  using the ``export`` keyword). This file set type may not have an
  ``INTERFACE`` scope except on ``IMPORTED`` targets.

The optional default file sets are named after their type. The target may not
be a custom target or :prop_tgt:`FRAMEWORK` target.

Files in a ``PRIVATE`` or ``PUBLIC`` file set are marked as source files for
the purposes of IDE integration. Additionally, files in ``HEADERS`` file sets
have their :prop_sf:`HEADER_FILE_ONLY` property set to ``TRUE``. Files in an
``INTERFACE`` or ``PUBLIC`` file set can be installed with the
:command:`install(TARGETS)` command, and exported with the
:command:`install(EXPORT)` and :command:`export` commands.

Each ``target_sources(FILE_SET)`` entry starts with ``INTERFACE``, ``PUBLIC``, or
``PRIVATE`` and accepts the following arguments:

``FILE_SET <set>``

  The name of the file set to create or add to. It must contain only letters,
  numbers and underscores. Names starting with a capital letter are reserved
  for built-in file sets predefined by CMake. The only predefined set names
  are those matching the acceptable types. All other set names must not start
  with a capital letter or
  underscore.

``TYPE <type>``

  Every file set is associated with a particular type of file. Only types
  specified above may be used and it is an error to specify anything else. As
  a special case, if the name of the file set is one of the types, the type
  does not need to be specified and the ``TYPE <type>`` arguments can be
  omitted. For all other file set names, ``TYPE`` is required.

``BASE_DIRS <dirs>...``

  An optional list of base directories of the file set. Any relative path
  is treated as relative to the current source directory
  (i.e. :variable:`CMAKE_CURRENT_SOURCE_DIR`). If no ``BASE_DIRS`` are
  specified when the file set is first created, the value of
  :variable:`CMAKE_CURRENT_SOURCE_DIR` is added. This argument supports
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

  No two base directories for a file set may be sub-directories of each other.
  This requirement must be met across all base directories added to a file set,
  not just those within a single call to ``target_sources()``.

``FILES <files>...``

  An optional list of files to add to the file set. Each file must be in
  one of the base directories, or a subdirectory of one of the base
  directories. This argument supports
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

  If relative paths are specified, they are considered relative to
  :variable:`CMAKE_CURRENT_SOURCE_DIR` at the time ``target_sources()`` is
  called. An exception to this is a path starting with ``$<``. Such paths
  are treated as relative to the target's source directory after evaluation
  of generator expressions.

The following target properties are set by ``target_sources(FILE_SET)``,
but they should not generally be manipulated directly:

For file sets of type ``HEADERS``:

* :prop_tgt:`HEADER_SETS`
* :prop_tgt:`INTERFACE_HEADER_SETS`
* :prop_tgt:`HEADER_SET`
* :prop_tgt:`HEADER_SET_<NAME>`
* :prop_tgt:`HEADER_DIRS`
* :prop_tgt:`HEADER_DIRS_<NAME>`

For file sets of type ``CXX_MODULES``:

* :prop_tgt:`CXX_MODULE_SETS`
* :prop_tgt:`INTERFACE_CXX_MODULE_SETS`
* :prop_tgt:`CXX_MODULE_SET`
* :prop_tgt:`CXX_MODULE_SET_<NAME>`
* :prop_tgt:`CXX_MODULE_DIRS`
* :prop_tgt:`CXX_MODULE_DIRS_<NAME>`

Target properties related to include directories are also modified by
``target_sources(FILE_SET)`` as follows:

:prop_tgt:`INCLUDE_DIRECTORIES`

  If the ``TYPE`` is ``HEADERS``, and the scope of the file set is ``PRIVATE``
  or ``PUBLIC``, all of the ``BASE_DIRS`` of the file set are wrapped in
  :genex:`$<BUILD_INTERFACE>` and appended to this property.

:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`

  If the ``TYPE`` is ``HEADERS``, and the scope of the file set is
  ``INTERFACE`` or ``PUBLIC``, all of the ``BASE_DIRS`` of the file set are
  wrapped in :genex:`$<BUILD_INTERFACE>` and appended to this property.

另请参阅
^^^^^^^^

* :command:`add_executable`
* :command:`add_library`
* :command:`target_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
