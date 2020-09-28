//
//  HCKSimpleSelectedModel.h
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKSimpleSelectedModel : HCKBaseDataModel

/**
 要显示的msg
 */
@property (nonatomic, copy)NSString *msgString;

/**
 选中状态，YES选中状态，NO未选中状态
 */
@property (nonatomic, assign)BOOL selected;

/**
 类名
 */
@property (nonatomic, assign)Class destVC;

@end
