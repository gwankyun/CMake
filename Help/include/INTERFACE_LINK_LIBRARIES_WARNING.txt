
请注意，用依赖项的绝对路径填充目标的\ |INTERFACE_PROPERTY_LINK|\ 是不可取的。这将把安装包\
**所在机器上的**\ 依赖库文件路径硬编码到安装包中。

请参阅\ :manual:`cmake-packages(7)`\ 手册的\ :ref:`Creating Relocatable Packages`\
部分，以讨论在创建用于重新分发的包时指定使用要求时必须采取的额外注意事项。
