//
//  UIView+HCKAdd.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HCKAdd)

#pragma mark - Base
#pragma mark -
/** 添加单击事件*/
- (void)addTapAction:(id)target selector:(SEL)selector;

/** 添加长按事件*/
- (void)addLongPressAction:(id)target selector:(SEL)selector;

/** 返回所在控制器*/
- (UIViewController *)viewController;

/** 设置圆角*/
- (void)setCornerRadius:(CGFloat)cornerRadius;

/** 基于位图返回UIImage*/
- (UIImage *)screenShotImage;

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView
          lineLength:(NSInteger)lineLength
         lineSpacing:(NSInteger)lineSpacing
           lineColor:(UIColor *)lineColor;

/**
 中心位置浮层提示

 @param message 提示的内容
 */
- (void)showCentralToast:(NSString *)message;

/**
 view图层颜色渐变
 
 @param startColor 最上面的颜色
 @param endColor 最下面的颜色
 */
- (void)insertColorGradient:(UIColor *)startColor
                andEndColor:(UIColor *)endColor;

/**
 绘制颜色渐变的layer
 
 @param frame layer的坐标
 @param colors 渐变颜色数组
 @param locations 渐变颜色的区间分布
 */
- (void)insertColorGradientWithFrame:(CGRect )frame
                              colors:(NSArray *)colors
                           locations:(NSArray *)locations;

#pragma mark - 使用.x.y等设置frame
#pragma mark -
/**
 *  注意此处：利用编译器生成了getter 和 setter方法，.m中会复写
 *          不会真实使用以下这些属性
 */
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

//center
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

//left top right bottom
@property (nonatomic, readonly) CGFloat left;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;

- (void)setViewLeft:(CGFloat)x;
- (void)setViewTop:(CGFloat)y;
- (void)setViewWidth:(CGFloat)width;
- (void)setViewHeight:(CGFloat)height;

@end
