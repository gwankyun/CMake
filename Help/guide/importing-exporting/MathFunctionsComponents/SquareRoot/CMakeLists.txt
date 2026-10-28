# create library
# 创建库
add_library(SquareRoot STATIC SquareRoot.cxx)

add_library(MathFunctions::SquareRoot ALIAS SquareRoot)

# add include directories
# 添加包含目录
target_include_directories(SquareRoot
                           PUBLIC
                           "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
                           "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)

# install the target and create export-set
# 安装该目标并创建导出集
install(TARGETS SquareRoot
        EXPORT SquareRootTargets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# install header file
# 安装头文件
install(FILES SquareRoot.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# generate and install export file
# 生成并安装导出文件
install(EXPORT SquareRootTargets
        FILE MathFunctionsSquareRootTargets.cmake
        NAMESPACE MathFunctions::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/MathFunctions
)
