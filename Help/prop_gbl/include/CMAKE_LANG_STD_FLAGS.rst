.. note::

  如果编译器的默认标准级别至少是所请求特性的标准级别，CMake可能会省略\ ``-std=``\ 标志。\
  如果编译器的默认扩展模式与\ :prop_tgt:`<LANG>_EXTENSIONS`\ 目标属性不匹配，\
  或者如果设置了\ :prop_tgt:`<LANG>_EXTENSIONS`\ 目标属性，则仍然可以添加该标志。
