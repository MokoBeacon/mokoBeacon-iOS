//
//  HCKSimpleBaseCell.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"
#import "HCKBaseSimpleModel.h"

@interface HCKSimpleBaseCell : HCKBaseCell

@property (nonatomic, strong)HCKBaseSimpleModel *dataModel;
@property (nonatomic, copy) HCKBaseCellSelectedBlock cellSelectedBlock;

+ (instancetype)initCellWithTableView:(UITableView *)tableView
                      reuseIdentifier:(NSString *)reuseIdentifier;

@end
