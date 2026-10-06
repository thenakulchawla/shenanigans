//
// Created by ravichandran on 18/03/17.
//

#ifndef ADVDBTEST_TESTCASES_H
#define ADVDBTEST_TESTCASES_H

#include "testCasesQPoint.h"
#include "testCasesQBoundingBox.h"
#include "testCasesprQuadTree.h"
#include "testCasesmxcifQuadTree.h"
#include "testBulkLoad.h"

using namespace std;


void executeSpatialIndexingTestCases()
{

    cout<<"\n\n\nSpatial Indexing Testing - Started"<<endl;
//    testQPoints();
//    testQBoundingBox();
//    testprQuadNode();
//    testprQuadTree();
//    testmxcifQuadNode();
//
//    testmxcifQuadTree();

//    testing bulkLoad
    testBulkLoadPrQuadTree();
    cout<<"\n\n\nSpatial Indexing Testing - Ended"<<endl;

    long i = 0;
    cout<<"\n\n\nWhile Loop - Started"<<endl;
    while(true)i++;
    cout<<"\n\n\nWhile Loop - Ended"<<endl;



}


#endif //ADVDBTEST_TESTCASES_H
