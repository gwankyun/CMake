math
----

计算数学表达式的值。

.. code-block:: cmake

  math(EXPR <variable> "<expression>" [OUTPUT_FORMAT <format>])

计算数学表达式\ ``<expression>``\ 的值，并将结果赋值给变量\ ``<variable>``。表达式的结果\
必须可以用64位有符号整数表示。浮点输入是无效的，例如 ``1.1 * 10``。非整数结果如\ ``3 / 2``\
会被截断。

数学表达式必须以字符串形式给出（即使用双引号括起来）。例如\ ``"5 * (10 + 13)"``。 支持的\
运算符有\ ``+``、\ ``-``、\ ``*``、\ ``/``、\ ``%``、\ ``|``、\ ``&``、\ ``^``、\
``~``、\ ``<<``、\ ``>>``\ 和\ ``(...)``；它们的含义与C代码中的相同。

.. versionadded:: 3.13
  和C代码一样，当数字以\ ``0x``\ 为前缀时，会被识别为十六进制数。

.. versionadded:: 3.13
  结果会根据\ ``OUTPUT_FORMAT``\ 选项进行格式化，其中\ ``<format>``\ 可以是以下值之一

  ``HEXADECIMAL``
    与C代码中的十六进制表示法相同，即以“0x”开头。
  ``DECIMAL``
    十进制表示法。如果未指定\ ``OUTPUT_FORMAT``\ 选项，也会使用这种表示法。

例如

.. code-block:: cmake

  math(EXPR value "100 * 0xA" OUTPUT_FORMAT DECIMAL)      # value is set to "1000"
  math(EXPR value "100 * 0xA" OUTPUT_FORMAT HEXADECIMAL)  # value is set to "0x3e8"
