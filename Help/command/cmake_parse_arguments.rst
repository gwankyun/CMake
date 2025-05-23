cmake_parse_arguments
---------------------

解析函数或者宏的参数。

.. code-block:: cmake

  cmake_parse_arguments(<prefix> <options> <one_value_keywords>
                        <multi_value_keywords> <args>...)

  cmake_parse_arguments(PARSE_ARGV <N> <prefix> <options>
                        <one_value_keywords> <multi_value_keywords>)

.. versionadded:: 3.5
  此命令为原生实现。\
  此前，它是在\ :module:`CMakeParseArguments`\ 模块中定义的。

此命令用于宏或函数中。\
它会处理传递给该宏或函数的参数，并定义一组变量，这些变量将存储相应选项的值。

第一个函数签名读取传递给\ ``<args>...``\ 的参数。\
这既可以在\ :command:`macro`\ 中使用，也可以在\ :command:`function`\ 中使用。

.. versionadded:: 3.7
  ``PARSE_ARGV``\ 签名仅适用于\ :command:`function`\ 主体中。\
  在这种情况下，被解析的参数来自调用函数的\ ``ARGV#``\ 变量。\
  解析从第\ ``<N>``\ 个参数开始，其中\ ``<N>``\ 是一个无符号整数。\
  这使得参数值中可以包含像\ ``;``\ 这样的特殊字符。

``<options>``\ 参数包含了相应函数或宏的所有选项。\
这些关键字后面不跟随值，例如\ :command:`install`\ 命令中的\ ``OPTIONAL``\ 关键字。

``<one_value_keywords>``\ 参数包含了该函数或宏的所有需要跟随一个值的关键字，例如\
:command:`install`\ 命令中的\ ``DESTINATION``\ 关键字。

The ``<multi_value_keywords>`` argument contains all keywords for this
function or macro which can be followed by more than one value, like the
``TARGETS`` or ``FILES`` keywords of the :command:`install` command.

.. versionchanged:: 3.5
  All keywords must be unique.  Each keyword can only be specified
  once in any of the ``<options>``, ``<one_value_keywords>``, or
  ``<multi_value_keywords>``. A warning will be emitted if uniqueness is
  violated.

When done, ``cmake_parse_arguments`` will consider for each of the
keywords listed in ``<options>``, ``<one_value_keywords>``, and
``<multi_value_keywords>``, a variable composed of the given ``<prefix>``
followed by ``"_"`` and the name of the respective keyword.  For
``<one_value_keywords>`` and ``<multi_value_keywords>``, these variables
will then hold the respective value(s) from the argument list, or be undefined
if the associated keyword was not given (policy :policy:`CMP0174` can also
affect the behavior for ``<one_value_keywords>``).  For the ``<options>``
keywords, these variables will always be defined, and they will be set to
``TRUE`` if the keyword is present, or ``FALSE`` if it is not.

All remaining arguments are collected in a variable
``<prefix>_UNPARSED_ARGUMENTS`` that will be undefined if all arguments
were recognized. This can be checked afterwards to see
whether your macro or function was called with unrecognized parameters.

.. versionadded:: 3.15
   ``<one_value_keywords>`` and ``<multi_value_keywords>`` that were given no
   values at all are collected in a variable
   ``<prefix>_KEYWORDS_MISSING_VALUES`` that will be undefined if all keywords
   received values. This can be checked to see if there were keywords without
   any values given.

.. versionchanged:: 3.31
   If a ``<one_value_keyword>`` is followed by an empty string as its value,
   policy :policy:`CMP0174` controls whether a corresponding
   ``<prefix>_<keyword>`` variable is defined or not.

Choose a ``<prefix>`` carefully to avoid clashing with existing variable names.
When used inside a function, it is usually suitable to use the prefix ``arg``.
There is a very strong convention that all keywords are fully uppercase, so
this prefix results in variables of the form ``arg_SOME_KEYWORD``.  This makes
the code more readable, and it minimizes the chance of clashing with cache
variables, which also have a strong convention of being all uppercase.

