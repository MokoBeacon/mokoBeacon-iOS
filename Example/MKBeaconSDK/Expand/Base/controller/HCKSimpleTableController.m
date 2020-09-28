//
//  HCKSimpleTableController.m
//  FitPolo
//
//  Created by aa on 17/5/9.
//  Copyright © 2017年 HCK. All rights reserved.
//
/*
 本控制器是导航栏+一个table
 */

#import "HCKSimpleTableController.h"
#import "HCKBaseTableView.h"
#import "HCKSimpleSelectedCell.h"
#import "HCKSimpleSelectedModel.h"

static NSString *const HCKSimpleTableControllerCell = @"HCKSimpleTableControllerCell";

@interface HCKSimpleTableController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *tableDataList;

@end

@implementation HCKSimpleTableController

#pragma mark - life circle

- (void)dealloc{
    NSLog(@"HCKSimpleTableController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
}

#pragma mark - 覆盖父类方法

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HCKSimpleSelectedCell getCellHeight];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKSimpleSelectedCell *cell = [HCKSimpleSelectedCell initCellWithTableView:tableView
                                                               reuseIdentifier:HCKSimpleTableControllerCell];
    if (indexPath.row < self.tableDataList.count) {
        cell.dataModel = self.tableDataList[indexPath.row];
        cell.indexPath = indexPath;
        WS(weakSelf);
        cell.cellSelectedBlock = ^(NSIndexPath *path, BOOL selected){
            [weakSelf cellSelected:path
                          selected:selected];
        };
    }
    return cell;
}

#pragma mark - Private Method

/**
 cell的点击事件
 
 @param path cell所在的path
 @param selected YES选中，NO未选中
 */
- (void)cellSelected:(NSIndexPath *)path
            selected:(BOOL)selected{
    
}

#pragma mark - Public Method
- (void)setDataList:(NSArray *)dataList{
    if (!ValidArray(dataList)) {
        return;
    }
    [self.tableDataList removeAllObjects];
    [self.tableDataList addObjectsFromArray:dataList];
    [self.tableView reloadData];
}

#pragma mark - setter & getter
- (HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero
                                                       style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)tableDataList{
    if (!_tableDataList) {
        _tableDataList = [NSMutableArray array];
    }
    return _tableDataList;
}

@end
