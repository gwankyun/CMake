对于常见的用例，默认的搜索顺序被设计为最特定到最不特定。项目可以通过多次调用命令并使用\
``NO_*``\ 选项来覆盖排序：

.. parsed-literal::

   |FIND_XXX| (|FIND_ARGS_XXX| PATHS paths... NO_DEFAULT_PATH)
   |FIND_XXX| (|FIND_ARGS_XXX|)

一旦其中一个调用成功，结果变量将被设置并存储在缓存中，这样调用就不会再次搜索。
