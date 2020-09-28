//
//  HCKSetConnectModeCell.h
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"
#import "HCKSimpleSelectedModel.h"

@interface HCKSetConnectModeCell : HCKBaseCell

+ (HCKSetConnectModeCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)HCKSimpleSelectedModel *dataModel;

@property (nonatomic, copy)void(^connectModeSelectedBlock)(NSIndexPath *indexPath);

@end
