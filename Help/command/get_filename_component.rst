get_filename_component
----------------------

获取完整文件名的特定组件。

.. versionchanged:: 3.20
  除了\ ``REALPATH``\ 和\ ``PROGRAM``\ 模式外，此命令已被\ :command:`cmake_path`\
  命令取代。其中，\ ``REALPATH``\ 模式现在由\ :command:`file(REAL_PATH)`\ 提供，\
  ``PROGRAM``\ 模式现在可通过\ :command:`separate_arguments(PROGRAM)`\ 实现。

.. versionchanged:: 3.24
  原有的一项未文档化用于查询\ ``Windows``\ 注册表的功能，现已被\
  :command:`cmake_host_system_information(QUERY WINDOWS_REGISTRY)`\
  命令所取代。

.. code-block:: cmake

  get_filename_component(<var> <FileName> <mode> [CACHE])

Sets ``<var>`` to a component of ``<FileName>``, where ``<mode>`` is one of:

* ``DIRECTORY`` - directory without file name.
* ``NAME``      - file name without directory.
* ``EXT``       - file name longest extension (``.b.c`` from ``d/a.b.c``).
* ``NAME_WE``   - file name with neither the directory nor the longest extension.
* ``LAST_EXT``  - file name last extension (``.c`` from ``d/a.b.c``).
* ``NAME_WLE``  - file name with neither the directory nor the last extension.
* ``PATH``      - legacy alias for ``DIRECTORY`` (use for CMake <= 2.8.11).

.. versionadded:: 3.14
  Added the ``LAST_EXT`` and ``NAME_WLE`` modes.

Paths are returned with forward slashes and have no trailing slashes.
If the optional ``CACHE`` argument is specified, the result variable is
added to the cache.

.. code-block:: cmake

  get_filename_component(<var> <FileName> <mode> [BASE_DIR <dir>] [CACHE])

.. versionadded:: 3.4

Sets ``<var>`` to the absolute path of ``<FileName>``, where ``<mode>`` is one
of:

* ``ABSOLUTE`` - full path to file.
* ``REALPATH`` - full path to existing file with symlinks resolved.

If the provided ``<FileName>`` is a relative path, it is evaluated relative
to the given base directory ``<dir>``.  If no base directory is
provided, the default base directory will be
:variable:`CMAKE_CURRENT_SOURCE_DIR`.

Paths are returned with forward slashes and have no trailing slashes.  If the
optional ``CACHE`` argument is specified, the result variable is added to the
cache.

.. code-block:: cmake

  get_filename_component(<var> <FileName> PROGRAM [PROGRAM_ARGS <arg_var>] [CACHE])

The program in ``<FileName>`` will be found in the system search path or
left as a full path.  If ``PROGRAM_ARGS`` is present with ``PROGRAM``, then
any command-line arguments present in the ``<FileName>`` string are split
from the program name and stored in ``<arg_var>``.  This is used to
separate a program name from its arguments in a command line string.

See Also
^^^^^^^^

* :command:`cmake_path`
