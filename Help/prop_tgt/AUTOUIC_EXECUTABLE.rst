AUTOUIC_EXECUTABLE
------------------

.. versionadded:: 3.14

``AUTOUIC_EXECUTABLE``\ 是指向启用了\ :prop_tgt:`AUTOUIC`\ 的文件的\ ``uic``\ 可执\
行文件路径。设置此属性将使CMake跳过\ ``uic``\ 二进制文件的自动检测以及通常运行的安全性测试，\
以确保二进制文件可用并按预期工作。

Usually this property does not need to be set. Only consider this
property if auto-detection of ``uic`` can not work -- e.g. because
you are building the ``uic`` binary as part of your project.

See the :manual:`cmake-qt(7)` manual for more information on using CMake
with Qt.
