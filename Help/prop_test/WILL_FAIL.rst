WILL_FAIL
---------

如果为\ ``true``，则反转通过/失败测试标准。\ ``WILL_FAIL``\ 为\ ``true``\ 的测试失败，\
返回代码为0，通过，返回代码为非0。无论\ ``WILL_FAIL``\ 是否存在，超过\ :prop_test:`TIMEOUT`\
指定的超时的测试仍然会失败。即使\ ``WILL_FAIL``\ 为真，包括分段错误、信号中止或堆错误在内\
的系统级测试失败也可能导致测试失败。

Example of a test that would ordinarily pass, but fails because ``WILL_FAIL``
is ``true``:

.. code-block:: cmake

    add_test(NAME failed COMMAND ${CMAKE_COMMAND} -E true)
    set_property(TEST failed PROPERTY WILL_FAIL true)

To run a test that may have a system-level failure, but still pass if
``WILL_FAIL`` is set, use a CMake command to wrap the executable run.
Note that this will prevent automatic handling of the
:prop_tgt:`CROSSCOMPILING_EMULATOR` and :prop_tgt:`TEST_LAUNCHER`
target property.

.. code-block:: cmake

    add_executable(main main.c)

    add_test(NAME sigabrt COMMAND ${CMAKE_COMMAND} -E env $<TARGET_FILE:main>)

    set_property(TEST sigabrt PROPERTY WILL_FAIL TRUE)

.. code-block:: c

    #include <signal.h>

    int main(void){ raise(SIGABRT); return 0; }
