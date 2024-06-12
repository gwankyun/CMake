target_compile_definitions
--------------------------

��Ŀ����ӱ��붨�塣

.. code-block:: cmake

  target_compile_definitions(<target>
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

ָ���������\ ``<target>``\ ʱҪʹ�õı��붨�塣������\ ``<target>``\ ��������\
:command:`add_executable`\ ��\ :command:`add_library`\ ��������ģ����Ҳ�����\
:ref:`����Ŀ�� <Alias Targets>`��

``INTERFACE``��\ ``PUBLIC``\ ��\ ``PRIVATE``\ �ؼ�������ָ�����в�����\
:ref:`������ <Target Command Scope>`��\ ``PRIVATE``\ ��\ ``PUBLIC``\ ����\
``<target>``\ ��\ :prop_tgt:`COMPILE_DEFINITIONS`\ ���ԡ�\ ``PUBLIC``\ ��\
``INTERFACE``\ ����\ ``<target>``\ ��\ :prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`\
���ԡ����в���ָ�����붨�塣�ظ�������ͬ��\ ``<target>``\ ��Ԫ�ذ��յ��õ�˳����ӡ�

.. versionadded:: 3.11
  ������\ :ref:`����Ŀ�� <Imported Targets>`\ ������\ ``INTERFACE``\ �

.. |command_name| replace:: ``target_compile_definitions``
.. include:: GENEX_NOTE.txt

Ԫ��ǰ���\ ``-D``\ ����ɾ����������ԡ����磬���´��붼�ǵȼ۵ģ�

.. code-block:: cmake

  target_compile_definitions(foo PUBLIC FOO)
  target_compile_definitions(foo PUBLIC -DFOO)  # -D removed
  target_compile_definitions(foo PUBLIC "" FOO) # "" ignored
  target_compile_definitions(foo PUBLIC -D FOO) # -D becomes "", then ignored

��������п�ѡ��ֵ��

.. code-block:: cmake

  target_compile_definitions(foo PUBLIC FOO=1)

��ע�⣬����������\ ``-DFOO``\ ��Ϊ\ ``-DFOO=1``�����������߿��ܲ��������������ʶ����\
һ�㣨����IntelliSense����

�������
^^^^^^^^

* :command:`add_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`
