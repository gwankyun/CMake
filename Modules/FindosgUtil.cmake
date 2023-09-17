# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindosgUtil
-----------



这是\ ``Findosg*``\ 套件的一部分，用于查找OpenSceneGraph组件。每个组件都是独立的，你必\
须选择加入每个模块。你还必须选择OpenGL和OpenThreads（和生产者，如果需要的话），因为这些模\
块不会为你做。这是为了在需要退出某些组件或更改特定模块的Find行为（可能是因为默认\
:module:`FindOpenGL`\ 模块不能与你的系统一起工作）时，允许你逐个控制自己的系统。如果你想\
使用一个更方便的模块，包括一切，使用\ :module:`FindOpenSceneGraph`\ 而不是\
``Findosg*.cmake``\ 模块。

定位osgUtil，该模块定义：

``OSGUTIL_FOUND``
  Was osgUtil found?
``OSGUTIL_INCLUDE_DIR``
  Where to find the headers
``OSGUTIL_LIBRARIES``
  The libraries to link for osgUtil (use this)
``OSGUTIL_LIBRARY``
  The osgUtil library
``OSGUTIL_LIBRARY_DEBUG``
  The osgUtil debug library

``$OSGDIR`` is an environment variable that would correspond to::

  ./configure --prefix=$OSGDIR
  
used in building osg.

Created by Eric Wing.
#]=======================================================================]

# Header files are presumed to be included like
# #include <osg/PositionAttitudeTransform>
# #include <osgUtil/SceneView>

include(${CMAKE_CURRENT_LIST_DIR}/Findosg_functions.cmake)
OSG_FIND_PATH   (OSGUTIL osgUtil/SceneView)
OSG_FIND_LIBRARY(OSGUTIL osgUtil)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(osgUtil DEFAULT_MSG
    OSGUTIL_LIBRARY OSGUTIL_INCLUDE_DIR)
