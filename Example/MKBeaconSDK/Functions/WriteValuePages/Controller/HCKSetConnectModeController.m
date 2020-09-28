//
//  HCKSetConnectModeController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetConnectModeController.h"
#import "HCKBaseTableView.h"
#import "HCKSetConnectModeCell.h"

@interface HCKSetConnectModeController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, assign)NSInteger selectedRow;

@end

@implementation HCKSetConnectModeController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSetConnectModeController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setImage:LOADIMAGE(@"setBeaconDataSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
    }];
    [self getLocalDatas];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKSetConnectModeController_title");
}

-(void)rightButtonMethod{
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface setBeaconConnectStatus:(self.selectedRow == 0) sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HCKBaseCell getCellHeight];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKSetConnectModeCell *cell = [HCKSetConnectModeCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.indexPath = indexPath;
    WS(weakSelf);
    cell.connectModeSelectedBlock = ^(NSIndexPath *path){
        [weakSelf setConnectMode:path];
    };
    return cell;
}

#pragma mark - Private method
- (void)setConnectMode:(NSIndexPath *)path{
    if (!path || path.row > self.dataList.count) {
        return ;
    }
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        HCKSimpleSelectedModel *model = self.dataList[i];
        model.selected = NO;
        if (i == path.row) {
            model.selected = YES;
            self.selectedRow = i;
        }
    }
    [self.tableView reloadData];
}

- (void)getLocalDatas{
    HCKSimpleSelectedModel *model1 = [[HCKSimpleSelectedModel alloc] init];
    model1.msgString = @"YES";
    [self.dataList addObject:model1];
    
    HCKSimpleSelectedModel *model2 = [[HCKSimpleSelectedModel alloc] init];
    model2.msgString = @"NO";
    [self.dataList addObject:model2];
    
    if ([HCKGlobalBeaconData share].connectEnable) {
        model1.selected = YES;
        self.selectedRow = 0;
    }else{
        model2.selected = YES;
        self.selectedRow = 1;
    }
    
    [self.tableView reloadData];
}

#pragma mark - setter & getter
- (HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        
        NSString *msg = LS(@"HCKSetConnectModeController_note");
        CGSize size = [NSString sizeWithText:msg
                                     andFont:HCKFont(13)
                                  andMaxSize:CGSizeMake(kScreenWidth - 2 * 15, MAXFLOAT)];
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.textAlignment = NSTextAlignmentLeft;
        msgLabel.textColor = RGBCOLOR(115, 115, 115);
        msgLabel.font = HCKFont(13);
        msgLabel.numberOfLines = 0;
        msgLabel.text = msg;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, size.height + 20)];
        [footerView addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(size.height);
        }];
        
        _tableView.tableFooterView = footerView;
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
