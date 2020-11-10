//
//  QYKGraphSphereView.m
//  QYKGraphSphereView
//
//  Created by wlq on 2020/10/10.
//  Copyright © 2020年 Jason. All rights reserved.
//

#import "QYKGraphSphereView.h"
#import "QYKGraphMatrix.h"
#define PI 3.14159265358979323846

@interface QYKGraphSphereView() <UIGestureRecognizerDelegate>

@end

@implementation QYKGraphSphereView
{
    NSMutableArray *tags;
    NSMutableArray *coordinate;
    QYKGraphPoint normalDirection;
    CGPoint last;
    
    CGFloat velocity;
    
    CADisplayLink *timer;
    CADisplayLink *inertia;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:gesture];
        self.backgroundColor = [UIColor clearColor];
        // 设置默认中心点
        _centerPoint = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    }
    return self;
}

#pragma mark - initial set

- (void)setCloudTags:(NSArray *)array
{
    tags = [NSMutableArray arrayWithArray:array];
    coordinate = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 重置view的中心点,便于计算
    for (NSInteger i = 0; i < tags.count; i ++) {
        UIView *view = [tags objectAtIndex:i];
        view.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    }
    
    CGFloat p1 = M_PI * (3 - sqrt(5));
    CGFloat p2 = 2. / tags.count;
    //NSLog(@"p1:%f p2:%f", p1, p2);
    
    for (NSInteger i = 0; i < tags.count; i ++) {
        
        CGFloat y = i * p2 - 1 + (p2 / 2);
        CGFloat r = sqrt(1 - y * y);
        CGFloat p3 = i * p1;
        CGFloat x = cos(p3) * r;
        CGFloat z = sin(p3) * r;
        
        
        QYKGraphPoint point = QYKGraphPointMake(x, y, z);
        NSValue *value = [NSValue value:&point withObjCType:@encode(QYKGraphPoint)];
        [coordinate addObject:value];
        //NSLog(@"x:%f y:%f z:%f", point.x, point.y, point.z);
        
        CGFloat time = (arc4random() % 10 + 10.) / 20.;
        [UIView animateWithDuration:time delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setTagOfPoint:point andIndex:i];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    NSInteger a =  arc4random() % 10 - 5;
    NSInteger b =  arc4random() % 10 - 5;
    normalDirection = QYKGraphPointMake(a, b, 0);
    [self timerStart];
}

#pragma mark - set frame of point

- (void)updateFrameOfPoint:(NSInteger)index direction:(QYKGraphPoint)direction andAngle:(CGFloat)angle
{
    
    NSValue *value = [coordinate objectAtIndex:index];
    QYKGraphPoint point;
    [value getValue:&point];
    
    QYKGraphPoint rPoint = QYKGraphPointMakeRotation(point, direction, angle);
    value = [NSValue value:&rPoint withObjCType:@encode(QYKGraphPoint)];
    coordinate[index] = value;
    
    [self setTagOfPoint:rPoint andIndex:index];
    
}

- (void)setTagOfPoint: (QYKGraphPoint)point andIndex:(NSInteger)index
{
    UIView *view = [tags objectAtIndex:index];
    CGPoint center = CGPointMake((point.x + 1) * (self.frame.size.width / 2.), (point.y + 1) * self.frame.size.width / 2.);

    view.center = center;
    CGFloat transform = (point.z + 2) / 3;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, transform, transform);
    view.layer.zPosition = transform;
    view.alpha = transform;
    //NSLog(@"transform:%f", transform);
    
    if (point.z < 0) {
        view.userInteractionEnabled = NO;
    }else {
        view.userInteractionEnabled = YES;
    }
}

#pragma mark - autoTurnRotation

- (void)timerStart
{
    timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoTurnRotation)];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)timerStop
{
    [timer invalidate];
    timer = nil;
}

- (void)autoTurnRotation
{
    for (NSInteger i = 0; i < tags.count; i ++) {
        [self updateFrameOfPoint:i direction:normalDirection andAngle:0.002];
    }
    [self setNeedsDisplay];
}

