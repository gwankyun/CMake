enable_language
---------------
启用语言（CXX/C/OBJC/OBJCXX/Fortran/等）

.. code-block:: cmake

  enable_language(<lang>... [OPTIONAL])

在CMake中启用对指定语言的支持。这与\ :command:`project`\ 命令的功能相同，但不会创建由\
:command:`project`\ 命令所创建的任何额外变量。

.. include:: include/SUPPORTED_LANGUAGES.rst

以下是对\ ``enable_language()``\ 调用位置的限制：

* 在首次调用 :command:`project` 之前，不得调用它。参见策略 :policy:`CMP0165`。
* 必须在任何直接使用编译语言编译源文件、或间接通过链接依赖使用该语言的目标之前调用该命令。

.. note::
  如果策略 :policy:`CMP0220` 未设置为 ``NEW``，则存在进一步的限制。详见策略文档。

``OPTIONAL``\ 关键字是为未来实现预留的占位符，目前不起作用。相反，你可以使用\
:module:`CheckLanguage`\ 模块在启用语言之前验证其是否受支持。
