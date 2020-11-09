//
//  QYKGraphViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/5/5.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "QYKGraphViewController.h"
#import "QYKGraphSphereView.h"

@interface QYKGraphViewController ()<CAAnimationDelegate>

/// 文字球
@property (nonatomic, retain) QYKGraphSphereView *sphereView;

@end

@implementation QYKGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *resumebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resumebtn.frame = CGRectMake(0, 0, 100, 50);
    [resumebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resumebtn setBackgroundColor:[UIColor blueColor]];
    [resumebtn setTitle:@"恢复" forState:UIControlStateNormal];
    [resumebtn addTarget:self action:@selector(resumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumebtn];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"中心按钮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:24.];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.frame = CGRectMake(0, 0, 100, 20);
    btn.center = CGPointMake(160, 160);
    [btn addTarget:self action:@selector(resumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor greenColor]];
   
    static CGFloat btnHeight = 50;
    CGSize sphereViewSize = CGSizeMake(320, 320);

    _sphereView = [[QYKGraphSphereView alloc] initWithFrame:CGRectMake(0, 100, sphereViewSize.width, sphereViewSize.height)];
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
    _sphereView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sphereView];
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
    anim.removedOnCompletion = NO;
    anim.duration = 0.25;
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

@end
