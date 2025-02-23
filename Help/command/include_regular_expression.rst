include_regular_expression
--------------------------

设置依赖项检查的正则表达式。

.. code-block:: cmake

  include_regular_expression(regex_match [regex_complain])

设置依赖检查中使用的正则表达式。只有匹配\ ``regex_match``\ 的文件才会被作为依赖项跟踪。\
只有匹配\ ``regex_complain``\ 的文件在找不到时才会生成警告（不搜索标准头路径）。

The default for ``regex_match`` is ``"^.*$"`` (match everything).
The default for ``regex_complain`` is ``"^$"`` (match empty string only).
