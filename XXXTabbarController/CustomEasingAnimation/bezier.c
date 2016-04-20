//
//  bezier.c
//  SimpleDictionary
//
//  Created by 张超 on 16/3/23.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#include "bezier.h"

/*
 cp在此是四個元素的陣列:
 cp[0]為起始點，或上圖中的P0
 cp[1]為第一個控制點，或上圖中的P1
 cp[2]為第二個控制點，或上圖中的P2
 cp[3]為結束點，或上圖中的P3
 t為參數值，0 <= t <= 1
 */

Point2D PointOnCubicBezier( Point2D* cp, float t )
{
    float   ax, bx, cx;
    float   ay, by, cy;
    float   tSquared, tCubed;
    Point2D result;
    
    /*計算多項式係數*/
    
    cx = 3.0 * (cp[1].x - cp[0].x);
    bx = 3.0 * (cp[2].x - cp[1].x) - cx;
    ax = cp[3].x - cp[0].x - cx - bx;
    
    cy = 3.0 * (cp[1].y - cp[0].y);
    by = 3.0 * (cp[2].y - cp[1].y) - cy;
    ay = cp[3].y - cp[0].y - cy - by;
    
    /*計算位於參數值t的曲線點*/
    
    tSquared = t * t;
    tCubed = tSquared * t;
    
    result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[0].x;
    result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + cp[0].y;
    
    return result;
}

/*
 ComputeBezier以控制點cp所產生的曲線點，填入Point2D結構的陣列。
 呼叫者必須分配足夠的記憶體以供輸出結果，其為<sizeof(Point2D) numberOfPoints>
 */

void ComputeBezier( Point2D* cp, int numberOfPoints, Point2D* curve )
{
    float   dt;
    int    i;
    dt = 1.0 / ( numberOfPoints - 1 );
    for( i = 0; i < numberOfPoints; i++)
        curve[i] = PointOnCubicBezier( cp, i*dt );
}