cmake_diagnostic
----------------

.. versionadded:: 4.4

管理 CMake 诊断设置。有关可用类别的列表，请参阅 :manual:`cmake-diagnostics(7)` 手册。

概述
^^^^^^^^

.. parsed-literal::

  `设置诊断`_
    cmake_diagnostic(`SET`_ <category> <action> [RECURSE])
    cmake_diagnostic(`PROMOTE`_ <category> <action> [NO_RECURSE])
    cmake_diagnostic(`DEMOTE`_ <category> <action> [NO_RECURSE])

  `检查诊断动作`_
    cmake_diagnostic(`GET`_ <diagnostic> <out-var>)

  `CMake 诊断栈`_
    cmake_diagnostic(`PUSH`_)
    cmake_diagnostic(`POP`_)

设置诊断
^^^^^^^^^^^^^^^^^^^

.. signature::
  cmake_diagnostic(SET CMD_<CATEGORY> <action> [RECURSE])
  cmake_diagnostic(PROMOTE CMD_<CATEGORY> <action> [NO_RECURSE])
  cmake_diagnostic(DEMOTE CMD_<CATEGORY> <action> [NO_RECURSE])
  :target:
    SET
    PROMOTE
    DEMOTE

设置或修改当属于特定类别的诊断被触发时采取的动作。

``SET`` 子命令为指定的诊断类别设置动作。 ``PROMOTE`` 子命令提高指定诊断类别的严重级别，\
如果动作已设置为同等或更高的严重级别，则不做任何操作。 ``DEMOTE`` 子命令降低指定诊断类别的\
严重级别，如果动作已设置为同等或更低的严重级别，则不做任何操作。

可能的 ``<action>`` （按严重级别排序）为：

``IGNORE``
  不做任何操作。

``WARN``
  报告警告并继续处理。

``SEND_ERROR``
  报告错误，继续处理，但跳过生成步骤。

  :manual:`cmake(1)` 可执行文件将返回非零\ :ref:`退出码 <CMake Exit Code>`。

``FATAL_ERROR``
  报告错误，停止处理和生成。

  :manual:`cmake(1)` 可执行文件将返回非零\ :ref:`退出码 <CMake Exit Code>`。

某些诊断类别具有层级结构。 ``RECURSE`` 和 ``NO_RECURSE`` 选项决定修改诊断类别的动作时是否\
同时修改其子类别。默认情况下， ``PROMOTE`` 和 ``DEMOTE`` 子命令是递归的，而 ``SET`` 子命令\
不是。请注意，对子类别的修改与父类别上先前设置的动作无关；也就是说， ``PROMOTE`` 和 ``DEMOTE``
在递归操作时，将对所有子类别进行操作，即使父类别的动作未被修改。

检查诊断动作
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. signature:: cmake_diagnostic(GET CMD_<CATEGORY> <variable>)
  :target: GET

检查当前为某个诊断类别指定的动作。输出 ``<variable>`` 的值将为 ``IGNORE``、
``WARN``、 ``SEND_ERROR`` 或 ``FATAL_ERROR`` 之一。

CMake 诊断栈
^^^^^^^^^^^^^^^^^^^^^^

CMake 将诊断设置保存在栈中，因此 ``cmake_diagnostic`` 命令所做的更改仅影响栈顶。诊断栈上的\
新条目会为每个子目录自动管理，以保护其父目录和同级目录。CMake 还会为由 :command:`include`
和 :command:`find_package` 命令加载的脚本管理新条目，除非调用时使用了 ``NO_DIAGNOSTIC_SCOPE``
选项。 ``cmake_diagnostic`` 命令提供了管理诊断栈上自定义条目的接口：

.. signature:: cmake_diagnostic(PUSH)

  在诊断栈上创建新条目。

.. signature:: cmake_diagnostic(POP)

  移除由 ``cmake_diagnostic(PUSH)`` 创建的最后一个诊断栈条目。

每个 ``PUSH`` 必须有一个匹配的 ``POP`` 来撤销任何更改。这对于临时修改诊断设置非常有用。\
对 :command:`cmake_diagnostic(SET)`、 :command:`cmake_diagnostic(PROMOTE)` 或
:command:`cmake_diagnostic(DEMOTE)` 命令的调用仅影响诊断栈的当前栈顶。

:command:`block(SCOPE_FOR DIAGNOSTICS)` 命令提供了一种更灵活、更安全的方式来管理诊断栈。\
弹出操作在离开块作用域时自动完成，因此无需在每个 :command:`return` 之前调用
:command:`cmake_diagnostic(POP)`。

.. code-block:: cmake

  # 使用 cmake_diagnostic() 管理栈
  function(my_func)
    cmake_diagnostic(PUSH)
    cmake_diagnostic(SET ...)
    if (<cond1>)
      ...
      cmake_diagnostic(POP)
      return()
    elseif(<cond2>)
      ...
      cmake_diagnostic(POP)
      return()
    endif()
    ...
    cmake_diagnostic(POP)
  endfunction()

  # 使用 block()/endblock() 管理栈
  function(my_func)
    block(SCOPE_FOR DIAGNOSTICS)
      cmake_diagnostic(SET ...)
      if (<cond1>)
        ...
        return()
      elseif(<cond2>)
        ...
        return()
      endif()
      ...
    endblock()
  endfunction()

由 :command:`function` 和 :command:`macro` 命令创建的命令在创建时记录诊断设置，
并在被调用时使用预先记录的诊断。如果函数或宏的实现设置了诊断，这些更改会自动向上传播到调用者，\
直到到达最近的嵌套诊断栈条目。
