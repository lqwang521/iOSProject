//
//  QYKGraphViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/5/5.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "QYKGraphViewController.h"
#import "QYKGraphTopView.h"

@interface QYKGraphViewController ()

@end

@implementation QYKGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QYKGraphTopView *topView = [[QYKGraphTopView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 500)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
}

@end
