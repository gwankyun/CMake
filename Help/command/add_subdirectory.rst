add_subdirectory
----------------

�򹹽����һ����Ŀ¼��

.. code-block:: cmake

  add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL] [SYSTEM])

�ڹ��������һ����Ŀ¼��\ ``source_dir``\ ָ����Դ�ļ�\ ``CMakeLists.txt``\ �ʹ����ļ�\
���ڵ�Ŀ¼���������һ�����·������������ڵ�ǰĿ¼���м��㣨�����÷���������Ҳ������һ����\
��·����\ ``binary_dir``\ ָ���˷�������ļ���Ŀ¼���������һ�����·������������ڵ�ǰ\
���Ŀ¼���м��㣬����Ҳ������һ������·�������û��ָ��\ ``binary_dir``\ ������չ���κ�\
���·��֮ǰʹ��\ ``source_dir``\ ��ֵ�������÷�����CMake����������ָ��ԴĿ¼�µ�\
``CMakeLists.txt``\ �ļ���Ȼ���ٴ���ǰ�����ļ���

If the ``EXCLUDE_FROM_ALL`` argument is provided then the
:prop_dir:`EXCLUDE_FROM_ALL` property will be set on the added directory.
This will exclude the directory from a default build. See the directory
property :prop_dir:`EXCLUDE_FROM_ALL` for full details.

.. versionadded:: 3.25
  ����ṩ��\ ``SYSTEM``\ ��������Ŀ¼��\ :prop_dir:`SYSTEM`\ Ŀ¼���Խ�������Ϊtrue��\
  ���������ڳ�ʼ���ڸ���Ŀ¼�д�����ÿ��δ����Ŀ���\ :prop_tgt:`SYSTEM`\ ���ԡ�
