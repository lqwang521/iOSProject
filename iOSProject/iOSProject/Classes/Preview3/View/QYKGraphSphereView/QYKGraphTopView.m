//
//  QYKGraphTopView.m
//  iOSProject
//
//  Created by liquan wang on 2020/11/10.
//  Copyright © 2020 github.com/njhu. All rights reserved.
//

#import "QYKGraphTopView.h"
#import "QYKGraphSphereView.h"

@interface QYKGraphTopView ()<CAAnimationDelegate>
/// 文字球
@property (nonatomic, strong) QYKGraphSphereView *sphereView;

/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

/// 描述label
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation QYKGraphTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _backBtn.frame = CGRectMake(0, 0, 60, 50);
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn setBackgroundColor:[UIColor clearColor]];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(resumeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        
        
        NSString *descText = @"一段描述";
        CGSize size = CGSizeMake(MAXFLOAT, 50);
        UIFont *font = [UIFont systemFontOfSize:12.];
        CGFloat textWidth = [descText boundingRectWithSize:size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:font}
                                                   context:nil].size.width;
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backBtn.frame) + 5, CGRectGetMinX(_backBtn.frame), textWidth, 50)];
        _descLabel.textColor = [UIColor orangeColor];
        _descLabel.text = descText;
        _descLabel.font = font;
        _descLabel.numberOfLines = 1;
        [self addSubview:_descLabel];
        
        [self setupUI];
        
        [self bringSubviewToFront:_descLabel];
    }
    return self;
}

/// 设置UI
- (void)setupUI {
    
    static CGFloat btnHeight = 50;
    CGSize sphereViewSize = CGSizeMake(320, 320);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"中心按钮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.frame = CGRectMake(0, 0, 80, 20);
    btn.center = CGPointMake(sphereViewSize.width/2, sphereViewSize.height/2);
    [btn addTarget:self action:@selector(resumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    
    _sphereView = [[QYKGraphSphereView alloc] initWithFrame:CGRectMake(0, 150, sphereViewSize.width, sphereViewSize.height)];
    [_sphereView addSubview:btn];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 10; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        NSString *title = [NSString stringWithFormat:@"第第第第第第第第%ld个", i];
        [btn setTitle:title forState:UIControlStateNormal];
        
        UIFont *font = [UIFont systemFontOfSize:14.];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        btn.titleLabel.numberOfLines = 2;
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.frame = CGRectMake(0, 0, 80, btnHeight);
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [btn setBackgroundColor:[UIColor clearColor]];
        [_sphereView addSubview:btn];
    }
    [_sphereView setCloudTags:array];
    [self addSubview:_sphereView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)buttonPressed:(UIButton *)btn {
    [self startAnimationFromValue:@1 toValue:@0];
}

/// 开始动画
- (void)startAnimationFromValue:(id)fromValue toValue:(id)toValue {
    [self.sphereView.layer removeAnimationForKey:@"QYKSphereViewTransformScale"];
    
    // 动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    __weak typeof(self) ws = self;
    anim.delegate = ws;
    //anim.keyPath = @"position";
    anim.keyPath = @"transform.scale";
    // 设置值
    //anim.toValue = [NSValue valueWithCGPoint:CGPointMake(250, 500)];
    anim.fromValue = fromValue;
    anim.toValue = toValue;
    anim.repeatCount = 1;
    anim.duration = 0.25;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.sphereView.layer addAnimation:anim forKey:@"QYKSphereViewTransformScale"];
}


- (void)resumeClick:(id)sender {
    self.sphereView.hidden = NO;
    [self startAnimationFromValue:@0 toValue:@1];
}

#pragma - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

- (void)drawRect:(CGRect)rect {
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0.0 alpha:0.0] setFill];
    CGContextFillRect(ctx, rect);
    
    // 设置当前上下问路径
    // 设置起始点
    CGContextMoveToPoint(ctx, self.descLabel.center.x, self.descLabel.center.y);
    // 增加点
    CGContextAddLineToPoint(ctx, self.sphereView.center.x, self.sphereView.center.y);
    // 关闭路径
    CGContextClosePath(ctx);
    
    // 线宽
    CGContextSetLineWidth(ctx, 0.5);
    // 设置属性
    [[UIColor grayColor] setStroke];
    [[UIColor grayColor] setFill];
    // 绘制路径
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end
