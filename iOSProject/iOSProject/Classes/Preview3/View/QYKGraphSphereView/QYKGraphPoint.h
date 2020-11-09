//
//  QYKGraphPoint.h
//  QYKGraphPoint
//
//  Created by wlq on 2020/10/10.
//  Copyright © 2020年 wlq. All rights reserved.
//

#ifndef QYKGraphPoint_h
#define QYKGraphPoint_h


struct QYKGraphPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct QYKGraphPoint QYKGraphPoint;


QYKGraphPoint QYKGraphPointMake(CGFloat x, CGFloat y, CGFloat z) {
    QYKGraphPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}


#endif /* QYKGraphPoint_h */
