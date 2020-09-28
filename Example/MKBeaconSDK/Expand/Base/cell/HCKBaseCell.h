//
//  HCKBaseCell.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKBaseCell : UITableViewCell

@property (nonatomic, strong)NSIndexPath *indexPath;

+ (CGFloat)getCellHeight;

@end
