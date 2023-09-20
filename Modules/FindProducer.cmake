# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindProducer
------------



虽然Producer不是OpenSceneGraph的直接组成部分，但它的主要用户是OSG，所以我认为这是Findosg*\
套件的一部分，用于查找OpenSceneGraph组件。你将注意到我接受OSGDIR作为环境路径。

每个组件都是独立的，你必须选择加入每个模块。你还必须选择OpenGL（和OpenThreads？），因为这\
些模块不会为你做。这是为了让你在需要选择退出某些组件或更改特定模块的查找行为（可能是因为默认的\
:module:`FindOpenGL` \模块不能与你的系统一起工作）的情况下，一块一块地控制你自己的系统。\
如果你想使用一个更方便的模块，包括一切，使用\ :module:`FindOpenSceneGraph`\ 而不是\
Findosg*.cmake模块。

定位Producer，此模块定义：

``PRODUCER_LIBRARY``

``PRODUCER_FOUND``
  if false, do not try to link to Producer
``PRODUCER_INCLUDE_DIR``
  where to find the headers

``$PRODUCER_DIR`` is an environment variable that would correspond to::

  ./configure --prefix=$PRODUCER_DIR
  
used in building osg.

Created by Eric Wing.
#]=======================================================================]

# Header files are presumed to be included like
# #include <Producer/CameraGroup>

# Try the user's environment request before anything else.
find_path(PRODUCER_INCLUDE_DIR Producer/CameraGroup
  HINTS
    ENV PRODUCER_DIR
    ENV OSG_DIR
    ENV OSGDIR
  PATH_SUFFIXES include
  PATHS
    ~/Library/Frameworks
    /Library/Frameworks
    /opt
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OpenThreads_ROOT]
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]
)

find_library(PRODUCER_LIBRARY
  NAMES Producer
  HINTS
    ENV PRODUCER_DIR
    ENV OSG_DIR
    ENV OSGDIR
  PATH_SUFFIXES lib
  PATHS
  /opt
)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Producer DEFAULT_MSG
    PRODUCER_LIBRARY PRODUCER_INCLUDE_DIR)
