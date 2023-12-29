CMAKE_MESSAGE_INDENT
--------------------

.. versionadded:: 3.16

:command:`message`\ 命令连接该列表中的字符串，对于\ ``NOTICE``\ 及以下的日志级别，它将\
结果字符串添加到消息的每一行。

Example:

.. code-block:: cmake

  list(APPEND listVar one two three)

  message(VERBOSE [[Collected items in the "listVar":]])
  list(APPEND CMAKE_MESSAGE_INDENT "  ")

  foreach(item IN LISTS listVar)
    message(VERBOSE ${item})
  endforeach()

  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(VERBOSE "No more indent")

Which results in the following output:

.. code-block:: none

  -- Collected items in the "listVar":
  --   one
  --   two
  --   three
  -- No more indent
