cmake_parse_arguments
---------------------

解析函数或者宏的参数。

.. code-block:: cmake

  cmake_parse_arguments(<prefix> <options> <one_value_keywords>
                        <multi_value_keywords> <args>...)

  cmake_parse_arguments(PARSE_ARGV <N> <prefix> <options>
                        <one_value_keywords> <multi_value_keywords>)

  cmake_parse_arguments(PARSE_ARGN <prefix> <options>
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

.. versionadded:: 4.4
  ``PARSE_ARGN`` 签名仅用于 :command:`function` 函数体中。它从调用函数的最后一个\
  命名参数之后开始解析，其工作方式与 ``PARSE_ARGV`` 完全相同，其中 ``<N>`` 为函数定义\
  中的参数数量。

``<options>``\ 参数包含了相应函数或宏的所有选项。\
这些关键字后面不跟随值，例如\ :command:`install`\ 命令中的\ ``OPTIONAL``\ 关键字。

``<one_value_keywords>``\ 参数包含了该函数或宏的所有需要跟随一个值的关键字，例如\
:command:`install`\ 命令中的\ ``DESTINATION``\ 关键字。

``<multi_value_keywords>``\ 参数包含了该函数或宏的所有可跟随多个值的关键字，例如\
:command:`install`\ 命令中的\ ``TARGETS``\ 或\ ``FILES``\ 关键字。

.. versionchanged:: 3.5
  所有关键字必须唯一。\
  每个关键字只能在\ ``<options>``、\ ``<one_value_keywords>``\
  或\ ``<multi_value_keywords>``\ 中指定一次。\
  若违反唯一性原则，将会发出警告。

执行完毕后，\ ``cmake_parse_arguments``\ 会针对\ ``<options>``、\
``<one_value_keywords>``\ 和\ ``<multi_value_keywords>``\ 中列出的每个关键字，\
生成一个变量。该变量由给定的\ ``<prefix>``\ 加上\ ``"_"``\ 以及相应关键字的名称组成。\
对于\ ``<one_value_keywords>``\ 和\ ``<multi_value_keywords>``，这些变量将存储\
参数列表中对应的一个或多个值；如果相关关键字未被提供，则这些变量将未定义（策略\
:policy:`CMP0174`\ 也可能影响\ ``<one_value_keywords>``\ 的行为）。\
对于\ ``<options>``\ 中的关键字，这些变量将始终被定义。若关键字存在，则变量将被\
设置为\ ``TRUE``；若不存在，则设置为\ ``FALSE``。

所有未被识别的参数将被收集到变量\ ``<prefix>_UNPARSED_ARGUMENTS``\ 中。若所有\
参数都被识别，该变量将未被定义。\
之后可以检查这个变量，以确定调用宏或函数时是否传入了未被识别的参数。

.. versionadded:: 3.15
   那些完全没有被赋予值的\ ``<one_value_keywords>``\ 和\ ``<multi_value_keywords>``\
   会被收集到变量\ ``<prefix>_KEYWORDS_MISSING_VALUES``\ 中。如果所有关键字都有值，\
   那么该变量将未被定义。\
   可以检查这个变量，以确定是否存在未被赋予任何值的关键字。

.. versionchanged:: 3.31
   如果\ ``<one_value_keyword>``\ 后面跟着一个空字符串作为其值，策略\ :policy:`CMP0174`\
   将控制相应的\ ``<prefix>_<keyword>``\ 变量是否被定义。

请谨慎选择\ ``<prefix>``，以避免与现有变量名冲突。\
当在函数内部使用时，通常适合使用前缀\ ``arg``。\
有一个非常普遍的约定，即所有关键字都采用全大写形式，因此使用这个前缀会生成形如\
``arg_SOME_KEYWORD``\ 的变量。\
这使得代码更具可读性，并且能最大程度降低与缓存变量发生命名冲突的可能性，因为缓存\
变量也普遍遵循全大写的命名约定。

.. code-block:: cmake

   function(my_install)
       set(options OPTIONAL FAST)
       set(oneValueArgs DESTINATION RENAME)
       set(multiValueArgs TARGETS CONFIGURATIONS)
       cmake_parse_arguments(PARSE_ARGV 0 arg
           "${options}" "${oneValueArgs}" "${multiValueArgs}"
       )

       # 上述操作将设置或取消设置以下名称的变量：
       #   arg_OPTIONAL
       #   arg_FAST
       #   arg_DESTINATION
       #   arg_RENAME
       #   arg_TARGETS
       #   arg_CONFIGURATIONS
       #
       # 以下变量也将被设置或取消设置：
       #   arg_UNPARSED_ARGUMENTS
       #   arg_KEYWORDS_MISSING_VALUES

在宏内部使用时，\ ``arg``\ 可能不是一个合适的前缀，因为代码会影响调用作用域。\
如果在同一作用域内调用的另一个宏，在其自身对\ ``cmake_parse_arguments()``\
的调用中也使用\ ``arg``\ 作为前缀，并且这两个宏之间存在任何相同的关键字，那么后\
调用的宏所设置的变量可能会覆盖或移除先调用的宏所设置的变量。\
因此，建议在\ ``<prefix>``\ 中加入宏名称里的独特元素，例如\ ``arg_lowercase_macro_name``。

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
       # 注意：与my_install()宏具有相同的关键字
       set(options OPTIONAL FAST)
       set(oneValueArgs DESTINATION RENAME)
       set(multiValueArgs TARGETS CONFIGURATIONS)
       cmake_parse_arguments(arg_my_special_install
           "${options}" "${oneValueArgs}" "${multiValueArgs}"
           ${ARGN}
       )
       # ...
   endmacro()

假设上述宏按如下方式依次调用：

.. code-block:: cmake

   my_install(TARGETS foo bar DESTINATION bin OPTIONAL blub CONFIGURATIONS)
   my_special_install(TARGETS barry DESTINATION sbin RENAME FAST)

在这两次调用之后，以下内容描述了将会被设置或未被设置的变量::

   arg_my_install_OPTIONAL = TRUE
   arg_my_install_FAST = FALSE # 在调用my_install时未出现
   arg_my_install_DESTINATION = "bin"
   arg_my_install_RENAME <UNSET> # 未出现
   arg_my_install_TARGETS = "foo;bar"
   arg_my_install_CONFIGURATIONS <UNSET> # 未出现
   arg_my_install_UNPARSED_ARGUMENTS = "blub" # "OPTIONAL"之后不应有其他内容
   arg_my_install_KEYWORDS_MISSING_VALUES = "CONFIGURATIONS" # 缺少值

   arg_my_special_install_OPTIONAL = FALSE # 未出现
   arg_my_special_install_FAST = TRUE
   arg_my_special_install_DESTINATION = "sbin"
   arg_my_special_install_RENAME <UNSET> # 缺少值
   arg_my_special_install_TARGETS = "barry"
   arg_my_special_install_CONFIGURATIONS <UNSET> # 未出现
   arg_my_special_install_UNPARSED_ARGUMENTS <UNSET>
   arg_my_special_install_KEYWORDS_MISSING_VALUES = "RENAME"

关键字会终止值列表。如果在一个\ ``<one_value_keyword>``\ 之后紧接着出现另一个\
关键字，那么前一个\ ``<one_value_keyword>``\  将不会接收到值，并且该关键字会被\
添加到\ ``<prefix>_KEYWORDS_MISSING_VALUES``\ 变量中。在上述示例中，对\
``my_special_install()``\ 的调用包含了\ ``RENAME``\ 关键字，其后紧接着是\ ``FAST``\
关键字。\
在这种情况下，\ ``FAST``\ 终止了对\ ``RENAME``\ 关键字的处理。\
``arg_my_special_install_FAST``\ 被设置为\ ``TRUE``，\ ``arg_my_special_install_RENAME``\
未被设置，并且\ ``arg_my_special_install_KEYWORDS_MISSING_VALUES``\ 包含值
``RENAME``。

另请参阅
^^^^^^^^

* :command:`function`
* :command:`macro`
