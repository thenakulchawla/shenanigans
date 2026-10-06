cmake_minimum_required(VERSION 2.8.7)
project(advdbTest)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES spatialIndexingMain.cpp qPoint.h quadTreeLib.h qBoundingBox.h prQuadNode.h prQuadTree.h Test/testCases.h mxcifQuadNode.h mxcifQuadTree.h Test/testCasesmxcifQuadTree.h Test/testCasesprQuadTree.h qUtilityFunctions.h Test/testBulkLoad.h)
add_executable(advdbTest ${SOURCE_FILES})