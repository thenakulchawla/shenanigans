cmake_minimum_required(VERSION 3.6)
project(advances_quadtree)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES
        new/advdbSpatialTest/Test/testBulkLoad.h
        new/advdbSpatialTest/Test/testCases.h
        new/advdbSpatialTest/Test/testCasesmxcifQuadTree.h
        new/advdbSpatialTest/Test/testCasesprQuadTree.h
        new/advdbSpatialTest/Test/testCasesQBoundingBox.h
        new/advdbSpatialTest/Test/testCasesQPoint.h
        new/advdbSpatialTest/data-storage.h
        new/advdbSpatialTest/geometry.h
        new/advdbSpatialTest/mxcifQuadNode.h
        new/advdbSpatialTest/mxcifQuadTree.h
        new/advdbSpatialTest/PointSpatialIndex.h
        new/advdbSpatialTest/prQuadNode.h
        new/advdbSpatialTest/prQuadTree.h
        new/advdbSpatialTest/qBoundingBox.h
        new/advdbSpatialTest/qPoint.h
        new/advdbSpatialTest/quadTreeLib.h
        new/advdbSpatialTest/qUtilityFunctions.h
        new/advdbSpatialTest/RectangleSpatialIndex.h
        new/advdbSpatialTest/spatial-index-interface.h
        new/advdbSpatialTest/SpatialIndexImpl.h
        new/advdbSpatialTest/spatialIndexingMain.cpp
        old/PQuadtree.cpp
        old/quadtree.cpp
        reference/kipt/Quadtree.cpp
        reference/kipt/Quadtree.h)

add_executable(advances_quadtree ${SOURCE_FILES})