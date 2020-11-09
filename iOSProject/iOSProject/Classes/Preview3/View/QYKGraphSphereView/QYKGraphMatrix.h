//
//  QYKGraphMatrix.h
//  QYKGraphMatrix
//
//  Created by wlq on 2020/10/10.
//  Copyright © 2020年 wlq. All rights reserved.
//

#ifndef QYKGraphMatrix_h
#define QYKGraphMatrix_h

#import "QYKGraphPoint.h"

struct QYKGraphMatrix {
    NSInteger column;
    NSInteger row;
    CGFloat matrix[4][4];
};

typedef struct QYKGraphMatrix QYKGraphMatrix;

static QYKGraphMatrix QYKGraphMatrixMake(NSInteger column, NSInteger row) {
    QYKGraphMatrix matrix;
    matrix.column = column;
    matrix.row = row;
    for(NSInteger i = 0; i < column; i++){
        for(NSInteger j = 0; j < row; j++){
            matrix.matrix[i][j] = 0;
        }
    }
    
    return matrix;
}

static QYKGraphMatrix QYKGraphMatrixMakeFromArray(NSInteger column, NSInteger row, CGFloat *data) {
    QYKGraphMatrix matrix = QYKGraphMatrixMake(column, row);
    for (int i = 0; i < column; i ++) {
        CGFloat *t = data + (i * row);
        for (int j = 0; j < row; j++) {
            matrix.matrix[i][j] = *(t + j);
        }
    }
    return matrix;
}

static QYKGraphMatrix QYKGraphMatrixMutiply(QYKGraphMatrix a, QYKGraphMatrix b) {
    QYKGraphMatrix result = QYKGraphMatrixMake(a.column, b.row);
    for(NSInteger i = 0; i < a.column; i ++){
        for(NSInteger j = 0; j < b.row; j ++){
            for(NSInteger k = 0; k < a.row; k++){
                result.matrix[i][j] += a.matrix[i][k] * b.matrix[k][j];
            }
        }
    }
    return result;
}

static QYKGraphPoint QYKGraphPointMakeRotation(QYKGraphPoint point, QYKGraphPoint direction, CGFloat angle) {
    //    CGFloat temp1[4] = {direction.x, direction.y, direction.z, 1};
    //    QYKGraphMatrix directionM = QYKGraphMatrixMakeFromArray(1, 4, temp1);
    if (angle == 0) {
        return point;
    }
    
    CGFloat temp2[1][4] = {point.x, point.y, point.z, 1};
    //    QYKGraphMatrix pointM = QYKGraphMatrixMakeFromArray(1, 4, *temp2);
    
    QYKGraphMatrix result = QYKGraphMatrixMakeFromArray(1, 4, *temp2);
    
    if (direction.z * direction.z + direction.y * direction.y != 0) {
        CGFloat cos1 = direction.z / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat sin1 = direction.y / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat t1[4][4] = {{1, 0, 0, 0}, {0, cos1, sin1, 0}, {0, -sin1, cos1, 0}, {0, 0, 0, 1}};
        QYKGraphMatrix m1 = QYKGraphMatrixMakeFromArray(4, 4, *t1);
        result = QYKGraphMatrixMutiply(result, m1);
    }
    
    if (direction.x * direction.x + direction.y * direction.y + direction.z * direction.z != 0) {
        CGFloat cos2 = sqrt(direction.y * direction.y + direction.z * direction.z) / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat sin2 = -direction.x / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat t2[4][4] = {{cos2, 0, -sin2, 0}, {0, 1, 0, 0}, {sin2, 0, cos2, 0}, {0, 0, 0, 1}};
        QYKGraphMatrix m2 = QYKGraphMatrixMakeFromArray(4, 4, *t2);
        result = QYKGraphMatrixMutiply(result, m2);
    }
    
    CGFloat cos3 = cos(angle);
    CGFloat sin3 = sin(angle);
    CGFloat t3[4][4] = {{cos3, sin3, 0, 0}, {-sin3, cos3, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    QYKGraphMatrix m3 = QYKGraphMatrixMakeFromArray(4, 4, *t3);
    result = QYKGraphMatrixMutiply(result, m3);
    
    if (direction.x * direction.x + direction.y * direction.y + direction.z * direction.z != 0) {
        CGFloat cos2 = sqrt(direction.y * direction.y + direction.z * direction.z) / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat sin2 = -direction.x / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat t2_[4][4] = {{cos2, 0, sin2, 0}, {0, 1, 0, 0}, {-sin2, 0, cos2, 0}, {0, 0, 0, 1}};
        QYKGraphMatrix m2_ = QYKGraphMatrixMakeFromArray(4, 4, *t2_);
        result = QYKGraphMatrixMutiply(result, m2_);
    }
    
    if (direction.z * direction.z + direction.y * direction.y != 0) {
        CGFloat cos1 = direction.z / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat sin1 = direction.y / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat t1_[4][4] = {{1, 0, 0, 0}, {0, cos1, -sin1, 0}, {0, sin1, cos1, 0}, {0, 0, 0, 1}};
        QYKGraphMatrix m1_ = QYKGraphMatrixMakeFromArray(4, 4, *t1_);
        result = QYKGraphMatrixMutiply(result, m1_);
    }
    
    QYKGraphPoint resultPoint = QYKGraphPointMake(result.matrix[0][0], result.matrix[0][1], result.matrix[0][2]);
    
    return resultPoint;
}



#endif /* QYKGraphMatrix_h */
