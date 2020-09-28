//
//  HCKSystemCell.h
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"
#import "HCKSystemModel.h"

@interface HCKSystemCell : HCKBaseCell

+ (HCKSystemCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)HCKSystemModel *dataModel;

@end
