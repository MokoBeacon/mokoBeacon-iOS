//
//  HCKSimpleSelectedCell.h
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"
#import "HCKSimpleSelectedModel.h"

@interface HCKSimpleSelectedCell : HCKBaseCell

@property (nonatomic, strong)HCKSimpleSelectedModel *dataModel;

@property (nonatomic, copy)HCKBaseCellSelectedBlock cellSelectedBlock;

/**
 初始化

 */
+ (instancetype)initCellWithTableView:(UITableView *)tableView
                      reuseIdentifier:(NSString *)reuseIdentifier;

@end
