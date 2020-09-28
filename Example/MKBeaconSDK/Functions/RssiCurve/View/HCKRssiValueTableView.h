//
//  HCKRssiValueTableView.h
//  HCKBeacon
//
//  Created by aa on 2017/11/18.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HCKRssiTableHiddenBlock)(void);

@interface HCKRssiValueTableView : UIView

@property (nonatomic, strong)NSArray *rssiList;

@property (nonatomic, copy)HCKRssiTableHiddenBlock hiddenBlock;

@end
