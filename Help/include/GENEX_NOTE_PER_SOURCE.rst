
|genex_subject| 的内容可以使用语法为 ``$<...>`` 的
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。
但 :generator:`Xcode` 生成器不支持逐配置、逐源文件的设置，
因此在该生成器下不允许使用依赖于构建配置的表达式。
