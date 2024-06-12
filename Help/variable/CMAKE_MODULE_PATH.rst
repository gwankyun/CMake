CMAKE_MODULE_PATH
-----------------

Ŀ¼��\ :ref:`�ֺŷָ��б� <CMake Language Lists>`��ʹ����б�ܱ�ʾ��ָ���ڼ��CMake��\
����Ĭ��ģ��֮ǰ��\ :command:`include`\ ��\ :command:`find_package`\ ������ص�CMake\
ģ�������·����Ĭ��Ϊ�ա���������Ŀ�趨�ġ�

It's fairly common for a project to have a directory containing various
``*.cmake`` files to assist in development. Adding the directory to the
:variable:`CMAKE_MODULE_PATH` simplifies loading them. For example, a
project's top-level ``CMakeLists.txt`` file may contain:

.. code-block:: cmake

  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

  include(Foo) # Loads ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Foo.cmake

  find_package(Bar) # Loads ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindBar.cmake
