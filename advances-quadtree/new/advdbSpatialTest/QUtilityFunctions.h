//
// Created by ravichandran on 19/03/17.
//

#ifndef ADVDBTEST_UTILITYFUNCTIONS_H
#define ADVDBTEST_UTILITYFUNCTIONS_H

#include "quadTreeLib.h"
#include "qPoint.h"
#include "qBoundingBox.h"

using namespace std;

void printQPointVectors(vector<qPoint> qPoints)
{
    for(int i=0;i< qPoints.size();i++) {
        qPoints[i].print();
    }
}

void printQBoundingBoxVectors(vector<qBoundingBox> qbbs)
{
    for(int i=0;i< qbbs.size();i++) {
        qbbs[i].print();
    }
}


#endif //ADVDBTEST_UTILITYFUNCTIONS_H
