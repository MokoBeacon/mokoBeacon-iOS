//
//  HCKTransmissionCell.h
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCKTransmissionModel.h"

@interface HCKTransmissionCell : UICollectionViewCell

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, strong)HCKTransmissionModel *dataModel;

@property (nonatomic, copy)void(^cellDidSelectedBlock)(NSIndexPath *path);

@end
