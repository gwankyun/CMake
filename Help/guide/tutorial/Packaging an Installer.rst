����9: ���һ����װ��
==============================

�����¸�Ը���Ƿַ��������ñ���ʹ������������ͬʱ�ַ�Դ��Ͷ������ڲ�ͬ��ƽ̨����������֮ǰ��\
�۵�\ :guide:`��װ�Ͳ��� <tutorial/Installing and Testing>`\ ��ͬ���ǣ�����Ҫ��Դ����\
���롣�ڴ������У����ǻṹ��һ����װ����֧�ֶ����ư�װ��������Ϊ�˴ﵽ���Ŀ������Ӧ��ʹ��\
CPack������ͬƽ̨�İ�װ����Ӧ���ڶ���\ ``CMakeLists.txt``\ ��ͷ��Ӽ��С�

.. literalinclude:: Step10/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-include-CPack
  :language: cmake
  :start-after: # ���ð�װ����

��������Ƕ����������޸ġ������ڿ�ʼ����\ :module:`InstallRequiredSystemLibraries`��\
���ģ��������ǰ��Ŀ�ڵ�ǰƽ̨�����������ʱ�⡣����������һЩCPack���������õ�ǰ��Ŀ����\
��֤���汾�š��汾���ڽ̳�֮ǰ�Ĳ������Ѿ����ã�``license.txt``\ �Ѿ������Դ��Ŀ¼����߲㡣\
The :variable:`CPACK_GENERATOR` and
:variable:`CPACK_SOURCE_GENERATOR` variables select the generators used for
binary and source installations, respectively.

������������\ :module:`CPack module <CPack>`\ ��ʹ����Щ���������������������ڰ�װ����

��һ�����ǰ���ͨ��ϰ�߹�����������\ :manual:`cpack <cpack(1)>`\ �������һ�������ư���\
����Ҫ�ڶ�����Ŀ¼���У�

.. code-block:: console

  cpack

Ҫָ������������������ʹ��\ :option:`-G <cpack -G>`\ ѡ����ڶ����ð汾��ʹ��\
:option:`-C <cpack -C>`\ ��ָ�����á����磺

.. code-block:: console

  cpack -G ZIP -C Debug

�йؿ������������б���μ�\ :manual:`cpack-generators(7)`\ �����\ :option:`cpack --help`��\
��ZIP������\ :cpack_gen:`�浵������ <CPack Archive Generator>`\ ��Ϊ����\ *�Ѱ�װ�ļ�*\
����һ��ѹ���浵��

����봴��һ��\ *������*\ Դ��ַ�����Ӧ�����룺

.. code-block:: console

  cpack --config CPackSourceConfig.cmake

��Ϊ���������\ ``make package``\ ���������IDE���һ�\ ``Package``\ Ŀ�겢\
``Build Project``��

�����ڶ�����Ŀ¼�ҵ��İ�װ������֤�Ƿ���Ԥ�ڡ�
