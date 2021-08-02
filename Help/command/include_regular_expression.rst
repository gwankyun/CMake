include_regular_expression
--------------------------

设置依赖项检查的正则表达式。

.. code-block:: cmake

  include_regular_expression(regex_match [regex_complain])

Sets the regular expressions used in dependency checking.  Only files
matching ``regex_match`` will be traced as dependencies.  Only files
matching ``regex_complain`` will generate warnings if they cannot be found
(standard header paths are not searched).  The defaults are:

::

  regex_match    = "^.*$" (match everything)
  regex_complain = "^$" (match empty string only)
