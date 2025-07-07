去重选项
^^^^^^^^^^^^^^^^^^^^^

目标使用的最终选项集是通过从当前目标及其依赖项的使用需求中累积选项来构建的。该选项集被去重以\
避免重复。

.. versionadded:: 3.12
  虽然对单个选项有益，但去重步骤可以分解选项组。例如，\ ``-option A -option B``\ 变成了\
  ``-option A B``。可以使用类似shell的引号加上\ ``SHELL:``\ 前缀来指定一组选项。\
  ``SHELL:``\ 前缀会被删除，其余的选项字符串使用\ ``UNIX_COMMAND``\ 模式的\
  :command:`separate_arguments`\ 进行解析。例如，\ ``"SHELL:-option A" "SHELL:-option B"``\
  变为\ ``-option A -option B``。
