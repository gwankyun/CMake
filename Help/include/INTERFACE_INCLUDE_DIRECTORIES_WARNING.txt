
请注意，用依赖项的include目录的绝对路径填充目标的\ |INTERFACE_PROPERTY_LINK|\ 的\
:genex:`INSTALL_INTERFACE`\ 是不明智的。这将\ **在安装包的机器上找到**\ 依赖项的包含\
目录路径，并将其硬编码到已安装包中。

|INTERFACE_PROPERTY_LINK|\ 的\ :genex:`INSTALL_INTERFACE`\ 只适用于为目标本身提供\
的头文件指定所需的include目录，而不适用于在其\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
目标属性中列出的传递依赖项提供的目录。这些依赖项本身应该是目标，在\
|INTERFACE_PROPERTY_LINK|\ 中指定它们自己的头文件位置。

请参阅\ :manual:`cmake-packages(7)`\ 手册的\ :ref:`Creating Relocatable Packages`\
章节，以讨论在创建用于重新分发的包时指定使用要求时必须采取的额外注意事项。
