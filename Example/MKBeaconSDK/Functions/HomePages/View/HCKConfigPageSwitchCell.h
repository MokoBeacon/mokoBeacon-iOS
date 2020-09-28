//
//  HCKConfigPageSwitchCell.h
//  HCKBeacon
//
//  Created by aa on 2019/3/19.
//  Copyright © 2019 HCK. All rights reserved.
//

#import "HCKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HCKConfigSwitchCellDelegate <NSObject>

- (void)switchStateChanged:(BOOL)isOn row:(NSInteger)row;

@end

@interface HCKConfigPageSwitchCellModel : NSObject

@property (nonatomic, copy)NSString *function;

@property (nonatomic, assign)BOOL isOn;

@end

@interface HCKConfigPageSwitchCell : HCKBaseCell

@property (nonatomic, strong)HCKConfigPageSwitchCellModel *dataModel;

@property (nonatomic, weak)id <HCKConfigSwitchCellDelegate>delegate;

+ (HCKConfigPageSwitchCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
