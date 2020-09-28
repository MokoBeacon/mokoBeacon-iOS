//
//  HCKBaseSimpleModel.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKBaseSimpleModel : HCKBaseDataModel

/**
 cell左侧显示的信息
 */
@property (nonatomic, copy) NSString *textStr;

/**
 cell右侧显示的信息
 */
@property (nonatomic, copy) NSString *detailStr;

/**
 右侧按钮的图片
 */
@property (nonatomic, copy) NSString *iconName;


@end
