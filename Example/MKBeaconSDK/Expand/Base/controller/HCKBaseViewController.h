//
//  HCKBaseViewController.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCKCustomNaviView.h"

typedef  NS_ENUM(NSUInteger, GYNaviType){
    /**
     *  显示自带的NavigationBar
     */
    GYNaviTypeShow,
    /**
     *  隐藏自带的NavigationBar
     */
    GYNaviTypeHide
};

@interface HCKBaseViewController : UIViewController

/**
 *  标题label
 */
@property(nonatomic,strong) UILabel            *titleLabel;
/**
 *  左按钮
 */
@property(nonatomic,strong) UIButton           *leftButton;
/**
 *  右按钮
 */
@property(nonatomic,strong) UIButton           *rightButton;
/**
 *  右按钮上面的角标
 */
@property(nonatomic,strong) UIView             *rightCorner;
/**
 *  是否首次进入页面
 */
@property(nonatomic,assign) BOOL               isFirstAppear;
/**
 *  naviType == GYNaviTypeHide 时有效
 */
@property (nonatomic,strong)HCKCustomNaviView  *customNaviView;
/**
 *  PLBaseViewController对象
 */
@property(nonatomic,readonly,weak)UIViewController *weakSelf;

/**
 *  controlle是否是 经过 presentViewController:animated:completion: 推出来，默认为NO
 */
@property (nonatomic,assign) BOOL               isPrensent;

/**
 *  设置标题
 *
 *  @return 标题
 */
- (NSString *)defaultTitle;

/**
 初始化方法
 
 @param type GYNaviType
 
 */
- (instancetype)initWithNavigationType:(GYNaviType)type;

/**
 *  设置首级导航栏标题
 *
 *  @param title 标题
 */
-(void)setRootNavigationTitle:(NSString*)title;

/**
 *  设置导航栏背景颜色
 *
 *  @param image 图片
 */
-(void)setNavigationBarImage:(UIImage*)image;

/**
 *  左按钮方法
 */
-(void)leftButtonMethod;

/**
 *  右按钮方法
 */
-(void)rightButtonMethod;

/**
 更新右侧按钮宽度
 
 @param width 宽度
 */
- (void)updateRightBtnWith:(CGFloat)width;

/**
 *  判断当前显示的是否是本控制器
 *
 *  @param viewController 控制器类
 *
 *  @return YES NO
 */
+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;

- (void)popToViewControllerWithClassName:(NSString *)className;

@end

@interface UINavigationItem (margin)

- (void)setLeftBarButtonItem1:(UIBarButtonItem *)_leftBarButtonItem;
- (void)setRightBarButtonItem1:(UIBarButtonItem *)_rightBarButtonItem;
- (void)setLeftBarButtonItemsCustom:(NSArray *)leftBarButtonItems;
- (void)setRightBarButtonItemsCustom:(NSArray *)rightBarButtonItems;

@end


@protocol CWFunctionIntroductionDelegate <NSObject>



@end
