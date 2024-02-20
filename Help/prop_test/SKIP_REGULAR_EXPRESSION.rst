SKIP_REGULAR_EXPRESSION
-----------------------

.. versionadded:: 3.16

如果测试输出（stderr或stdout）匹配此正则表达式，则测试将被标记为跳过，而不管进程退出代码是\
什么。无论\ ``SKIP_REGULAR_EXPRESSION``\ 如何设置，超过\ :prop_test:`TIMEOUT`\ 指定\
的超时的测试仍然会失败。即使正则表达式匹配，包括分段错误、信号中止或堆错误在内的系统级测试\
失败也可能导致测试失败。

Example:

.. code-block:: cmake

  add_test(NAME mytest COMMAND ${CMAKE_COMMAND} -E echo "Skipped this test")

  set_property(TEST mytest PROPERTY
    SKIP_REGULAR_EXPRESSION "[^a-z]Skip" "SKIP" "Skipped"
  )

``SKIP_REGULAR_EXPRESSION`` expects a list of regular expressions.

To run a test that may have a system-level failure, but still skip if
``SKIP_REGULAR_EXPRESSION`` matches, use a CMake command to wrap the
executable run. Note that this will prevent automatic handling of the
:prop_tgt:`CROSSCOMPILING_EMULATOR` and :prop_tgt:`TEST_LAUNCHER`
target property.

.. code-block:: cmake

    add_executable(main main.c)

    add_test(NAME sigabrt COMMAND ${CMAKE_COMMAND} -E env $<TARGET_FILE:main>)

    set_property(TEST sigabrt PROPERTY SKIP_REGULAR_EXPRESSION "SIGABRT;[aA]bort")

.. code-block:: c

    #include <signal.h>

    int main(void){ raise(SIGABRT); return 0; }

See also the :prop_test:`SKIP_RETURN_CODE`,
:prop_test:`PASS_REGULAR_EXPRESSION`, and :prop_test:`FAIL_REGULAR_EXPRESSION`
test properties.
