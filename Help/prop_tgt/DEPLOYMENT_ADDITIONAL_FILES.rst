DEPLOYMENT_ADDITIONAL_FILES
---------------------------

.. versionadded:: 3.13

将\ ``DeploymentTool``\ 中的WinCE项目\ ``AdditionalFiles``\ 设置为\
:ref:`Visual Studio Generators`\ 生成器生成的\ ``.vcproj``\ 文件。当你想要在远程\
WinCE设备上调试时，这很有用。指定将复制到设备的其他文件。例如：

.. code-block:: cmake

  set_property(TARGET ${TARGET} PROPERTY
    DEPLOYMENT_ADDITIONAL_FILES "english.lng|local_folder|remote_folder|0"
    "german.lng|local_folder|remote_folder|0")

produces::

  <DeploymentTool AdditionalFiles="english.lng|local_folder|remote_folder|0;german.lng|local_folder|remote_folder|0" ... />
