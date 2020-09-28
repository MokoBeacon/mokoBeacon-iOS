//
//  HCKRssiValueTableView.m
//  HCKBeacon
//
//  Created by aa on 2017/11/18.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKRssiValueTableView.h"
#import "HCKBaseTableView.h"
#import "HCKSimpleBaseCell.h"

static CGFloat const offset_X = 30.f;

static NSString *const HCKSimpleBaseCellIdenty = @"HCKSimpleBaseCellIdenty";

@interface HCKRssiValueTableView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation HCKRssiValueTableView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.tableView];
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        [self addTapAction:self selector:@selector(hiddenTableView)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(50.f);
        make.bottom.mas_equalTo(-30.f);
    }];
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HCKBaseCell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKSimpleBaseCell *cell = [HCKSimpleBaseCell initCellWithTableView:tableView reuseIdentifier:HCKSimpleBaseCellIdenty];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - Private method
- (void)hiddenTableView{
    if (self.hiddenBlock) {
        self.hiddenBlock();
    }
}

#pragma mark - Public method
- (void)setRssiList:(NSArray *)rssiList{
    _rssiList = nil;
    _rssiList = rssiList;
    if (!ValidArray(_rssiList)) {
        return;
    }
    [self.dataList removeAllObjects];
    NSInteger totalValue = 0;
    for (NSInteger i = 0; i < _rssiList.count; i ++) {
        NSNumber *rssi = _rssiList[i];
        HCKBaseSimpleModel *model = [[HCKBaseSimpleModel alloc] init];
        model.textStr = stringFromInteger(i);
        model.detailStr = stringFromInteger([rssi integerValue]);
        [self.dataList addObject:model];
        totalValue += abs([rssi intValue]);
    }
    HCKBaseSimpleModel *tempModel = [[HCKBaseSimpleModel alloc] init];
    tempModel.textStr = @"Avg:";
    tempModel.detailStr = [@"-" stringByAppendingString:stringFromInteger(totalValue / _rssiList.count)];
    [self.dataList addObject:tempModel];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:
     [NSIndexPath indexPathForRow:[self.dataList count]-1 inSection:0]
                          atScrollPosition: UITableViewScrollPositionBottom
                                  animated:NO];
}

#pragma mark - setter & getter
- (HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
