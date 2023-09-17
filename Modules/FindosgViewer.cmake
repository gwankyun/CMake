# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindosgViewer
-------------



这是\ ``Findosg*``\ 套件的一部分，用于查找OpenSceneGraph组件。每个组件都是独立的，你必\
须选择加入每个模块。你还必须选择OpenGL和OpenThreads（和生产者，如果需要的话），因为这些模\
块不会为你做。这是为了在需要退出某些组件或更改特定模块的Find行为（可能是因为默认\
:module:`FindOpenGL`\ 模块不能与你的系统一起工作）时，允许你逐个控制自己的系统。如果你想\
使用一个更方便的模块，包括一切，使用\ :module:`FindOpenSceneGraph`\ 而不是\
``Findosg*.cmake``\ 模块。

定位osgViewer，该模块定义：

``OSGVIEWER_FOUND``
  Was osgViewer found?
``OSGVIEWER_INCLUDE_DIR``
  Where to find the headers
``OSGVIEWER_LIBRARIES``
  The libraries to link for osgViewer (use this)
``OSGVIEWER_LIBRARY``
  The osgViewer library
``OSGVIEWER_LIBRARY_DEBUG``
  The osgViewer debug library

``$OSGDIR`` is an environment variable that would correspond to::

  ./configure --prefix=$OSGDIR
  
used in building osg.

Created by Eric Wing.
#]=======================================================================]

# Header files are presumed to be included like
# #include <osg/PositionAttitudeTransform>
# #include <osgViewer/Viewer>

include(${CMAKE_CURRENT_LIST_DIR}/Findosg_functions.cmake)
OSG_FIND_PATH   (OSGVIEWER osgViewer/Viewer)
OSG_FIND_LIBRARY(OSGVIEWER osgViewer)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(osgViewer DEFAULT_MSG
    OSGVIEWER_LIBRARY OSGVIEWER_INCLUDE_DIR)
