//
//  HCKDfuController.m
//  HCKBeacon
//
//  Created by aa on 2018/5/10.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKDfuController.h"
#import "HCKBaseTableView.h"
#import "HCKDfuAdopter.h"
#import "HCKBaseCell.h"

static NSString *const HCKDfuControllerCellIdenty = @"HCKDfuControllerCellIdenty";

@interface HCKDfuController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)HCKDfuAdopter *adopter;

@end

@implementation HCKDfuController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKDfuController销毁");
    [self.adopter cancel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self getDatasFromSource];
    WS(weakSelf);
    [self.adopter startMonitoringDirectory:^{
        [weakSelf getDatasFromSource];
    }];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return @"DFU";
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = self.dataList[indexPath.row];
    WS(weakSelf);
    self.leftButton.enabled = NO;
    [self.adopter dfuUpdateWithFileName:name target:weakSelf];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKDfuControllerCellIdenty];
    if (!cell) {
        cell = [[HCKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKDfuControllerCellIdenty];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

#pragma mark -
- (void)getDatasFromSource{
    NSArray *list = [self.adopter getDfuFilesList];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:list];
    [self.tableView reloadData];
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

- (HCKDfuAdopter *)adopter{
    if (!_adopter) {
        _adopter = [[HCKDfuAdopter alloc] init];
    }
    return _adopter;
}

@end

