cmake_minimum_required(VERSION 3.0)
#
# project(CASACORE C CXX)
#
# if(BUILD_SHARED_LIBS)
#     set(SHARED On CACHE BOOL "")
# else()
#     set(SHARED Off CACHE BOOL "")
# endif()

set(Python3_ROOT_DIR $ENV{PYTHON_ROOT_DIR} CACHE PATH "Python root")
set(BOOST_PYTHON3_LIBRARY_NAME python CACHE PATH "Name of boost python library to search for")
set(PYTHON_EXECUTABLE "${Python3_ROOT_DIR}/bin/python3" CACHE FILEPATH "Python executable")

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
