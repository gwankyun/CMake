DEPLOYMENT_ADDITIONAL_FILES
---------------------------

.. versionadded:: 3.13

��\ ``DeploymentTool``\ �е�WinCE��Ŀ\ ``AdditionalFiles``\ ����Ϊ\
:ref:`Visual Studio Generators`\ ���������ɵ�\ ``.vcproj``\ �ļ���������Ҫ��Զ��\
WinCE�豸�ϵ���ʱ��������á�ָ�������Ƶ��豸�������ļ������磺

.. code-block:: cmake

  set_property(TARGET ${TARGET} PROPERTY
    DEPLOYMENT_ADDITIONAL_FILES "english.lng|local_folder|remote_folder|0"
    "german.lng|local_folder|remote_folder|0")

produces::

  <DeploymentTool AdditionalFiles="english.lng|local_folder|remote_folder|0;german.lng|local_folder|remote_folder|0" ... />