#pragma mark - inertia

- (void)inertiaStart
{
    [self timerStop];
    inertia = [CADisplayLink displayLinkWithTarget:self selector:@selector(inertiaStep)];
    [inertia addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)inertiaStop
{
    [inertia invalidate];
    inertia = nil;
    [self timerStart];
}

- (void)inertiaStep
{
    if (velocity <= 0) {
        [self inertiaStop];
    }else {
        velocity -= 70.;
        CGFloat angle = velocity / self.frame.size.width * 2. * inertia.duration;
        for (NSInteger i = 0; i < tags.count; i ++) {
            [self updateFrameOfPoint:i direction:normalDirection andAngle:angle];
        }
        [self setNeedsDisplay];
    }
    
}

#pragma mark - gesture selector

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        last = [gesture locationInView:self];
        [self timerStop];
        [self inertiaStop];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [gesture locationInView:self];
        QYKGraphPoint direction = QYKGraphPointMake(last.y - current.y, current.x - last.x, 0);
        
        CGFloat distance = sqrt(direction.x * direction.x + direction.y * direction.y);
        
        CGFloat angle = distance / (self.frame.size.width / 2.);
        
        for (NSInteger i = 0; i < tags.count; i ++) {
            [self updateFrameOfPoint:i direction:direction andAngle:angle];
        }
        normalDirection = direction;
        last = current;
        
        [self setNeedsDisplay];
        
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocityP = [gesture velocityInView:self];
        velocity = sqrt(velocityP.x * velocityP.x + velocityP.y * velocityP.y);
        [self inertiaStart];
        
    }
}

#pragma mark 使用默认context进行绘图

- (void)drawLineWithIndex:(NSInteger)index {
    NSValue *value = [coordinate objectAtIndex:index];
    QYKGraphPoint point;
    if (@available(iOS 11.0, *)) {
        [value getValue:&point size:sizeof(point)];
    } else {
        [value getValue:&point];
    }
    
    UIView *view = [tags objectAtIndex:index];
    CGPoint center = CGPointMake((point.x + 1) * (self.frame.size.width / 2.), (point.y + 1) * self.frame.size.width / 2.);

    view.center = center;
    [self drawLineToPoint:center];
}

/// 绘制所有的线
- (void)drawALLLine {
    for (NSInteger i = 0; i < tags.count; i ++) {
        [self drawLineWithIndex:i];
    }
}

- (void)drawLineToPoint:(CGPoint)point
{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置当前上下问路径
    //设置起始点
    CGContextMoveToPoint(ctx, self.centerPoint.x, self.centerPoint.y);
    //增加点
    CGContextAddLineToPoint(ctx, point.x, point.y);
    //关闭路径
    CGContextClosePath(ctx);
    
    // 线宽
    CGContextSetLineWidth(ctx, 0.5);
    //设置属性
    [[UIColor lightGrayColor] setStroke];
    [[UIColor lightGrayColor] setFill];
    //4.绘制路径
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)drawRect:(CGRect)rect {
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, rect);
    
    [self drawALLLine];
    
    UIColor*aColor = [UIColor colorWithRed:255/255.0 green:230/255.0 blue:218/255.0 alpha:1/1.0];
    CGContextSetFillColorWithColor(ctx, aColor.CGColor);
    //CGContextSetLineWidth(ctx, 0.0);
    CGContextAddArc(ctx, self.centerPoint.x, self.centerPoint.y, 7.5, 0, 2*PI, 0);
    CGContextDrawPath(ctx, kCGPathFill);
    
    UIColor*bColor = [UIColor colorWithRed:255/255.0 green:139/255.0 blue:84/255.0 alpha:1/1.0];
    CGContextSetFillColorWithColor(ctx, bColor.CGColor);
    CGContextAddArc(ctx, self.centerPoint.x, self.centerPoint.y, 4, 0, 2*PI, 0);
    CGContextDrawPath(ctx, kCGPathFill);
    
    // 标签前置
    for (UIView *object in tags) {
        [self bringSubviewToFront:object];
    }
}

@end
