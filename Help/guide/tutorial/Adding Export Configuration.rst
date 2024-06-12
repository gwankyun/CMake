����11����ӵ�������
====================================

��\ :guide:`��װ�Ͳ��� <tutorial/Installing and Testing>`\ �̳��У�����������CMake\
��װ��Ŀ���ͷ�ļ�����������\ :guide:`������װ���� <tutorial/Packaging an Installer>`\
�ڼ䣬��������˴����Щ��Ϣ�Ĺ��ܣ��Ա㽫��ַ��������ˡ�

��һ������ӱ�Ҫ����Ϣ���Ա�����CMake��Ŀ����ʹ�����ǵ���Ŀ���������ڹ���Ŀ¼�����ذ�װ����\
���ʱ��

��һ���Ǹ������ǵ�\ :command:`install(TARGETS)`\ �������ָ��\ ``DESTINATION``����\
ָ��\ ``EXPORT``��\ ``EXPORT``\ �ؼ������ɲ���װһ��CMake�ļ������а����Ӱ�װ�����밲װ\
�������г�������Ŀ��Ĵ��롣���������Ǽ�����ͨ������\ ``MathFunctions/CMakeLists.txt``\
�е�\ ``install``\ ��������ʽ\ ``EXPORT`` ``MathFunctions``\ �⣬������ʾ��

.. literalinclude:: Complete/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-install-TARGETS-EXPORT
  :language: cmake
  :start-after: # install libs

���������Ѿ�������\ ``MathFunctions``�����ǻ���Ҫ��ʽ��װ���ɵ�\
``MathFunctionsTargets.cmake``\ �ļ�������ͨ���ڶ���\ ``CMakeLists.txt``\ �ĵײ���\
������������ʵ�ֵģ�

.. literalinclude:: Complete/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-install-EXPORT
  :language: cmake
  :start-after: # install the configuration targets
  :end-before: include(CMakePackageConfigHelpers)

��ʱ����Ӧ�ó�������CMake�����һ�ж�������ȷ����ῴ��CMake������һ�����󣬿�������

.. code-block:: console

  Target "MathFunctions" INTERFACE_INCLUDE_DIRECTORIES property contains
  path:

    "/Users/robert/Documents/CMakeClass/Tutorial/Step11/MathFunctions"

  which is prefixed in the source directory.

CMake�����ɵ�����Ϣʱ��������һ��
��������һ���������뵱ǰ�����󶨵�·��
��������������Ч������������ķ����Ǹ���\ ``MathFunctions``\ ��\
:command:`target_include_directories`��������ڹ���Ŀ¼�Ͱ�װ/����ʹ����ʱ��Ҫ��ͬ��\
``INTERFACE``\ λ�á�����ζ�Ž�\ ``MathFunctions``\ ��\
:command:`target_include_directories` \����ת����������ʾ��

.. literalinclude:: Step12/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_include_directories
  :language: cmake
  :start-after: # �����Լ�����
  :end-before: # �Ƿ�ʹ���Լ�����ѧ����

һ���������£����ǿ�����������CMake����֤�����ٷ������档

��ʱ�������Ѿ���CMake��ȷ�ش���������Ŀ����Ϣ����������Ȼ��Ҫ����\
``MathFunctionsConfig.cmake``����CMake��\ :command:`find_package`\ ��������ҵ���\
�ǵ���Ŀ����ˣ������Ǽ�������Ŀ�Ķ������һ����Ϊ\ ``Config.cmake.in``\ �����ļ����ڸ���\
�����ݣ�

.. literalinclude:: Step12/Config.cmake.in
  :caption: Config.cmake.in
  :name: Config.cmake.in

Ȼ��Ϊ����ȷ�����úͰ�װ���ļ����������ļ���ӵ�����\ ``CMakeLists.txt``\ �ĵײ���

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-install-Config.cmake
  :language: cmake
  :start-after: # ��װ����Ŀ��
  :end-before: # ���ɰ��������������ļ�


������������ִ��\ :command:`configure_package_config_file`������������ṩ���ļ���\
�����׼\ :command:`configure_file`\ ������һЩ�ض�������Ϊ����ȷ��ʹ���������������\
����������⣬�����ļ�Ӧ����һ���ı�\ ``@PACKAGE_INIT@``���ñ�������һ��������滻���ô�\
��齫������ֵת��Ϊ���·������Щ��ֵ����ͨ����ͬ���������ã�����������ǰ�����\
``PACKAGE_``\ ǰ׺��

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-configure-package-config.cmake
  :language: cmake
  :start-after: # ��װ����Ŀ��
  :end-before: # Ϊ�����ļ����ɰ汾�ļ�

��������\ :command:`write_basic_package_version_file`��������д��\
:command:`find_package`\ �ĵ���ʹ�õ��ļ�����ȷ��������İ汾�ͼ����ԡ����������ʹ��\
``Tutorial_VERSION_*``\ ��������˵����\ ``AnyNewerVersion``\ ���ݣ����ʾ�ð汾����\
�θ��߰汾������İ汾���ݡ�

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-basic-version-file.cmake
  :language: cmake
  :start-after: # Ϊ�����ļ����ɰ汾�ļ�
  :end-before: # ��װ���ɵ������ļ�

��󣬽��������ɵ��ļ�����Ϊ�谲װ��

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-install-configured-files.cmake
  :language: cmake
  :start-after: # ��װ���ɵ������ļ�
  :end-before: # Ϊ���������ɵ���Ŀ��

���ˣ������Ѿ�Ϊ���ǵ���Ŀ������һ�����ض�λ��CMake���ã������ڰ�װ������Ŀ֮��ʹ�á����\
������Ҫ���ǵ���ĿҲ��һ������Ŀ¼��ʹ�ã�����ֻ��Ҫ������¶���\ ``CMakeLists.txt``\ �ĵײ���

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-export
  :language: cmake
  :start-after: # needs to be after the install(TARGETS) command

ʹ������������ã�������������һ��\ ``MathFunctionsTargets.cmake``����������\
``MathFunctionsConfig.cmake``\ �ļ����Թ�������Ŀʹ�ã������谲װ��
