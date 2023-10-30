# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindosgPresentation
-------------------



这是\ ``Findosg*``\ 套件的一部分，用于查找OpenSceneGraph组件。每个组件都是独立的，你必\
须选择加入每个模块。你还必须选择OpenGL和OpenThreads（和生产者，如果需要的话），因为这些模\
块不会为你做。这是为了在需要退出某些组件或更改特定模块的Find行为（可能是因为默认\
:module:`FindOpenGL`\ 模块不能与你的系统一起工作）时，允许你逐个控制自己的系统。如果你想\
使用一个更方便的模块，包括一切，使用\ :module:`FindOpenSceneGraph`\ 而不是\
``Findosg*.cmake``\ 模块。

定位osgPresentation，该模块定义：

``OSGPRESENTATION_FOUND``
  Was osgPresentation found?
``OSGPRESENTATION_INCLUDE_DIR``
  Where to find the headers
``OSGPRESENTATION_LIBRARIES``
  The libraries to link for osgPresentation (use this)
``OSGPRESENTATION_LIBRARY``
  The osgPresentation library
``OSGPRESENTATION_LIBRARY_DEBUG``
  The osgPresentation debug library

``$OSGDIR`` is an environment variable that would correspond to::

  ./configure --prefix=$OSGDIR

used in building osg.
Created by Eric Wing.  Modified to work with osgPresentation by Robert
Osfield, January 2012.
#]=======================================================================]

# Header files are presumed to be included like
# #include <osg/PositionAttitudeTransform>
# #include <osgPresentation/SlideEventHandler>

include(${CMAKE_CURRENT_LIST_DIR}/Findosg_functions.cmake)
OSG_FIND_PATH   (OSGPRESENTATION osgPresentation/SlideEventHandler)
OSG_FIND_LIBRARY(OSGPRESENTATION osgPresentation)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(osgPresentation DEFAULT_MSG
    OSGPRESENTATION_LIBRARY OSGPRESENTATION_INCLUDE_DIR)
