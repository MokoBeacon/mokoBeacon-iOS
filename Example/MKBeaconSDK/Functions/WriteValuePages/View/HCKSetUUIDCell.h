//
//  HCKSetUUIDCell.h
//  HCKBeacon
//
//  Created by aa on 2017/11/1.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"
#import "HCKSetUUIDModel.h"

@interface HCKSetUUIDCell : HCKBaseCell

+ (HCKSetUUIDCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)HCKSetUUIDModel *dataModel;

@property (nonatomic, copy)void(^setUUIDBlock)(NSIndexPath *path);

@end
