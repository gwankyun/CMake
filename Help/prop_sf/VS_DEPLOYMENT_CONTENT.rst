VS_DEPLOYMENT_CONTENT
---------------------

.. versionadded:: 3.1

将源文件标记为内容，以便在使用\ :manual:`Visual Studio生成器 <cmake-generators(7)>`\
构建时使用Windows Phone或Windows Store应用程序进行部署。该值必须计算为\ ``1``\ 或\
``0``，并且可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 根据生\
成配置进行选择。源文件的\ ``.vcxproj``\ 文件条目将分别为值\ ``1``\ 和\ ``0``\ 标记为\
``DeploymentContent``\ 或\ ``ExcludedFromBuild``。
