cmake_policy
------------

管理CMake Policy设置。请参考\ :manual:`cmake-policies(7)`\ 手册了解已定义的策略。

随着CMake的发展，有时为了修复bug或改进现有功能的实现，有必要改变现有的行为。\
CMake策略机制旨在确保在CMake新版本引入行为变更时，现有项目仍能正常构建。\
每个新策略（行为变更）都会被赋予一个格式为\ ``CMP<NNNN>``\ 的标识符，其中\ ``<NNNN>``\
是一个整数索引。\
与每个策略相关的文档描述了该策略的\ ``OLD``\ 行为和\ ``NEW``\ 行为，以及引入该策略的原因。\
项目可以设置每个策略，以选择所需的行为。\
当CMake需要确定使用哪种行为时，它会检查项目指定的设置。\
如果没有可用的设置，CMake会默认采用\ ``OLD``\ 行为，并发出警告，提示需要设置该策略。

通过CMake版本设置策略
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``cmake_policy``\ 命令用于将策略设置为\ ``OLD``\ 或\ ``NEW``\ 行为。\
虽然支持单独设置策略，但我们鼓励项目根据CMake版本来设置策略：

.. signature:: cmake_policy(VERSION <min>[...<max>])
  :target: VERSION

.. versionadded:: 3.12
  The optional ``<max>`` version.

``<min>``\ 和可选的\ ``<max>``\ 均为\ ``major.minor[.patch[.tweak]]``\ 格式的CMake\
版本，并且\ ``...``\ 是字面值。\
``<min>``\ 版本号必须至少为\ ``2.4``，且最多为当前运行的CMake版本。\
如果指定了\ ``<max>``\ 版本号，它必须至少等于\ ``<min>``\ 版本号，但可以超过当前运行的CMake版本。\
如果运行的CMake版本早于3.12，额外的\ ``...``\ 会被视为版本号的分隔符，导致\ ``...<max>``\
部分被忽略，从而保留3.12之前基于\ ``<min>``\ 设置策略的行为。

.. include:: POLICY_VERSION.txt

请注意，\ :command:`cmake_minimum_required(VERSION)`\ 命令也会隐式调用\ ``cmake_policy(VERSION)``。

.. include:: DEPRECATED_POLICY_VERSIONS.txt

显式设置策略
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. signature:: cmake_policy(SET CMP<NNNN> NEW|OLD)
  :target: SET

告知CMake对指定策略使用\ ``OLD``\ 或\ ``NEW``\ 行为。\
依赖于特定策略旧行为的项目可以通过将策略状态设置为\ ``OLD``\ 来消除策略警告。\
或者，用户可以修改项目以适应新行为，并将策略状态设置为\ ``NEW``。

.. include:: ../policy/DEPRECATED.txt

检查策略设置
^^^^^^^^^^^^^^^^^^^^^^^^

.. signature:: cmake_policy(GET CMP<NNNN> <variable>)
  :target: GET

检查指定策略是否设置为\ ``OLD``\ 或\ ``NEW``\ 行为。\
如果策略已设置，输出的\ ``<variable>``\ 值将为\ ``OLD``\ 或\ ``NEW``；否则，该值将为空。

CMake策略栈
^^^^^^^^^^^^^^^^^^

CMake将策略设置存储在一个栈中，因此\ ``cmake_policy``\ 命令所做的更改仅影响栈顶。\
为每个子目录自动管理策略栈中的一个新条目，以保护其父目录和同级目录。\
CMake还会为通过\ :command:`include`\ 和\ :command:`find_package`\ 命令加载的脚本管理\
一个新的策略栈条目，除非在调用这些命令时使用了\ ``NO_POLICY_SCOPE``\ 选项（另请参阅策略\
:policy:`CMP0011`）。\
``cmake_policy``\ 命令提供了一个接口，用于管理策略栈上的自定义条目：

.. signature:: cmake_policy(PUSH)
  :target: PUSH

  在策略栈上创建一个新条目。

.. signature:: cmake_policy(POP)
  :target: POP

  移除使用\ ``cmake_policy(PUSH)``\ 创建的策略栈的最后一个条目。

Each ``PUSH`` must have a matching ``POP`` to erase any changes.
This is useful to make temporary changes to policy settings.
Calls to the :command:`cmake_minimum_required(VERSION)`,
:command:`cmake_policy(VERSION)`, or :command:`cmake_policy(SET)` commands
influence only the current top of the policy stack.

.. versionadded:: 3.25
  The :command:`block(SCOPE_FOR POLICIES)` command offers a more flexible
  and more secure way to manage the policy stack. The pop action is done
  automatically when leaving the block scope, so there is no need to
  precede each :command:`return` with a call to :command:`cmake_policy(POP)`.

  .. code-block:: cmake

    # stack management with cmake_policy()
    function(my_func)
      cmake_policy(PUSH)
      cmake_policy(SET ...)
      if (<cond1>)
        ...
        cmake_policy(POP)
        return()
      elseif(<cond2>)
        ...
        cmake_policy(POP)
        return()
      endif()
      ...
      cmake_policy(POP)
    endfunction()

    # stack management with block()/endblock()
    function(my_func)
      block(SCOPE_FOR POLICIES)
        cmake_policy(SET ...)
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

Commands created by the :command:`function` and :command:`macro`
commands record policy settings when they are created and
use the pre-record policies when they are invoked.  If the function or
macro implementation sets policies, the changes automatically
propagate up through callers until they reach the closest nested
policy stack entry.

See Also
^^^^^^^^

* :command:`cmake_minimum_required`
