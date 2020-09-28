//
//  HCKConfigPageCell.h
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"
#import "HCKConfigPageModel.h"

@interface HCKConfigPageCell : HCKBaseCell

+ (HCKConfigPageCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)HCKConfigPageModel *dataModel;

@end
