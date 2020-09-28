//
//  HCKSetUUIDController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/1.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetUUIDController.h"
#import "HCKBaseTableView.h"
#import "HCKSetUUIDCell.h"

@interface HCKSetUUIDController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSRegularExpression *uuidRegex;

/**
 当前输入的UUID字符串长度
 */
@property (nonatomic, assign)NSInteger inputLength;

@end

@implementation HCKSetUUIDController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSetUUIDController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setImage:LOADIMAGE(@"setBeaconDataSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadTableViewDatas];
    [self.textField setText:[HCKGlobalBeaconData share].UUID];
    [self.textField setPlaceholder:@"11111111-1111-1111-1111-111111111111"];
    self.inputLength = 0;
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return @"UUID";
}

- (void)rightButtonMethod{
    NSString *uuidString = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger numberOfMatches = [self.uuidRegex numberOfMatchesInString:uuidString
                                                                options:kNilOptions
                                                                  range:NSMakeRange(0, uuidString.length)];
    BOOL uuidStatus = (numberOfMatches > 0);
    if (!uuidStatus) {
        [self.view showCentralToast:@"param error"];
        return;
    }
    
    if ([uuidString isEqualToString:[HCKGlobalBeaconData share].UUID]) {
        //不用修改
        [self leftButtonMethod];
        return;
    }
    
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface setBeaconUUID:uuidString sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [HCKGlobalBeaconData share].UUID = @"";
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
    return 60.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKSetUUIDCell *cell = [HCKSetUUIDCell initCellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.dataModel = self.dataList[indexPath.row];
    WS(weakSelf);
    cell.setUUIDBlock = ^(NSIndexPath *path){
        [weakSelf uuidSelected:path];
    };
    return cell;
}

#pragma mark - Private method

- (void)textValueChanged{
    NSString *tempInputString = [[self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    if (!ValidStr(tempInputString)) {
        self.textField.text = @"";
        self.inputLength = 0;
        return;
    }
    NSString *newInput = [tempInputString substringWithRange:NSMakeRange(tempInputString.length - 1, 1)];
    //只能是字母、数字、下划线
    BOOL correct = ([newInput checkInputIsHexString]);
    NSString *sourceString = (correct ? tempInputString : [tempInputString substringWithRange:NSMakeRange(0, tempInputString.length - 1)]);
    self.textField.text = sourceString;
    //8-4-4-4-12
    if (self.textField.text.length > self.inputLength) {
        if (self.textField.text.length == 9
            || self.textField.text.length == 14
            || self.textField.text.length == 19
            || self.textField.text.length == 24) {//输入
            NSMutableString * str = [[NSMutableString alloc ] initWithString:self.textField.text];
            [str insertString:@"-" atIndex:(self.textField.text.length-1)];
            self.textField.text = str;
        }
        if (self.textField.text.length >= 36) {//输入完成
            self.textField.text = [self.textField.text substringToIndex:36];
            [self.textField resignFirstResponder];
        }
        self.inputLength = self.textField.text.length;
        
    }else if (self.textField.text.length < self.inputLength){//删除
        if (self.textField.text.length == 9
            || self.textField.text.length == 14
            || self.textField.text.length == 19
            || self.textField.text.length == 24) {
            self.textField.text = [self.textField.text substringToIndex:(self.textField.text.length-1)];
        }
        self.inputLength = self.textField.text.length;
    }
    
//    self.textField.text = tempInputString;
}

- (void)uuidSelected:(NSIndexPath *)path{
    if (!path || path.row > self.dataList.count) {
        return ;
    }
    
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        HCKSetUUIDModel *model = self.dataList[i];
        model.selected = NO;
        if (i == path.row) {
            model.selected = YES;
            self.textField.text = model.uuid;
        }
    }
    [self.tableView reloadData];
}

- (void)loadTableViewDatas{
    HCKSetUUIDModel *batteryModel = [[HCKSetUUIDModel alloc] init];
    batteryModel.titleString = @"AirLocate";
    batteryModel.uuid = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
    [self.dataList addObject:batteryModel];
    
    HCKSetUUIDModel *weChatModel = [[HCKSetUUIDModel alloc] init];
    weChatModel.titleString = LS(@"HCKSetUUIDController_wechat");
    weChatModel.uuid = @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825";
    [self.dataList addObject:weChatModel];
    
    HCKSetUUIDModel *weChatModel2 = [[HCKSetUUIDModel alloc] init];
    weChatModel2.titleString = LS(@"HCKSetUUIDController_wechat");
    weChatModel2.uuid = @"AB8190D5-D11E-4941-ACC4-42F30510B408";
    [self.dataList addObject:weChatModel2];
    
    HCKSetUUIDModel *estimoteModel = [[HCKSetUUIDModel alloc] init];
    estimoteModel.titleString = @"Estimote";
    estimoteModel.uuid = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    [self.dataList addObject:estimoteModel];
    
    HCKSetUUIDModel *uuidModel = [[HCKSetUUIDModel alloc] init];
    uuidModel.titleString = @"UUID";
    uuidModel.uuid = [HCKGlobalBeaconData share].UUID;
    uuidModel.selected = YES;
    [self.dataList addObject:uuidModel];
    
    [self.tableView reloadData];
}


#pragma mark - setter & getter
- (HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      kScreenWidth,
                                                                      100)];
        headerView.backgroundColor = RGBCOLOR(242, 242, 242);
        [headerView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.right.mas_equalTo(-15.f);
            make.height.mas_equalTo(30.f);
            make.centerY.mas_equalTo(headerView.mas_centerY);
        }];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.font = HCKFont(14.f);
        _textField.backgroundColor = COLOR_WHITE_MACROS;
        _textField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[@"UUID"] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
        [_textField addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
        
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = COLOR_CLEAR_MACROS.CGColor;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.cornerRadius = 15.f;
    }
    return _textField;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSRegularExpression *)uuidRegex{
    if (!_uuidRegex) {
        NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
        _uuidRegex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];
    }
    return _uuidRegex;
}

@end
