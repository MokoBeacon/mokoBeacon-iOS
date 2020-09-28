//
//  HCKTimePickerView.h
//  FitPolo
//
//  Created by aa on 17/5/9.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCKTimerPickerModel.h"

typedef void(^HCKTimePickViewBlock)(HCKTimerPickerModel *timeModel);

@interface HCKTimePickerView : UIView

@property (nonatomic, strong)HCKTimerPickerModel *timeModel;

/**
 显示时间选择器
 
 @param Block 返回选中的时间信息
 */
- (void)showTimePickViewBlock:(HCKTimePickViewBlock)Block;

@end
