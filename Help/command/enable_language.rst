enable_language
---------------
启用语言（CXX/C/OBJC/OBJCXX/Fortran/等）

.. code-block:: cmake

  enable_language(<lang>... [OPTIONAL])

在CMake中启用对指定语言的支持。这与\ :command:`project`\ 命令的功能相同，但不会创建由\
:command:`project`\ 命令所创建的任何额外变量。

.. include:: include/SUPPORTED_LANGUAGES.rst

以下是对\ ``enable_language()``\ 调用位置的限制：

* It must not be called before the first call to :command:`project`.
  See policy :policy:`CMP0165`.
* It must be called such that the command executes before any targets that
  use the language directly for compiling sources or indirectly through link
  dependencies.

.. note::
  Further restrictions apply if policy :policy:`CMP0220` is not set
  to ``NEW``.  See the policy documentation for details.

``OPTIONAL``\ 关键字是为未来实现预留的占位符，目前不起作用。相反，你可以使用\
:module:`CheckLanguage`\ 模块在启用语言之前验证其是否受支持。
