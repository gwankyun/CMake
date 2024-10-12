# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
CheckCSourceRuns
----------------

检查一次给定的C源代码是否可以编译并链接到可执行文件中，并且随后可以运行。

.. command:: check_c_source_runs

  .. code-block:: cmake

    check_c_source_runs(<code> <resultVar>)

  Check once that the source supplied in ``<code>`` can be built, linked as an
  executable, and then run. The ``<code>`` must contain at least a ``main()``
  function.

  The result is stored in the internal cache variable specified by
  ``<resultVar>``. Success of build and run is indicated by boolean ``true``.
  Failure to build or run is indicated by boolean ``false`` such as an empty
  string or an error message.

  See also :command:`check_source_runs` for a more general command syntax.

  The compile and link commands can be influenced by setting any of the
  following variables prior to calling ``check_c_source_runs()``:

.. include:: /module/CMAKE_REQUIRED_FLAGS.txt

.. include:: /module/CMAKE_REQUIRED_DEFINITIONS.txt

.. include:: /module/CMAKE_REQUIRED_INCLUDES.txt

.. include:: /module/CMAKE_REQUIRED_LINK_OPTIONS.txt

.. include:: /module/CMAKE_REQUIRED_LIBRARIES.txt

.. include:: /module/CMAKE_REQUIRED_LINK_DIRECTORIES.txt

.. include:: /module/CMAKE_REQUIRED_QUIET.txt

#]=======================================================================]

include_guard(GLOBAL)
include(Internal/CheckSourceRuns)

macro(CHECK_C_SOURCE_RUNS SOURCE VAR)
  set(_CheckSourceRuns_old_signature 1)
  cmake_check_source_runs(C "${SOURCE}" ${VAR} ${ARGN})
  unset(_CheckSourceRuns_old_signature)
endmacro()
