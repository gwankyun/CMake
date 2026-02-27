enable_language
---------------
启用语言（CXX/C/OBJC/OBJCXX/Fortran/等）

.. code-block:: cmake

  enable_language(<lang>... [OPTIONAL])

在CMake中启用对指定语言的支持。这与\ :command:`project`\ 命令的功能相同，但不会创建由\
:command:`project`\ 命令所创建的任何额外变量。

.. include:: include/SUPPORTED_LANGUAGES.rst

以下是对\ ``enable_language()``\ 调用位置的限制：

* It must be called in file scope, not in a :command:`function` call
  nor inside a :command:`block()`.。
* 在首次调用\ :command:`project`\ 命令之前，不得调用此命令。\
  请参阅策略\ :policy:`CMP0165`。
* 它必须在所有直接使用指定语言编译源文件或通过链接依赖间接使用该语言的目标的公共最高级目录中\
  调用。最简单的做法是在项目的顶层目录中启用所有需要的语言。

``OPTIONAL``\ 关键字是为未来实现预留的占位符，目前不起作用。相反，你可以使用\
:module:`CheckLanguage`\ 模块在启用语言之前验证其是否受支持。
