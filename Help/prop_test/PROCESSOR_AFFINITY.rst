PROCESSOR_AFFINITY
------------------

.. versionadded:: 3.12

设置为true值，以要求CTest为一组固定的处理器启动具有CPU亲和力的测试进程。如果当前平台启用并\
支持CTest，则在启动测试进程时，CTest将选择一组处理器放置在CPU亲和掩码中。集合中的处理器数\
量由\ :prop_test:`PROCESSORS`\ 测试属性或CTest可用的处理器数量决定，以较小者为准。所选\
择的处理器集将与分配给其他并发运行的测试的处理器分离，这些测试也启用了\
``PROCESSOR_AFFINITY``\ 属性。
