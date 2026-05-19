if
--

有条件地执行一组命令。

概要
^^^^^^^^

.. code-block:: cmake

  if(<condition>)
    <commands>
  elseif(<condition>) # 可选块，可重复
    <commands>
  else()              # 可选块
    <commands>
  endif()

根据下方所述的\ :ref:`Condition syntax`\ 对\ ``if``\ 子句的\ ``condition``\ 参数进行求值。\
若结果为真，则执行\ ``if``\ 块中的\ ``commands``；
否则，将按相同方式处理可选的\ ``elseif``\ 块。
最终，若所有\ ``condition``\ 均为假，则执行可选\ ``else``\ 块中的\ ``commands``。

根据传统约定，:command:`else`\ 和\ :command:`endif`\ 命令允许接受一个可选的\ ``<condition>``\ 参数。
若使用，则必须为起始\ ``if``\ 命令参数的逐字重复。

.. _`Condition Syntax`:

条件语法
^^^^^^^^^^^^^^^^

适用于\ ``if``、\ ``elseif``\ 和\ :command:`while`\ 子句\ ``condition``\ 参数的语法规则如下。

复合条件的求值顺序按以下优先级进行：

1. `Parentheses`_。

2. 一元测试，包括\ `COMMAND`_、\ `POLICY`_、\ `TARGET`_、\ `TEST`_、
   `EXISTS`_、\ `IS_READABLE`_、\ `IS_WRITABLE`_、\ `IS_EXECUTABLE`_、
   `IS_DIRECTORY`_、\ `IS_SYMLINK`_、\ `IS_ABSOLUTE`_\ 以及\ `DEFINED`_。

3. 二元测试，包括\ `EQUAL`_、\ `LESS`_、\ `LESS_EQUAL`_、\ `GREATER`_、
   `GREATER_EQUAL`_、\ `STREQUAL`_、\ `STRLESS`_、\ `STRLESS_EQUAL`_、
   `STRGREATER`_、\ `STRGREATER_EQUAL`_、\ `VERSION_EQUAL`_、\ `VERSION_LESS`_、
   `VERSION_LESS_EQUAL`_、\ `VERSION_GREATER`_、\ `VERSION_GREATER_EQUAL`_、
   `PATH_EQUAL`_、\ `IN_LIST`_、\ `IS_NEWER_THAN`_\ 以及\ `MATCHES`_。

4. 一元逻辑运算符\ `NOT`_。

5. 二元逻辑运算符\ `AND`_\ 与\ `OR`_，从左到右依次求值，
   且无短路求值（short-circuit）行为。

基础表达式
"""""""""""""""""

.. signature:: if(<constant>)
  :target: constant

  当常量为\ ``1``、\ ``ON``、\ ``YES``、\ ``TRUE``、\ ``Y``\ 或非零数值（含浮点数）时，结果为真。
  常量为\ ``0``、\ ``OFF``、\ ``NO``、\ ``FALSE``、\ ``N``、\ ``IGNORE``、\ ``NOTFOUND``、空字符串，
  或以\ ``-NOTFOUND``\ 后缀结尾时，结果为假。
  具名布尔常量不区分大小写。若参数不属于上述特定常量，
  则将其视为变量或字符串（参见下文的\ `Variable Expansion`_），并适用以下两种形式之一。

.. signature:: if(<variable>)
  :target: variable

  当给定一个已定义为非假常量的变量时，结果为真。
  否则（包括变量未定义的情况）结果为假。
  注意：宏参数不属于变量范畴。
  :ref:`环境变量 <CMake Language Environment Variables>`\ 也无法通过此方式测试，
  例如\ ``if(ENV{some_var})``\ 将始终求值为假。

.. signature:: if(<string>)
  :target: string

  引号字符串通常求值为假，除非：

  * 字符串的值为真常量之一，或
  * 在CMake 4.0之前的版本中，策略\ :policy:`CMP0054`\ 未设置为\ ``NEW``，
    且字符串的值恰好是一个受\ :policy:`CMP0054`\ 行为影响的变量名。

Logic Operators
"""""""""""""""

.. signature:: if(NOT <condition>)

  True if the condition is not true.

.. signature:: if(<cond1> AND <cond2>)
  :target: AND

  True if both conditions would be considered true individually.

