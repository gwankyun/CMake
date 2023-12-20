CMAKE_RULE_MESSAGES
-------------------

.. versionadded:: 3.13

指定是否为每个make规则报告一条消息。

If set in the cache it is used to initialize the value of the :prop_gbl:`RULE_MESSAGES` property.
Users may disable the option in their local build tree to disable granular messages
and report only as each target completes in Makefile builds.
