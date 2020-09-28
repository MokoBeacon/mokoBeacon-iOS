//
//  HCKSetBroadcastCycleController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetBroadcastCycleController.h"
#import "HCKBroadcastCycleCell.h"
#import "HCKBroadcastCycleHeaderView.h"
#import "HCKBroadcastCycleFooterView.h"

static NSString *const HCKBroadcastCycleCellIdenty = @"HCKBroadcastCycleCellIdenty";

@interface HCKSetBroadcastCycleController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, copy)NSString *cycle;

@property (nonatomic, strong)HCKBroadcastCycleFooterView *footerView;

@end

@implementation HCKSetBroadcastCycleController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSetBroadcastCycleController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setImage:LOADIMAGE(@"setBeaconDataSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self getLocalDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKSetBroadcastCycleController_title");
}

- (void)rightButtonMethod{
    if (!ValidStr(self.cycle) || ![self.cycle isRealNumbers]) {
        [self.view showCentralToast:LS(@"HCKSetBroadcastCycleController_error")];
        return;
    }
    if ([self.cycle integerValue] > 100 || [self.cycle integerValue] < 1) {
        [self.view showCentralToast:LS(@"HCKSetBroadcastCycleController_rangeError")];
        return;
    }
    
    if ([self.cycle isEqualToString:[HCKGlobalBeaconData share].broadcastInterval]) {
        [self leftButtonMethod];
        return;
    }
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface setBeaconBroadcastInterval:[self.cycle integerValue] sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [HCKGlobalBeaconData share].broadcastInterval = @"";
        [weakSelf.view showCentralToast:@"success"];
        [weakSelf performSelector:@selector(leftButtonMethod)
                       withObject:nil
                       afterDelay:0.5];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 代理方法
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HCKBroadcastCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HCKBroadcastCycleCellIdenty forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (indexPath.row < self.dataList.count) {
        cell.dataModel = self.dataList[indexPath.row];
        WS(weakSelf);
        cell.cellDidSelectedBlock = ^(NSIndexPath *path){
            [weakSelf broadcastCycleSelected:path];
        };
    }
    return cell;
}

/* 设置顶部视图和底部视图 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ( [kind isEqualToString:UICollectionElementKindSectionHeader] ) {//顶部视图
        //获取顶部视图
        HCKBroadcastCycleHeaderView *headerView = [HCKBroadcastCycleHeaderView headerViewWithCollectionView:collectionView
                                                                                               forIndexPath:indexPath];
        return headerView;
        
    } else if( [kind isEqualToString:UICollectionElementKindSectionFooter] ) {//底部视图
        //获取底部视图
        HCKBroadcastCycleFooterView *footerView =[HCKBroadcastCycleFooterView footerViewWithCollectionView:collectionView
                                                                                              forIndexPath:indexPath];
        self.footerView = footerView;
        WS(weakSelf);
        footerView.inputBroadcastCycleBlock = ^(NSString *cycle){
            weakSelf.cycle = cycle;
        };
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kScreenWidth - 80 - 46) / 3, 40);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth - 2 * 15, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth - 2 * 15, 140);
}

#pragma mark - Private method
- (void)broadcastCycleSelected:(NSIndexPath *)path{
    if (!path || path.row > self.dataList.count) {
        return;
    }
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        HCKBroadcastCycleModel *model = self.dataList[i];
        model.selected = NO;
        if (i == path.row) {
            model.selected = YES;
            self.cycle = [model.title stringByReplacingOccurrencesOfString:@"00ms" withString:@""];
            //底部输入框单位是100ms
            [self.footerView setTextValue:self.cycle];
        }
    }
    [self.collectionView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    CGFloat height = keyboardRect.size.height;
    [self.collectionView setContentOffset:CGPointMake(0, 100) animated:YES];
}

- (void)keyboardWillHidden:(NSNotification *)notification{
    [self.collectionView setContentOffset:CGPointZero animated:YES];
}

- (void)getLocalDatas{
    HCKBroadcastCycleModel *model1 = [[HCKBroadcastCycleModel alloc] init];
    model1.title = @"100ms";
    [self.dataList addObject:model1];
    
    HCKBroadcastCycleModel *model2 = [[HCKBroadcastCycleModel alloc] init];
    model2.title = @"200ms";
    [self.dataList addObject:model2];
    
    HCKBroadcastCycleModel *model3 = [[HCKBroadcastCycleModel alloc] init];
    model3.title = @"300ms";
    [self.dataList addObject:model3];
    
    HCKBroadcastCycleModel *model4 = [[HCKBroadcastCycleModel alloc] init];
    model4.title = @"400ms";
    [self.dataList addObject:model4];
    
    HCKBroadcastCycleModel *model5 = [[HCKBroadcastCycleModel alloc] init];
    model5.title = @"500ms";
    [self.dataList addObject:model5];
    
    HCKBroadcastCycleModel *model6 = [[HCKBroadcastCycleModel alloc] init];
    model6.title = @"600ms";
    [self.dataList addObject:model6];
    
    HCKBroadcastCycleModel *model7 = [[HCKBroadcastCycleModel alloc] init];
    model7.title = @"700ms";
    [self.dataList addObject:model7];
    
    HCKBroadcastCycleModel *model8 = [[HCKBroadcastCycleModel alloc] init];
    model8.title = @"800ms";
    [self.dataList addObject:model8];
    
    HCKBroadcastCycleModel *model9 = [[HCKBroadcastCycleModel alloc] init];
    model9.title = @"900ms";
    [self.dataList addObject:model9];
    
    HCKBroadcastCycleModel *model10 = [[HCKBroadcastCycleModel alloc] init];
    model10.title = @"1000ms";
    [self.dataList addObject:model10];
    
    if (ValidStr([HCKGlobalBeaconData share].broadcastInterval) && ([[HCKGlobalBeaconData share].broadcastInterval integerValue] - 1) < self.dataList.count) {
        HCKBroadcastCycleModel *tempModel = self.dataList[[[HCKGlobalBeaconData share].broadcastInterval integerValue] - 1];
        tempModel.selected = YES;
    }
    self.cycle = [HCKGlobalBeaconData share].broadcastInterval;
    
    [self.collectionView reloadData];
}

#pragma mark - setter & getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 23.0f;
        layout.minimumInteritemSpacing = 16.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = COLOR_CLEAR_MACROS;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[HCKBroadcastCycleHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HCKBroadcastCycleHeaderViewIdenty"];
        [_collectionView registerClass:[HCKBroadcastCycleFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"HCKBroadcastCycleFooterViewIdenty"];
        
        [_collectionView registerClass:[HCKBroadcastCycleCell class]
            forCellWithReuseIdentifier:HCKBroadcastCycleCellIdenty];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