.. signature:: if(<cond1> OR <cond2>)
  :target: OR

  True if either condition would be considered true individually.

.. signature:: if((condition) AND (condition OR (condition)))
  :target: parentheses

  The conditions inside the parenthesis are evaluated first and then
  the remaining condition is evaluated as in the other examples.
  Where there are nested parenthesis the innermost are evaluated as part
  of evaluating the condition that contains them.

Existence Checks
""""""""""""""""

.. signature:: if(COMMAND <command-name>)

  True if the given name is a command, macro or function that can be
  invoked.

.. signature:: if(POLICY <policy-id>)

  True if the given name is an existing policy (of the form ``CMP<NNNN>``).

.. signature:: if(TARGET <target-name>)

  True if the given name is an existing logical target name created
  by a call to the :command:`add_executable`, :command:`add_library`,
  or :command:`add_custom_target` command that has already been invoked
  (in any directory).

.. signature:: if(TEST <test-name>)

  .. versionadded:: 3.3

  True if the given name is an existing test name created by the
  :command:`add_test` command.

.. signature:: if(DEFINED <name>|CACHE{<name>}|ENV{<name>})

  True if a variable, cache variable or environment variable
  with given ``<name>`` is defined. The value of the variable
  does not matter. Note the following caveats:

  * Macro arguments are not variables.
  * It is not possible to test directly whether a ``<name>`` is a non-cache
    variable.  The expression ``if(DEFINED someName)`` will evaluate to true
    if either a cache or non-cache variable ``someName`` exists.  In
    comparison, the expression ``if(DEFINED CACHE{someName})`` will only
    evaluate to true if a cache variable ``someName`` exists.  Both expressions
    need to be tested if you need to know whether a non-cache variable exists:
    ``if(DEFINED someName AND NOT DEFINED CACHE{someName})``.

 .. versionadded:: 3.14
  Added support for ``CACHE{<name>}`` variables.

.. signature:: if(<variable|string> IN_LIST <variable>)
  :target: IN_LIST

  .. versionadded:: 3.3

  True if the given element is contained in the named list variable.

File Operations
"""""""""""""""

.. signature:: if(EXISTS <path-to-file-or-directory>)

  True if the named file or directory exists and is readable.  Behavior
  is well-defined only for explicit full paths (a leading ``~/`` is not
  expanded as a home directory and is considered a relative path).
  Resolves symbolic links, i.e. if the named file or directory is a
  symbolic link, returns true if the target of the symbolic link exists.

  False if the given path is an empty string.

  .. note::
    Prefer ``if(IS_READABLE)`` to check file readability.  ``if(EXISTS)``
    may be changed in the future to only check file existence.

.. signature:: if(IS_READABLE <path-to-file-or-directory>)

  .. versionadded:: 3.29

  True if the named file or directory is readable.  Behavior
  is well-defined only for explicit full paths (a leading ``~/`` is not
  expanded as a home directory and is considered a relative path).
  Resolves symbolic links, i.e. if the named file or directory is a
  symbolic link, returns true if the target of the symbolic link is readable.

  False if the given path is an empty string.

.. signature:: if(IS_WRITABLE <path-to-file-or-directory>)

  .. versionadded:: 3.29

  True if the named file or directory is writable.  Behavior
  is well-defined only for explicit full paths (a leading ``~/`` is not
  expanded as a home directory and is considered a relative path).
  Resolves symbolic links, i.e. if the named file or directory is a
  symbolic link, returns true if the target of the symbolic link is writable.

  False if the given path is an empty string.

.. signature:: if(IS_EXECUTABLE <path-to-file-or-directory>)

  .. versionadded:: 3.29

  True if the named file or directory is executable.  Behavior
  is well-defined only for explicit full paths (a leading ``~/`` is not
  expanded as a home directory and is considered a relative path).
  Resolves symbolic links, i.e. if the named file or directory is a
  symbolic link, returns true if the target of the symbolic link is executable.

  False if the given path is an empty string.

.. signature:: if(<file1> IS_NEWER_THAN <file2>)
  :target: IS_NEWER_THAN

  True if ``file1`` is newer than ``file2`` or if one of the two files doesn't
  exist.  Behavior is well-defined only for full paths.  If the file
  time stamps are exactly the same, an ``IS_NEWER_THAN`` comparison returns
  true, so that any dependent build operations will occur in the event
  of a tie.  This includes the case of passing the same file name for
  both file1 and file2.

