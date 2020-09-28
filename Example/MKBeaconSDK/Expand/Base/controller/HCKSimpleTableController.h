//
//  HCKSimpleTableController.h
//  FitPolo
//
//  Created by aa on 17/5/9.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseViewController.h"

@interface HCKSimpleTableController : HCKBaseViewController

/**
 通过setter方法设置table的数据源，并且会刷新table
 */
@property (nonatomic, strong)NSArray *dataList;

@end
