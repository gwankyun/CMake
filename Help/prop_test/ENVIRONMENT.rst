ENVIRONMENT
-----------

指定应该为运行测试而定义的环境变量。

Set to a :ref:`semicolon-separated list <CMake Language Lists>` list
of environment variables and values of the form ``MYVAR=value``.
Those environment variables will be defined while running the test.
The environment changes from this property do not affect other tests.