.. signature:: if(IS_DIRECTORY <path>)

  True if ``path`` is a directory.  Behavior is well-defined only
  for full paths.

  False if the given path is an empty string.

.. signature:: if(IS_SYMLINK <path>)

  True if the given path is a symbolic link.  Behavior is well-defined
  only for full paths.

.. signature:: if(IS_ABSOLUTE <path>)

  True if the given path is an absolute path.  Note the following special
  cases:

  * An empty ``path`` evaluates to false.
  * On Windows hosts, any ``path`` that begins with a drive letter and colon
    (e.g. ``C:``), a forward slash or a backslash will evaluate to true.
    This means a path like ``C:no\base\dir`` will evaluate to true, even
    though the non-drive part of the path is relative.
  * On non-Windows hosts, any ``path`` that begins with a tilde (``~``)
    evaluates to true.

Comparisons
"""""""""""

.. signature:: if(<variable|string> MATCHES <regex>)
  :target: MATCHES

  True if the given string or variable's value matches the given regular
  expression.  See :ref:`Regex Specification` for regex format.

  .. versionadded:: 2.6
   ``()`` groups are captured in :variable:`CMAKE_MATCH_<n>` variables.

.. signature:: if(<variable|string> LESS <variable|string>)
  :target: LESS

  True if the given string or variable's value parses as a real number
  (like a C ``double``) and less than that on the right.

.. signature:: if(<variable|string> GREATER <variable|string>)
  :target: GREATER

  True if the given string or variable's value parses as a real number
  (like a C ``double``) and greater than that on the right.

.. signature:: if(<variable|string> EQUAL <variable|string>)
  :target: EQUAL

  True if the given string or variable's value parses as a real number
  (like a C ``double``) and equal to that on the right.

.. signature:: if(<variable|string> LESS_EQUAL <variable|string>)
  :target: LESS_EQUAL

  .. versionadded:: 3.7

  True if the given string or variable's value parses as a real number
  (like a C ``double``) and less than or equal to that on the right.

.. signature:: if(<variable|string> GREATER_EQUAL <variable|string>)
  :target: GREATER_EQUAL

  .. versionadded:: 3.7

  True if the given string or variable's value parses as a real number
  (like a C ``double``) and greater than or equal to that on the right.

.. signature:: if(<variable|string> STRLESS <variable|string>)
  :target: STRLESS

  True if the given string or variable's value is lexicographically less
  than the string or variable on the right.

.. signature:: if(<variable|string> STRGREATER <variable|string>)
  :target: STRGREATER

  True if the given string or variable's value is lexicographically greater
  than the string or variable on the right.

.. signature:: if(<variable|string> STREQUAL <variable|string>)
  :target: STREQUAL

  True if the given string or variable's value is lexicographically equal
  to the string or variable on the right.

.. signature:: if(<variable|string> STRLESS_EQUAL <variable|string>)
  :target: STRLESS_EQUAL

  .. versionadded:: 3.7

  True if the given string or variable's value is lexicographically less
  than or equal to the string or variable on the right.

.. signature:: if(<variable|string> STRGREATER_EQUAL <variable|string>)
  :target: STRGREATER_EQUAL

  .. versionadded:: 3.7

  True if the given string or variable's value is lexicographically greater
  than or equal to the string or variable on the right.

Version Comparisons
"""""""""""""""""""

.. signature:: if(<variable|string> VERSION_LESS <variable|string>)
  :target: VERSION_LESS

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

.. signature:: if(<variable|string> VERSION_GREATER <variable|string>)
  :target: VERSION_GREATER

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

.. signature:: if(<variable|string> VERSION_EQUAL <variable|string>)
  :target: VERSION_EQUAL

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

.. signature:: if(<variable|string> VERSION_LESS_EQUAL <variable|string>)
  :target: VERSION_LESS_EQUAL

  .. versionadded:: 3.7

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

.. signature:: if(<variable|string> VERSION_GREATER_EQUAL <variable|string>)
  :target: VERSION_GREATER_EQUAL

  .. versionadded:: 3.7

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

Path Comparisons
""""""""""""""""

