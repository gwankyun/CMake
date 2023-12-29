CMAKE_MESSAGE_CONTEXT
---------------------

.. versionadded:: 3.17

当\ :option:`cmake --log-context`\ 命令行选项或\
:variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ 变量启用时，\ :command:`message`\ 命令将\
``CMAKE_MESSAGE_CONTEXT``\ 列表转换为一个用方括号包围的点分隔字符串，并将其添加到日志级别\
``NOTICE``\ 及以下的消息的每行。

For logging contexts to work effectively, projects should generally
``APPEND`` and ``POP_BACK`` an item to the current value of
``CMAKE_MESSAGE_CONTEXT`` rather than replace it.
Projects should not assume the message context at the top of the source tree
is empty, as there are scenarios where the context might have already been set
(e.g. hierarchical projects).

.. warning::

  Valid context names are restricted to anything that could be used
  as a CMake variable name.  All names that begin with an underscore
  or the string ``cmake_`` are also reserved for use by CMake and
  should not be used by projects.

Example:

.. code-block:: cmake

  function(bar)
    list(APPEND CMAKE_MESSAGE_CONTEXT "bar")
    message(VERBOSE "bar VERBOSE message")
  endfunction()

  function(baz)
    list(APPEND CMAKE_MESSAGE_CONTEXT "baz")
    message(DEBUG "baz DEBUG message")
  endfunction()

  function(foo)
    list(APPEND CMAKE_MESSAGE_CONTEXT "foo")
    bar()
    message(TRACE "foo TRACE message")
    baz()
  endfunction()

  list(APPEND CMAKE_MESSAGE_CONTEXT "top")

  message(VERBOSE "Before `foo`")
  foo()
  message(VERBOSE "After `foo`")

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)


Which results in the following output:

.. code-block:: none

  -- [top] Before `foo`
  -- [top.foo.bar] bar VERBOSE message
  -- [top.foo] foo TRACE message
  -- [top.foo.baz] baz DEBUG message
  -- [top] After `foo`
