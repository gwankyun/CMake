add_executable
--------------

.. only:: html

  .. contents::

使用指定的源文件向项目添加可执行文件。

正常可执行文件
^^^^^^^^^^^^^^^^^^

.. signature::
  add_executable(<name> <options>... <sources>...)
  :target: normal

  添加一个名为\ ``<name>``\ 的可执行目标，以便从命令调用中列出的源文件构建。

  The options are:

  ``WIN32``
    Set the :prop_tgt:`WIN32_EXECUTABLE` target property automatically.
    See documentation of that target property for details.

  ``MACOSX_BUNDLE``
    Set the :prop_tgt:`MACOSX_BUNDLE` target property automatically.
    See documentation of that target property for details.

  ``EXCLUDE_FROM_ALL``
    Set the :prop_tgt:`EXCLUDE_FROM_ALL` target property automatically.
    See documentation of that target property for details.

The ``<name>`` corresponds to the logical target name and must be globally
unique within a project.  The actual file name of the executable built is
constructed based on conventions of the native platform (such as
``<name>.exe`` or just ``<name>``).

.. versionadded:: 3.1
  Source arguments to ``add_executable`` may use "generator expressions" with
  the syntax ``$<...>``.  See the :manual:`cmake-generator-expressions(7)`
  manual for available expressions.

.. versionadded:: 3.11
  The source files can be omitted if they are added later using
  :command:`target_sources`.

By default the executable file will be created in the build tree
directory corresponding to the source tree directory in which the
command was invoked.  See documentation of the
:prop_tgt:`RUNTIME_OUTPUT_DIRECTORY` target property to change this
location.  See documentation of the :prop_tgt:`OUTPUT_NAME` target property
to change the ``<name>`` part of the final file name.

See the :manual:`cmake-buildsystem(7)` manual for more on defining
buildsystem properties.

See also :prop_sf:`HEADER_FILE_ONLY` on what to do if some sources are
pre-processed, and you want to have the original sources reachable from
within IDE.

导入的可执行文件
^^^^^^^^^^^^^^^^^^^^

.. signature::
  add_executable(<name> IMPORTED [GLOBAL])
  :target: IMPORTED

  添加\ :ref:`IMPORTED可执行目标 <Imported Targets>` ，以引用位于项目外部的可执行文件。\
  目标名称可以像在项目中构建的任何目标一样被引用，除了默认情况下它只在创建它的目录中可见之外。

  The options are:

  ``GLOBAL``
    Make the target name globally visible.

No rules are generated to build imported targets, and the :prop_tgt:`IMPORTED`
target property is ``True``.  Imported executables are useful for convenient
reference from commands like :command:`add_custom_command`.

Details about the imported executable are specified by setting properties
whose names begin in ``IMPORTED_``.  The most important such property is
:prop_tgt:`IMPORTED_LOCATION` (and its per-configuration version
:prop_tgt:`IMPORTED_LOCATION_<CONFIG>`) which specifies the location of
the main executable file on disk.  See documentation of the ``IMPORTED_*``
properties for more information.

可执行文件别名
^^^^^^^^^^^^^^^^^

.. signature::
  add_executable(<name> ALIAS <target>)
  :target: ALIAS

  创建一个\ :ref:`Alias Target <Alias Targets>`，这样\ ``<name>``\ 就可以用来在后续\
  命令中引用\ ``<target>``。\ ``<name>``\ 不会作为make目标出现在生成的构建系统中。\
  ``<target>``\ 不能是\ ``ALIAS``。

.. versionadded:: 3.11
  An ``ALIAS`` can target a ``GLOBAL`` :ref:`Imported Target <Imported Targets>`

.. versionadded:: 3.18
  An ``ALIAS`` can target a non-``GLOBAL`` Imported Target. Such alias is
  scoped to the directory in which it is created and subdirectories.
  The :prop_tgt:`ALIAS_GLOBAL` target property can be used to check if the
  alias is global or not.

``ALIAS`` targets can be used as targets to read properties
from, executables for custom commands and custom targets.  They can also be
tested for existence with the regular :command:`if(TARGET)` subcommand.
The ``<name>`` may not be used to modify properties of ``<target>``, that
is, it may not be used as the operand of :command:`set_property`,
:command:`set_target_properties`, :command:`target_link_libraries` etc.
An ``ALIAS`` target may not be installed or exported.

另请参阅
^^^^^^^^

* :command:`add_library`
