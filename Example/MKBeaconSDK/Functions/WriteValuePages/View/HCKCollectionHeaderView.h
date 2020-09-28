//
//  HCKCollectionHeaderView.h
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKCollectionHeaderView : UICollectionReusableView

+ (instancetype)headerViewWithCollectionView:(UICollectionView *)collectionView
                                forIndexPath:(NSIndexPath *)indexPath;

@end
