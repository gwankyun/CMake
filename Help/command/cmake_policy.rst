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

.. include:: include/POLICY_VERSION.rst

请注意，\ :command:`cmake_minimum_required(VERSION)`\ 命令也会隐式调用\ ``cmake_policy(VERSION)``。

.. include:: include/DEPRECATED_POLICY_VERSIONS.rst

显式设置策略
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. signature:: cmake_policy(SET CMP<NNNN> NEW|OLD)
  :target: SET

告知CMake对指定策略使用\ ``OLD``\ 或\ ``NEW``\ 行为。\
依赖于特定策略旧行为的项目可以通过将策略状态设置为\ ``OLD``\ 来消除策略警告。\
或者，用户可以修改项目以适应新行为，并将策略状态设置为\ ``NEW``。

.. include:: ../policy/include/DEPRECATED.rst

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

每次调用\ ``PUSH``\ 都必须有对应的\ ``POP``\ 来消除所做的任何更改。\
这对于对策略设置进行临时修改很有用。\
调用\ :command:`cmake_minimum_required(VERSION)`、\ :command:`cmake_policy(VERSION)`\
或\ :command:`cmake_policy(SET)`\ 命令仅影响策略栈的当前栈顶。

.. versionadded:: 3.25
  :command:`block(SCOPE_FOR POLICIES)`\ 命令提供了一种更灵活、更安全的策略栈管理方式。\
  当离开block作用域时，弹出操作会自动执行，因此无需在每个\ :command:`return`\ 语句前调用\
  :command:`cmake_policy(POP)`。

  .. code-block:: cmake

    # 使用cmake_policy()进行栈管理
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

    # 使用block()/endblock()进行栈管理
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

由\ :command:`function`\ 和\ :command:`macro`\ 命令创建的指令会在创建时记录策略设置，\
并在调用时使用预先记录的策略。\
如果函数或宏的实现中设置了策略，这些更改会自动向上传播，经过调用者，直到到达最近的嵌套策略栈条目。

另请参阅
^^^^^^^^

* :command:`cmake_minimum_required`
