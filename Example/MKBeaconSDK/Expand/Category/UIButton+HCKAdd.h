//
//  UIButton+HCKAdd.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HCKAdd)

#pragma mark - 设置背景颜色
/**
 *  设置背景颜色
 *
 *  @param backgroundColor 设置的颜色
 *  @param state 按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


#pragma mark - 设置倒计时时间（通用）
/**
 *  设置倒计时时间
 *
 *  @param seconds 设置的时间
 */
- (void)startCountdown:(NSUInteger)seconds;


#pragma mark - Runtime解决UIButton重复点击问题

/**
 *  点击事件的事件间隔
 */
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;

@end