.. signature:: if(<variable|string> PATH_EQUAL <variable|string>)
  :target: PATH_EQUAL

  .. versionadded:: 3.24

  Lexicographically compares two CMake paths component-by-component without
  accessing the filesystem. Only if every component of both paths match will
  the two paths compare equal.  Multiple path separators are effectively
  collapsed into a single separator, but note that backslashes are not
  converted to forward slashes.
  No other :ref:`path normalization <Normalization>` is performed.
  Trailing slashes are preserved, thus ``/a/b`` and ``/a/b/`` are not equal.

  Component-wise comparison is superior to string-based comparison due to the
  handling of multiple path separators.  In the following example, the
  expression evaluates to true using ``PATH_EQUAL``, but false with
  ``STREQUAL``:

  .. code-block:: cmake

    # comparison is TRUE
    if ("/a//b/c" PATH_EQUAL "/a/b/c")
       ...
    endif()

    # comparison is FALSE
    if ("/a//b/c" STREQUAL "/a/b/c")
       ...
    endif()

  See :ref:`cmake_path(COMPARE) <Path Comparison>` for more details.

Variable Expansion
^^^^^^^^^^^^^^^^^^

The if command was written very early in CMake's history, predating
the ``${}`` variable evaluation syntax, and for convenience evaluates
variables named by its arguments as shown in the above signatures.
Note that normal variable evaluation with ``${}`` applies before the if
command even receives the arguments.  Therefore code like

.. code-block:: cmake

 set(var1 OFF)
 set(var2 "var1")
 if(${var2})

appears to the if command as

.. code-block:: cmake

  if(var1)

and is evaluated according to the ``if(<variable>)`` case documented
above.  The result is ``OFF`` which is false.  However, if we remove the
``${}`` from the example then the command sees

.. code-block:: cmake

  if(var2)

which is true because ``var2`` is defined to ``var1`` which is not a false
constant.

Automatic evaluation applies in the other cases whenever the
above-documented condition syntax accepts ``<variable|string>``:

* The left hand argument to `MATCHES`_ is first checked to see if it is
  a defined variable.  If so, the variable's value is used, otherwise the
  original value is used.

* If the left hand argument to `MATCHES`_ is missing it returns false
  without error

* Both left and right hand arguments to `LESS`_, `GREATER`_, `EQUAL`_,
  `LESS_EQUAL`_, and `GREATER_EQUAL`_, are independently tested to see if
  they are defined variables.  If so, their defined values are used otherwise
  the original value is used.

* Both left and right hand arguments to `STRLESS`_, `STRGREATER`_,
  `STREQUAL`_, `STRLESS_EQUAL`_, and `STRGREATER_EQUAL`_ are independently
  tested to see if they are defined variables.  If so, their defined values are
  used otherwise the original value is used.

* Both left and right hand arguments to `VERSION_LESS`_,
  `VERSION_GREATER`_, `VERSION_EQUAL`_, `VERSION_LESS_EQUAL`_, and
  `VERSION_GREATER_EQUAL`_ are independently tested to see if they are defined
  variables.  If so, their defined values are used otherwise the original value
  is used.

* The left hand argument to `IN_LIST`_ is tested to see if it is a defined
  variable.  If so, the variable's value is used, otherwise the original
  value is used.

* The right hand argument to `NOT`_ is tested to see if it is a boolean
  constant.  If so, the value is used, otherwise it is assumed to be a
  variable and it is dereferenced.

* The left and right hand arguments to `AND`_ and `OR`_ are independently
  tested to see if they are boolean constants.  If so, they are used as
  such, otherwise they are assumed to be variables and are dereferenced.

.. versionchanged:: 3.1
  To prevent ambiguity, potential variable or keyword names can be
  specified in a :ref:`Quoted Argument` or a :ref:`Bracket Argument`.
  A quoted or bracketed variable or keyword will be interpreted as a
  string and not dereferenced or interpreted.
  See policy :policy:`CMP0054`.

There is no automatic evaluation for environment or cache
:ref:`Variable References`.  Their values must be referenced as
``$ENV{<name>}`` or ``$CACHE{<name>}`` wherever the above-documented
condition syntax accepts ``<variable|string>``.

See also
^^^^^^^^

* :command:`else`
* :command:`elseif`
* :command:`endif`
