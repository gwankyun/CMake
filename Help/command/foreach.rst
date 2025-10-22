foreach
-------

为列表中的每个值执行一组命令。

.. code-block:: cmake

  foreach(<loop_var> <items>)
    <commands>
  endforeach()

其中\ ``<items>``\ 是一个由分号或空格分隔的元素列表。\
从\ ``foreach``\ 到与之匹配的\ ``endforeach``\ 之间的所有命令都会被记录下来，但不会立即执行。\
一旦\ ``endforeach``\ 被求值，记录下来的命令列表就会针对\ ``<items>``\ 中的每个元素执行一次。\
在每次迭代开始时，变量\ ``<loop_var>``\ 将被设置为当前元素的值。

变量\ ``<loop_var>``\ 的作用域仅限于循环范围。详情请参阅策略\ :policy:`CMP0124`。

:command:`break`\ 和\ :command:`continue`\ 命令提供了跳出正常控制流的方法。

按照传统，:command:`endforeach`\ 命令允许使用一个可选的\ ``<loop_var>``\ 参数。\
如果使用该参数，它必须与开头\ ``foreach``\ 命令的参数完全一致。

.. code-block:: cmake

  foreach(<loop_var> RANGE <stop>)

在这种变体中，\ ``foreach``\ 会对从0、1开始，一直到（包含）非负整数\ ``<stop>``\ 的数字进行迭代。

.. code-block:: cmake

  foreach(<loop_var> RANGE <start> <stop> [<step>])

在这种变体中，\ ``foreach``\ 会以\ ``<step>``\ 为步长，对从\ ``<start>``\ 开始，至多到\
``<stop>``\ 的数字进行迭代。\
如果未指定\ ``<step>``，则步长为1。\
三个参数\ ``<start>``、\ ``<stop>``\ 和\ ``<step>``\ 都必须是非负整数，并且\ ``<stop>``\
不能小于\ ``<start>``；否则，你将面临未文档化行为的风险，这些行为可能会在未来版本中发生变化。

.. code-block:: cmake

  foreach(<loop_var> IN [LISTS [<lists>]] [ITEMS [<items>]])

In this variant, ``<lists>`` is a whitespace or semicolon
separated list of list-valued variables. The ``foreach``
command iterates over each item in each given list.
The ``<items>`` following the ``ITEMS`` keyword are processed
as in the first variant of the ``foreach`` command.
The forms ``LISTS A`` and ``ITEMS ${A}`` are
equivalent. If no ``<lists>`` or ``<items>`` are given, the body
of the loop will never be executed (i.e., it is processed as empty).

以下示例展示了如何处理\ ``LISTS``\ 选项：

.. code-block:: cmake

  set(A 0;1)
  set(B 2 3)
  set(C "4 5")
  set(D 6;7 8)
  set(E "")
  foreach(X IN LISTS A B C D E)
      message(STATUS "X=${X}")
  endforeach()

yields::

  -- X=0
  -- X=1
  -- X=2
  -- X=3
  -- X=4 5
  -- X=6
  -- X=7
  -- X=8


.. code-block:: cmake

  foreach(<loop_var>... IN ZIP_LISTS <lists>)

.. versionadded:: 3.17

在这种变体中，\ ``<lists>``\ 是一个由空格或分号分隔的列表变量列表。\ ``foreach``\ 命令会\
同时遍历每个列表，并按如下方式设置迭代变量：

- if a single ``loop_var`` is given, then it sets a series of
  ``loop_var_N`` variables to the current item from the
  corresponding list;
- if multiple variable names are passed, it sets each variable to the
  current item from the corresponding list. The number of iteration
  variables must match the number of list variables.

If no ``<lists>`` are given, the body of the loop will never be executed
(i.e., it is processed as empty).

The following example shows how the ``ZIP_LISTS`` option is
processed:

.. noqa: spellcheck off

.. code-block:: cmake

  list(APPEND English one two three four)
  list(APPEND Bahasa satu dua tiga)

  foreach(num IN ZIP_LISTS English Bahasa)
      message(STATUS "num_0=${num_0}, num_1=${num_1}")
  endforeach()

  foreach(en ba IN ZIP_LISTS English Bahasa)
      message(STATUS "en=${en}, ba=${ba}")
  endforeach()

产生：\ ::

  -- num_0=one, num_1=satu
  -- num_0=two, num_1=dua
  -- num_0=three, num_1=tiga
  -- num_0=four, num_1=
  -- en=one, ba=satu
  -- en=two, ba=dua
  -- en=three, ba=tiga
  -- en=four, ba=

.. noqa: spellcheck on

另读参阅
^^^^^^^^

* :command:`break`
* :command:`continue`
* :command:`endforeach`
* :command:`while`
