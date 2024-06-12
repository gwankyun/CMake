DEPLOYMENT_REMOTE_DIRECTORY
---------------------------

.. versionadded:: 3.6

在\ :ref:`Visual Studio Generators`\ 生成器生成的\ ``.vcproj``\ 文件中设置WinCE项\
目的\ ``DeploymentTool``\ 中的\ ``RemoteDirectory``\ 和\ ``DebuggerTool``\ 中的\
``RemoteExecutable``。当你想要在远程WinCE设备上调试时，这很有用。例如：

.. code-block:: cmake

  set_property(TARGET ${TARGET} PROPERTY
    DEPLOYMENT_REMOTE_DIRECTORY "\\FlashStorage")

produces::

  <DeploymentTool RemoteDirectory="\FlashStorage" ... />
  <DebuggerTool RemoteExecutable="\FlashStorage\target_file" ... />
