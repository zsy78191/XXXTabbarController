//
//  bezier.h
//  SimpleDictionary
//
//  Created by 张超 on 16/3/23.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#ifndef bezier_h
#define bezier_h

#include <stdio.h>

/*
 產生三次方貝茲曲線的程式碼
 */

typedef struct
{
    float x;
    float y;
}
Point2D;
Point2D PointOnCubicBezier( Point2D* cp, float t );
void ComputeBezier( Point2D* cp, int numberOfPoints, Point2D* curve );

#endif /* bezier_h */