.. code-block:: cmake

   function(my_install)
       set(options OPTIONAL FAST)
       set(oneValueArgs DESTINATION RENAME)
       set(multiValueArgs TARGETS CONFIGURATIONS)
       cmake_parse_arguments(PARSE_ARGV 0 arg
           "${options}" "${oneValueArgs}" "${multiValueArgs}"
       )

       # The above will set or unset variables with the following names:
       #   arg_OPTIONAL
       #   arg_FAST
       #   arg_DESTINATION
       #   arg_RENAME
       #   arg_TARGETS
       #   arg_CONFIGURATIONS
       #
       # The following will also be set or unset:
       #   arg_UNPARSED_ARGUMENTS
       #   arg_KEYWORDS_MISSING_VALUES

When used inside a macro, ``arg`` might not be a suitable prefix because the
code will affect the calling scope.  If another macro also called in the same
scope were to use ``arg`` in its own call to ``cmake_parse_arguments()``,
and if there are any common keywords between the two macros, the later call's
variables can overwrite or remove those of the earlier macro's call.
Therefore, it is advisable to incorporate something unique from the macro name
in the ``<prefix>``, such as ``arg_lowercase_macro_name``.

.. code-block:: cmake

   macro(my_install)
       set(options OPTIONAL FAST)
       set(oneValueArgs DESTINATION RENAME)
       set(multiValueArgs TARGETS CONFIGURATIONS)
       cmake_parse_arguments(arg_my_install
           "${options}" "${oneValueArgs}" "${multiValueArgs}"
           ${ARGN}
       )
       # ...
   endmacro()

   macro(my_special_install)
       # NOTE: Has the same keywords as my_install()
       set(options OPTIONAL FAST)
       set(oneValueArgs DESTINATION RENAME)
       set(multiValueArgs TARGETS CONFIGURATIONS)
       cmake_parse_arguments(arg_my_special_install
           "${options}" "${oneValueArgs}" "${multiValueArgs}"
           ${ARGN}
       )
       # ...
   endmacro()

Suppose the above macros are called one after the other, like so:

.. code-block:: cmake

   my_install(TARGETS foo bar DESTINATION bin OPTIONAL blub CONFIGURATIONS)
   my_special_install(TARGETS barry DESTINATION sbin RENAME FAST)

After these two calls, the following describes the variables that will be
set or unset::

   arg_my_install_OPTIONAL = TRUE
   arg_my_install_FAST = FALSE # was not present in call to my_install
   arg_my_install_DESTINATION = "bin"
   arg_my_install_RENAME <UNSET> # was not present
   arg_my_install_TARGETS = "foo;bar"
   arg_my_install_CONFIGURATIONS <UNSET> # was not present
   arg_my_install_UNPARSED_ARGUMENTS = "blub" # nothing expected after "OPTIONAL"
   arg_my_install_KEYWORDS_MISSING_VALUES = "CONFIGURATIONS" # value was missing

   arg_my_special_install_OPTIONAL = FALSE # was not present
   arg_my_special_install_FAST = TRUE
   arg_my_special_install_DESTINATION = "sbin"
   arg_my_special_install_RENAME <UNSET> # value was missing
   arg_my_special_install_TARGETS = "barry"
   arg_my_special_install_CONFIGURATIONS <UNSET> # was not present
   arg_my_special_install_UNPARSED_ARGUMENTS <UNSET>
   arg_my_special_install_KEYWORDS_MISSING_VALUES = "RENAME"

Keywords terminate lists of values. If a keyword is given directly after a
``<one_value_keyword>``, that preceding ``<one_value_keyword>`` receives no
value and the keyword is added to the ``<prefix>_KEYWORDS_MISSING_VALUES``
variable. In the above example, the call to ``my_special_install()`` contains
the ``RENAME`` keyword immediately followed by the ``FAST`` keyword.
In this case, ``FAST`` terminates processing of the ``RENAME`` keyword.
``arg_my_special_install_FAST`` is set to ``TRUE``,
``arg_my_special_install_RENAME`` is unset, and
``arg_my_special_install_KEYWORDS_MISSING_VALUES`` contains the value
``RENAME``.

See Also
^^^^^^^^

* :command:`function`
* :command:`macro`
