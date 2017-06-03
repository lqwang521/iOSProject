//
//  BSJCommentPageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJCommentPageViewController.h"

@interface BSJCommentPageViewController ()

@end

@implementation BSJCommentPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    
}



#pragma mark - LMJNavUIBaseViewControllerDataSource


/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end