CMAKE_UNITY_BUILD_RELOCATABLE
-----------------------------

.. versionadded:: 4.0

此变量用于在创建目标时初始化目标的\ :prop_tgt:`UNITY_BUILD_RELOCATABLE`\ 属性。将其设置\
为true会使为\ :variable:`CMAKE_UNITY_BUILD`\ 生成的源文件在可能的情况下使用相对路径\
``#include``\ 原始源文件。
