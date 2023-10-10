AUTORCC_EXECUTABLE
------------------

.. versionadded:: 3.14

``AUTORCC_EXECUTABLE``\ 是指向\ ``rcc``\ 可执行文件的文件路径，用于启用\
:prop_tgt:`AUTORCC`\ 的文件。设置此属性将使\
CMake跳过\ ``rcc``\ 二进制文件的自动检测以及通常运行的安全性测试，以确保二进制文件可用并按\
预期工作。

Usually this property does not need to be set. Only consider this
property if auto-detection of ``rcc`` can not work -- e.g. because
you are building the ``rcc`` binary as part of your project.

See the :manual:`cmake-qt(7)` manual for more information on using CMake
with Qt.
