# cmake_minimum_required(VERSION 2.8)
#
# project(CASACORE C CXX)
#
# if(BUILD_SHARED_LIBS)
#     set(SHARED On CACHE BOOL "")
# else()
#     set(SHARED Off CACHE BOOL "")
# endif()

set(Python3_ROOT_DIR $ENV{PYTHON_ROOT_DIR})

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
