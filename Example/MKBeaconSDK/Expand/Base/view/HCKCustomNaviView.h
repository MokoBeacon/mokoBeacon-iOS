//
//  HCKCustomNaviView.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKCustomNaviView : UIView

/**
 *  标题label
 */
@property(nonatomic,strong)UILabel  *titleLabel;
/**
 *  左按钮
 */
@property(nonatomic,strong)UIButton *leftButton;
/**
 *  右按钮
 */
@property(nonatomic,strong)UIButton *rightButton;
/**
 *  右按钮上面的角标
 */
@property(nonatomic,strong)UIView   *rightCorner;

@end
