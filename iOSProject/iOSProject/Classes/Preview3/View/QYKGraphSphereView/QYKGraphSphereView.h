//
//  QYKGraphSphereView.h
//  QYKGraphSphereView
//
//  Created by wlq on 2020/10/10.
//  Copyright © 2020年 wlq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYKGraphSphereView : UIView

/// 中心点
@property (nonatomic,assign) CGPoint centerPoint;

/**
 *  Sets the cloud's tag views.
 *
 *	@remarks Any @c UIView subview can be passed in the array.
 *
 *  @param array The array of tag views.
 */
- (void)setCloudTags:(NSArray *)array;

/**
 *  Starts the cloud autorotation animation.
 */
- (void)timerStart;

/**
 *  Stops the cloud autorotation animation.
 */
- (void)timerStop;



@end
