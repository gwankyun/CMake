target_compile_definitions
--------------------------

向目标添加编译定义。

.. code-block:: cmake

  target_compile_definitions(<target>
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

指定编译给定\ ``<target>``\ 时要使用的编译定义。命名的\ ``<target>``\ 必须是由\
:command:`add_executable`\ 或\ :command:`add_library`\ 等命令创建的，并且不能是\
:ref:`别名目标 <Alias Targets>`。

The ``INTERFACE``, ``PUBLIC`` and ``PRIVATE`` keywords are required to
specify the :ref:`scope <Target Usage Requirements>` of the following arguments.
``PRIVATE`` and ``PUBLIC`` items will populate the :prop_tgt:`COMPILE_DEFINITIONS`
property of ``<target>``. ``PUBLIC`` and ``INTERFACE`` items will populate the
:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS` property of ``<target>``.
The following arguments specify compile definitions.  Repeated calls for the
same ``<target>`` append items in the order called.

.. versionadded:: 3.11
  Allow setting ``INTERFACE`` items on :ref:`IMPORTED targets <Imported Targets>`.

.. |command_name| replace:: ``target_compile_definitions``
.. include:: GENEX_NOTE.txt

Any leading ``-D`` on an item will be removed.  Empty items are ignored.
For example, the following are all equivalent:

.. code-block:: cmake

  target_compile_definitions(foo PUBLIC FOO)
  target_compile_definitions(foo PUBLIC -DFOO)  # -D removed
  target_compile_definitions(foo PUBLIC "" FOO) # "" ignored
  target_compile_definitions(foo PUBLIC -D FOO) # -D becomes "", then ignored

Definitions may optionally have values:

.. code-block:: cmake

  target_compile_definitions(foo PUBLIC FOO=1)

Note that many compilers treat ``-DFOO`` as equivalent to ``-DFOO=1``, but
other tools may not recognize this in all circumstances (e.g. IntelliSense).

See Also
^^^^^^^^

* :command:`add_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`
