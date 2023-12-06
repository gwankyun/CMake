COST
----

此属性描述测试的成本。启用并行测试后，测试集中的测试将按成本降序运行。项目可以通过将此属性设\
置为浮点值来显式定义测试的成本。

When the cost of a test is not defined by the project,
:manual:`ctest <ctest(1)>` will initially use a default cost of ``0``.
It computes a weighted average of the cost each time a test is run and
uses that as an improved estimate of the cost for the next run.  The more
a test is re-run in the same build directory, the more representative the
cost should become.
