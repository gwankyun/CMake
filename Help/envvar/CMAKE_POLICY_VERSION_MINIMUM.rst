CMAKE_POLICY_VERSION_MINIMUM
----------------------------

.. versionadded:: 4.0

.. include:: ENV_VAR.txt

当首次创建新的构建树且未给出显式配置时，\ :variable:`CMAKE_POLICY_VERSION_MINIMUM`\
的默认值。在现有构建树的后续运行中，该值会作为\ :variable:`CMAKE_POLICY_VERSION_MINIMUM`\
持久保存在缓存中。
