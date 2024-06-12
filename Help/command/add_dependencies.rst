add_dependencies
----------------

��Ӷ���Ŀ��֮���������ϵ��

.. code-block:: cmake

  add_dependencies(<target> [<target-dependency>]...)

ʹһ������\ ``<target>``\ ��������������Ŀ�꣬��ȷ��������\ ``<target>``\ ֮ǰ������\
����Ŀ������\ :command:`add_executable`��\ :command:`add_library`\ ��\
:command:`add_custom_target`\ �������Ŀ�꣨����������\ ``install``\ ������CMake��\
��Ŀ�꣩��

��ӵ�\ :ref:`�����Ŀ�� <Imported Targets>`\ ��\ :ref:`�ӿڿ� <Interface Libraries>`\
�е������������λ�ô��ݣ���ΪĿ�걾���ṹ����

.. versionadded:: 3.3
  ������ӿڿ���������

.. versionadded:: 3.8
  Dependencies will populate the :prop_tgt:`MANUALLY_ADDED_DEPENDENCIES`
  property of ``<target>``.

.. versionchanged:: 3.9
  The :ref:`Ninja Generators` use weaker ordering than
  other generators in order to improve available concurrency.
  They only guarantee that the dependencies' custom commands are
  finished before sources in ``<target>`` start compiling; this
  ensures generated sources are available.

�������
^^^^^^^^

* :command:`add_custom_target`\ ��\ :command:`add_custom_command`\ �����\
  ``DEPENDS``\ ѡ���������Զ������������ļ��������

* :prop_sf:`OBJECT_DEPENDS`\ Դ�ļ���������������ļ�����ļ��������
