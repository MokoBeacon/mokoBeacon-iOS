//
//  HCKRefreshHeader.h
//  FitPolo
//
//  Created by aa on 17/6/17.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HCKRefreshHeaderPressedBlock)(void);

@interface HCKRefreshHeader : UIView

@property (nonatomic, copy)HCKRefreshHeaderPressedBlock pressedBlock;

/**
 设置提示信息
 
 @param contentMsg 当前显示的提示信息
 @param need 是否需要前面的icon,出现错误提示的时候，不需要前面的icon
 */
- (void)setContentMsg:(NSString *)contentMsg
             needIcon:(BOOL)need;

@end
