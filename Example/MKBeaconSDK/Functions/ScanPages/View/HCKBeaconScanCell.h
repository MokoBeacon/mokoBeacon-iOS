//
//  HCKBeaconScanCell.h
//  HCKBeacon
//
//  Created by aa on 2017/10/28.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"

@interface HCKBeaconScanCell : HCKBaseCell

+ (HCKBeaconScanCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy)void(^selectedBlock)(HCKBeaconBaseModel *model);

@property (nonatomic, strong)HCKBeaconBaseModel *dataModel;

@end
