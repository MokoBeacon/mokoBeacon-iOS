//
//  HCKBroadcastCycleFooterView.h
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKBroadcastCycleFooterView : UICollectionReusableView

/* 获取底部视图对象 */
+ (instancetype)footerViewWithCollectionView:(UICollectionView *)collectionView
                                forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy)void(^inputBroadcastCycleBlock)(NSString *cycle);

@property (nonatomic, copy)NSString *textValue;

@end
