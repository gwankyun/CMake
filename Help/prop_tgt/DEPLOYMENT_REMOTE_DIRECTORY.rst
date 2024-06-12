DEPLOYMENT_REMOTE_DIRECTORY
---------------------------

.. versionadded:: 3.6

��\ :ref:`Visual Studio Generators`\ ���������ɵ�\ ``.vcproj``\ �ļ�������WinCE��\
Ŀ��\ ``DeploymentTool``\ �е�\ ``RemoteDirectory``\ ��\ ``DebuggerTool``\ �е�\
``RemoteExecutable``��������Ҫ��Զ��WinCE�豸�ϵ���ʱ��������á����磺

.. code-block:: cmake

  set_property(TARGET ${TARGET} PROPERTY
    DEPLOYMENT_REMOTE_DIRECTORY "\\FlashStorage")

produces::

  <DeploymentTool RemoteDirectory="\FlashStorage" ... />
  <DebuggerTool RemoteExecutable="\FlashStorage\target_file" ... />
