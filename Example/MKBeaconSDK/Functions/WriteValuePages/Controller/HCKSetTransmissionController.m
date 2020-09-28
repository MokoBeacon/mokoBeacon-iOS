//
//  HCKSetTransmissionController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetTransmissionController.h"
#import "HCKTransmissionCell.h"
#import "HCKCollectionHeaderView.h"
#import "HCKCollectionFooterView.h"

static NSString *const HCKTransmissionCellIdenty = @"HCKTransmissionCellIdenty";

@interface HCKSetTransmissionController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, assign)NSInteger selectedTransmission;

@end

@implementation HCKSetTransmissionController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSetTransmissionController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setImage:LOADIMAGE(@"setBeaconDataSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self getLocalDatas];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKSetTransmissionController_title");
}

- (void)rightButtonMethod{
    if ([[HCKGlobalBeaconData share].transmission integerValue] == self.selectedTransmission) {
        //不需要修改
        [self leftButtonMethod];
        return;
    }
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface setBeaconTransmission:[self getTransmission] sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [HCKGlobalBeaconData share].transmission = @"";
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
    HCKTransmissionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HCKTransmissionCellIdenty forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (indexPath.row < self.dataList.count) {
        cell.dataModel = self.dataList[indexPath.row];
        WS(weakSelf);
        cell.cellDidSelectedBlock = ^(NSIndexPath *path){
            [weakSelf transmissionSelected:path];
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
        HCKCollectionHeaderView *headerView = [HCKCollectionHeaderView headerViewWithCollectionView:collectionView
                                                forIndexPath:indexPath];
        return headerView;
        
    } else if( [kind isEqualToString:UICollectionElementKindSectionFooter] ) {//底部视图
        //获取底部视图
        HCKCollectionFooterView *footerView =
        [HCKCollectionFooterView footerViewWithCollectionView:collectionView
                                                forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kScreenWidth - 30 - 14) / 3, 65);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth - 2 * 15, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth - 2 * 15, 30);
}

#pragma mark - Private method

- (void)transmissionSelected:(NSIndexPath *)path{
    if (!path || path.row > self.dataList.count) {
        return;
    }
    self.selectedTransmission = path.row;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        HCKTransmissionModel *model = self.dataList[i];
        model.selected = NO;
        if (i == path.row) {
            model.selected = YES;
        }
    }
    [self.collectionView reloadData];
}

- (beaconTransmission)getTransmission{
    if (self.selectedTransmission == 0) {
        return beaconTransmission4dBm;
    }else if (self.selectedTransmission == 1){
        return beaconTransmission0dBm;
    }else if (self.selectedTransmission == 2){
        return beaconTransmissionNeg4dBm;
    }else if (self.selectedTransmission == 3){
        return beaconTransmissionNeg8dBm;
    }else if (self.selectedTransmission == 4){
        return beaconTransmissionNeg12dBm;
    }else if (self.selectedTransmission == 5){
        return beaconTransmissionNeg16dBm;
    }else if (self.selectedTransmission == 6){
        return beaconTransmissionNeg20dBm;
    }else if (self.selectedTransmission == 7){
        return beaconTransmissionNeg40dBm;
    }else if (self.selectedTransmission == 8){
        return beaconTransmissionNeg40dBm;
    }
    return beaconTransmissionNeg12dBm;
}

- (void)getLocalDatas{
    HCKTransmissionModel *sevModel = [[HCKTransmissionModel alloc] init];
    sevModel.title = LS(@"HCKSetTransmissionController_modelTitle1");
    sevModel.power = LS(@"HCKSetTransmissionController_modelValue1");
    sevModel.radius = LS(@"HCKSetTransmissionController_modelRadius1");
    [self.dataList addObject:sevModel];
    
    HCKTransmissionModel *sixModel = [[HCKTransmissionModel alloc] init];
    sixModel.title = LS(@"HCKSetTransmissionController_modelTitle2");
    sixModel.power = LS(@"HCKSetTransmissionController_modelValue2");
    sixModel.radius = LS(@"HCKSetTransmissionController_modelRadius2");
    [self.dataList addObject:sixModel];
    
    HCKTransmissionModel *fiveModel = [[HCKTransmissionModel alloc] init];
    fiveModel.title = LS(@"HCKSetTransmissionController_modelTitle3");
    fiveModel.power = LS(@"HCKSetTransmissionController_modelValue3");
    fiveModel.radius = LS(@"HCKSetTransmissionController_modelRadius3");
    [self.dataList addObject:fiveModel];
    
    HCKTransmissionModel *fourModel = [[HCKTransmissionModel alloc] init];
    fourModel.title = LS(@"HCKSetTransmissionController_modelTitle4");
    fourModel.power = LS(@"HCKSetTransmissionController_modelValue4");
    fourModel.radius = LS(@"HCKSetTransmissionController_modelRadius4");
    [self.dataList addObject:fourModel];
    
    HCKTransmissionModel *threeModel = [[HCKTransmissionModel alloc] init];
    threeModel.title = LS(@"HCKSetTransmissionController_modelTitle5");
    threeModel.power = LS(@"HCKSetTransmissionController_modelValue5");
    threeModel.radius = LS(@"HCKSetTransmissionController_modelRadius5");
    [self.dataList addObject:threeModel];
    
    HCKTransmissionModel *twoModel = [[HCKTransmissionModel alloc] init];
    twoModel.title = LS(@"HCKSetTransmissionController_modelTitle6");
    twoModel.power = LS(@"HCKSetTransmissionController_modelValue6");
    twoModel.radius = LS(@"HCKSetTransmissionController_modelRadius6");
    [self.dataList addObject:twoModel];
    
    HCKTransmissionModel *oneModel = [[HCKTransmissionModel alloc] init];
    oneModel.title = LS(@"HCKSetTransmissionController_modelTitle7");
    oneModel.power = LS(@"HCKSetTransmissionController_modelValue7");
    oneModel.radius = LS(@"HCKSetTransmissionController_modelRadius7");
    [self.dataList addObject:oneModel];
    
//    HCKTransmissionModel *lowestModel = [[HCKTransmissionModel alloc] init];
//    lowestModel.title = LS(@"HCKSetTransmissionController_modelTitle8");
//    lowestModel.power = LS(@"HCKSetTransmissionController_modelValue8");
//    lowestModel.radius = LS(@"HCKSetTransmissionController_modelRadius8");
//    [self.dataList addObject:lowestModel];
    
    HCKTransmissionModel *eightModel = [[HCKTransmissionModel alloc] init];
    eightModel.title = LS(@"HCKSetTransmissionController_modelTitle8");
    eightModel.power = LS(@"HCKSetTransmissionController_modelValue9");
    eightModel.radius = LS(@"HCKSetTransmissionController_modelRadius9");
    [self.dataList addObject:eightModel];
    
    if (ValidStr([HCKGlobalBeaconData share].transmission)) {
        self.selectedTransmission = [[HCKGlobalBeaconData share].transmission integerValue];
        if (self.selectedTransmission == 8) {
            self.selectedTransmission = 7;
        }
        HCKTransmissionModel *tempModel = self.dataList[self.selectedTransmission];
        tempModel.selected = YES;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - setter & getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 7.0f;
        layout.minimumInteritemSpacing = 7.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = COLOR_CLEAR_MACROS;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[HCKTransmissionCell class] forCellWithReuseIdentifier:HCKTransmissionCellIdenty];
        [_collectionView registerClass:[HCKCollectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HCKCollectionHeaderViewIdenty"];
        [_collectionView registerClass:[HCKCollectionFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"HCKCollectionFooterViewIdenty"];
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
