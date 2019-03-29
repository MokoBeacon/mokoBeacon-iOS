//
//  HCKBeaconCentralManager.m
//  testSDK
//
//  Created by aa on 2018/5/2.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBeaconCentralManager.h"
#import "HCKBeaconService.h"
#import "HCKBeaconParser.h"
#import "HCKBeaconConnectTimer.h"
#import "HCKBeaconRegularsDefine.h"
#import "CBPeripheral+HCKCharacters.h"
#import "HCKBeaconTaskOperation.h"

typedef NS_ENUM(NSInteger, currentManagerAction) {
    currentManagerActionDefault,
    currentManagerActionScan,
    currentManagerActionConnectPeripheral,
};
static NSTimeInterval const defaultConnectTime = 20.f;
static HCKBeaconCentralManager *manager = nil;
static dispatch_once_t onceToken;

@interface HCKBeaconCentralManager()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong)CBCentralManager *centralManager;

@property (nonatomic, strong)dispatch_queue_t centralManagerQueue;

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, strong)NSOperationQueue *operationQueue;

/**
 当前运行方式
 */
@property (nonatomic, assign)currentManagerAction managerAction;

@property (nonatomic, copy)void (^connectSucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^connectFailBlock)(NSError *error);

@property (nonatomic, strong)HCKBeaconConnectTimer *connectTimer;

@property (nonatomic, assign)HCKBeaconConnectStatus connectStatus;

@property (nonatomic, assign)HCKBeaconCentralManagerState managerState;

/**
 连接是否超时
 */
@property (nonatomic, assign)BOOL connectTimeout;

/**
 当前设备类型
 */
@property (nonatomic, assign)HCKBeaconDeviceType deviceType;

/**
 连接密码
 */
@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL isConnecting;

@end

@implementation HCKBeaconCentralManager

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKBeaconCentralManager销毁");
    
}

//生成唯一的实例
-(instancetype) initUniqueInstance {
    if (self = [super init]) {
        _centralManagerQueue = dispatch_queue_create("centralManagerQueue", DISPATCH_QUEUE_SERIAL);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_centralManagerQueue];
    }
    return self;
}

+ (HCKBeaconCentralManager *)sharedInstance{
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[HCKBeaconCentralManager alloc] initUniqueInstance];
        }
    });
    return manager;
}

+ (void)attempDealloc{
    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
    manager = nil;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    self.managerState = (central.state == CBCentralManagerStatePoweredOn ? HCKBeaconCentralManagerStateEnable : HCKBeaconCentralManagerStateUnable);
    if ([self.stateDelegate respondsToSelector:@selector(centralManagerStateChanged:manager:)]) {
        iBeacon_main_safe(^{
            [self.stateDelegate centralManagerStateChanged:self.managerState manager:manager];
        });
    }
    if (central.state == CBCentralManagerStatePoweredOn) {
        return;
    }
    if (self.managerAction == currentManagerActionDefault) {
        [self cancelConnectedPeripheral];
        return;
    }
    if (self.managerAction == currentManagerActionScan) {
        [self stopScaniBeacon];
        return;
    }
    [self connectPeripheralFailed:NO];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    dispatch_async(_centralManagerQueue, ^{
        HCKBeaconBaseModel *beaconModel = [HCKBeaconParser getiBeaconScanModelWithAdvDic:advertisementData rssi:[RSSI integerValue]];
        if (!beaconModel) {
            return;
        }
        beaconModel.peripheral = peripheral;
        if ([self.scanDelegate respondsToSelector:@selector(centralManagerScanNewDeviceModel:manager:)]) {
            iBeacon_main_safe(^{
                [self.scanDelegate centralManagerScanNewDeviceModel:beaconModel manager:manager];
            });
        }
    });
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:@[]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [self connectPeripheralFailed:NO];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"断开连接");
    [self cancelConnectedPeripheral];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        [self connectPeripheralFailed:NO];
        return;
    }
    for (CBService *service in peripheral.services) {
        //发现服务
        [peripheral discoverCharacteristics:@[] forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        [self connectPeripheralFailed:NO];
        return;
    }
    [self.peripheral updateCharacterWithService:service];
    if ([self.peripheral getAllCharacteristics]) {
        //所有特征全部设置完毕，可以进行下一步登录操作
        [self canSendPasswordToDevice];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        return;
    }
    if ([HCKBeaconParser isThreeAxisAccelerationData:characteristic] && self.deviceType == HCKBeaconDeviceTypeWithXYZData) {
        //判断是否是三轴加速度数据
        if ([self.xyzDelegate respondsToSelector:@selector(receiveThreeAxisAccelerationData:)]) {
            iBeacon_main_safe(^{
                NSDictionary *dic = [HCKBeaconParser getThreeAxisAccelerationData:characteristic];
                [self.xyzDelegate receiveThreeAxisAccelerationData:dic];
            });
        }
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (HCKBeaconTaskOperation *operation in operations) {
            if (operation.executing) {
                [operation peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:NULL];
                break;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (HCKBeaconTaskOperation *operation in operations) {
            if (operation.executing) {
                [operation peripheral:peripheral didWriteValueForCharacteristic:characteristic error:NULL];
                break;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    if (error) {
        return;
    }
    if ([self.rssiValueDelegate respondsToSelector:@selector(HCKBeaconRssiValueChanged:)]) {
        iBeacon_main_safe(^{[self.rssiValueDelegate HCKBeaconRssiValueChanged:RSSI];});
    }
}

#pragma mark - HCKBeaconThreeAxisAccelerationDelegate
- (void)receiveThreeAxisAccelerationData:(NSDictionary *)dic{
    if ([self.xyzDelegate respondsToSelector:@selector(receiveThreeAxisAccelerationData:)]) {
        iBeacon_main_safe(^{[self.xyzDelegate receiveThreeAxisAccelerationData:dic];});
    }
}

#pragma mark - Public method

/**
 开始扫描iBeacon设备
 */
- (void)startScaniBeacons{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        //蓝牙状态不可用
        return;
    }
    self.managerAction = currentManagerActionScan;
    iBeacon_main_safe(^{
        if ([self.scanDelegate respondsToSelector:@selector(centralManagerStartScan:)]) {
            [self.scanDelegate centralManagerStartScan:manager];
        }
    });
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:normalScanService],
                                                          [CBUUID UUIDWithString:xyzDataScanService]]
                                                options:nil];
}

/**
 停止扫描iBeacon设备
 */
- (void)stopScaniBeacon{
    [self.centralManager stopScan];
    self.managerAction = currentManagerActionDefault;
    iBeacon_main_safe(^{
        if ([self.scanDelegate respondsToSelector:@selector(centralManagerStopScan:)]) {
            [self.scanDelegate centralManagerStopScan:manager];
        }
    });
}

/**
 连接设备

 @param device 目标设备
 @param deviceType 设备类型，普通iBeacon设备、带三轴加速度数据iBeacon设备
 @param password 设备连接密码
 @param sucBlock 连接成功回调
 @param failBlock 连接失败回调
 */
- (void)connectDevice:(CBPeripheral *)device
           deviceType:(HCKBeaconDeviceType)deviceType
             password:(NSString *)password
      connectSucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
   connectFailedBlock:(void (^)(NSError *error))failBlock{
    if (self.isConnecting) {
        return;
    }
    self.isConnecting = YES;
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        self.isConnecting = NO;
        [HCKBeaconParser operationCentralBlePowerOffErrorBlock:failBlock];
        return;
    }
    if (!device || ![HCKBeaconParser asciiString:password]) {
        self.isConnecting = NO;
        [HCKBeaconParser operationParametersErrorBlock:failBlock];
        return;
    }
    if (self.peripheral) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        [self.peripheral setNil];
        [self.operationQueue cancelAllOperations];
    }
    self.deviceType = deviceType;
    self.password = nil;
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectDevice:device sucBlock:^(CBPeripheral *peripheral) {
        if (sucBlock) {
            sucBlock(peripheral);
        }
        weakSelf.connectSucBlock = nil;
        weakSelf.connectFailBlock = nil;
    } failedBlock:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
        weakSelf.connectSucBlock = nil;
        weakSelf.connectFailBlock = nil;
    }];
}

/**
 断开当前已经连接或者正在连接的设备
 */
- (void)disconnectConnectedPeripheral{
    self.managerAction = currentManagerActionDefault;
    [self.operationQueue cancelAllOperations];
    [self updatePeripheralConnectState:HCKBeaconConnectStatusDisconnect];
    if (!self.peripheral || self.centralManager.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    [self.centralManager cancelPeripheralConnection:self.peripheral];
    [self.peripheral setNil];
    self.peripheral = nil;
}

/**
 获取当前已连接设备的rssi值
 */
- (void)readCurrentRssiValue{
    if (self.connectStatus != HCKBeaconConnectStatusConnected || !self.peripheral) {
        return;
    }
    [self.peripheral readRSSI];
}

#pragma mark - 数据通信处理方法

/**
 添加一个设置任务(app-->peripheral)到队列
 
 @param operationID 任务ID
 @param resetNum 是否需要由外设返回通信数据总条数
 @param commandData 通信数据
 @param characteristic 通信所使用的特征
 @param successBlock 通信成功回调
 @param failureBlock 通信失败回调
 */
- (void)addTaskWithTaskID:(HCKBeaconTaskOperationID)operationID
                 resetNum:(BOOL)resetNum
              commandData:(NSString *)commandData
           characteristic:(CBCharacteristic *)characteristic
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock{
    HCKBeaconTaskOperation *operation = [self generateOperationWithOperationID:operationID
                                                                      resetNum:resetNum
                                                                   commandData:commandData
                                                                characteristic:characteristic
                                                                  successBlock:successBlock
                                                                  failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
}

/**
 添加一个读取任务(app-->peripheral)到队列
 
 @param operationID 任务ID
 @param resetNum 是否需要由外设返回通信数据总条数
 @param characteristic 通信所使用的特征
 @param successBlock 通信成功回调
 @param failureBlock 通信失败回调
 */
- (void)addReadTaskWithTaskID:(HCKBeaconTaskOperationID)operationID
                     resetNum:(BOOL)resetNum
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock{
    HCKBeaconTaskOperation *operation = [self generateReadOperationWithID:operationID
                                                                 resetNum:resetNum
                                                           characteristic:characteristic
                                                             successBlock:successBlock
                                                             failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
}

#pragma mark - connect result method
- (void)connectDevice:(CBPeripheral *)device sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    self.peripheral = nil;
    self.peripheral = device;
    self.connectSucBlock = nil;
    self.connectSucBlock = sucBlock;
    self.connectFailBlock = nil;
    self.connectFailBlock = failedBlock;
    [self.centralManager stopScan];
    self.managerAction = currentManagerActionConnectPeripheral;
    self.connectStatus = HCKBeaconConnectStatusConnecting;
    if (self.connectTimer) {
        [self.connectTimer cancel];
    }
    self.connectTimer = nil;
    self.connectTimeout = NO;
    HCKBeaconWS(weakSelf);
    HCKBeaconConnectTimer *timer = [[HCKBeaconConnectTimer alloc] initWithTimeout:defaultConnectTime timeoutCallback:^{
        weakSelf.connectTimeout = YES;
        [weakSelf connectPeripheralFailed:NO];
    }];
    self.connectTimer = timer;
    [self.centralManager stopScan];
    [self updatePeripheralConnectState:HCKBeaconConnectStatusConnecting];
    [self.centralManager connectPeripheral:device options:@{}];
    [self.connectTimer resume];
}

- (void)resetOriSettings{
    if (self.connectTimer) {
        [self.connectTimer cancel];
    }
    self.connectTimeout = NO;
    self.connectTimer = nil;
    self.isConnecting = NO;
    self.managerAction = currentManagerActionDefault;
}

- (void)connectPeripheralFailed:(BOOL)isPasswordError{
    [self resetOriSettings];
    if (self.peripheral) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        [self.peripheral setNil];
    }
    self.peripheral = nil;
    [self updatePeripheralConnectState:HCKBeaconConnectStatusConnectedFailed];
    if (isPasswordError) {
        [HCKBeaconParser operationPasswordErrorBlock:self.connectFailBlock];
        return;
    }
    [HCKBeaconParser operationConnectDeviceFailedBlock:self.connectFailBlock];
}

- (void)connectPeripheralSuccess{
    [self resetOriSettings];
    [self updatePeripheralConnectState:HCKBeaconConnectStatusConnected];
    [HCKBeaconParser operationConnectDeviceSuccessBlock:self.connectSucBlock peripheral:self.peripheral];
}

- (void)cancelConnectedPeripheral{
    if (!self.peripheral) {
        return;
    }
    [self updatePeripheralConnectState:HCKBeaconConnectStatusDisconnect];
    [self.centralManager cancelPeripheralConnection:self.peripheral];
    [self.peripheral setNil];
    self.peripheral = nil;
    [self.operationQueue cancelAllOperations];
}

- (void)canSendPasswordToDevice{
    if (self.connectTimeout) {
        //如果处于超时
        return;
    }
    HCKBeaconWS(weakSelf);
    [self connectDeviceWithPassword:self.password sucBlock:^{
        if (weakSelf.connectTimeout) {
            return ;
        }
        [weakSelf connectPeripheralSuccess];
    } failedBlock:^(NSError *error) {
        [weakSelf connectPeripheralFailed:YES];
    }];
}

#pragma mark - communication method
/**
 创建一个设置数据的operation
 
 @param operationID 任务ID
 @param resetNum 是否需要由外设返回通信数据总条数
 @param commandData 要发送的数据
 @param characteristic 发送数据使用的特征
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @return operation
 */
- (HCKBeaconTaskOperation *)generateOperationWithOperationID:(HCKBeaconTaskOperationID)operationID
                                                    resetNum:(BOOL)resetNum
                                                 commandData:(NSString *)commandData
                                              characteristic:(CBCharacteristic *)characteristic
                                                successBlock:(void (^)(id returnData))successBlock
                                                failureBlock:(void (^)(NSError *error))failureBlock{
    if (!self.peripheral || self.connectStatus != HCKBeaconConnectStatusConnected) {
        [HCKBeaconParser operationDisconnectErrorBlock:failureBlock];
        return nil;
    }
    if (!HCKBeaconValidStr(commandData)) {
        [HCKBeaconParser operationParametersErrorBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [HCKBeaconParser operationCharacterErrorBlock:failureBlock];
        return nil;
    }
    HCKBeaconWS(weakSelf);
    HCKBeaconTaskOperation *operation = [[HCKBeaconTaskOperation alloc] initOperationWithID:operationID resetNum:resetNum commandBlock:^{
        [weakSelf sendCommandToPeripheral:commandData characteristic:characteristic];
    } completeBlock:^(NSError *error, HCKBeaconTaskOperationID operationID, id returnData) {
        [weakSelf parseTaskResult:error returnData:returnData successBlock:successBlock failureBlock:failureBlock];
    }];
    return operation;
}

/**
 创建一个读取数据的operation
 
 @param operationID 任务ID
 @param resetNum 是否需要由外设返回通信数据总条数
 @param characteristic 发送数据使用的特征
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @return operation
 */
- (HCKBeaconTaskOperation *)generateReadOperationWithID:(HCKBeaconTaskOperationID)operationID
                                               resetNum:(BOOL)resetNum
                                         characteristic:(CBCharacteristic *)characteristic
                                           successBlock:(void (^)(id returnData))successBlock
                                           failureBlock:(void (^)(NSError *error))failureBlock{
    if (!self.peripheral || self.connectStatus != HCKBeaconConnectStatusConnected) {
        [HCKBeaconParser operationDisconnectErrorBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [HCKBeaconParser operationCharacterErrorBlock:failureBlock];
        return nil;
    }
    HCKBeaconWS(weakSelf);
    HCKBeaconTaskOperation *operation = [[HCKBeaconTaskOperation alloc] initOperationWithID:operationID resetNum:resetNum commandBlock:^{
        [weakSelf.peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError *error, HCKBeaconTaskOperationID operationID, id returnData) {
        [weakSelf parseTaskResult:error returnData:returnData successBlock:successBlock failureBlock:failureBlock];
    }];
    return operation;
}

- (void)parseTaskResult:(NSError *)error
             returnData:(id)returnData
           successBlock:(void (^)(id returnData))successBlock
           failureBlock:(void (^)(NSError *error))failureBlock{
    if (error) {
        iBeacon_main_safe(^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
        return ;
    }
    if (!returnData) {
        [HCKBeaconParser operationRequestDataErrorBlock:failureBlock];
        return ;
    }
    NSString *lev = returnData[HCKBeaconDataStatusLev];
    if ([lev isEqualToString:@"1"]) {
        //通用无附加信息的
        NSArray *dataList = (NSArray *)returnData[HCKBeaconDataInformation];
        if (!HCKBeaconValidArray(dataList)) {
            [HCKBeaconParser operationRequestDataErrorBlock:failureBlock];
            return;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":dataList[0],
                                    };
        iBeacon_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
        return;
    }
    //对于有附加信息的
    if (![lev isEqualToString:@"2"]) {
        //
        return;
    }
    NSDictionary *resultDic = @{@"msg":@"success",
                                @"code":@"1",
                                @"result":returnData[HCKBeaconDataInformation],
                                };
    iBeacon_main_safe(^{
        if (successBlock) {
            successBlock(resultDic);
        }
    });
}

- (void)sendCommandToPeripheral:(NSString *)commandData characteristic:(CBCharacteristic *)characteristic{
    if (!self.peripheral || !HCKBeaconValidStr(commandData) || !characteristic) {
        return;
    }
    NSData *data = [HCKBeaconParser stringToData:commandData];
    if (!HCKBeaconValidData(data)) {
        return;
    }
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)connectDeviceWithPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock{
    if (![HCKBeaconParser asciiString:password]) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandString = [commandString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    HCKBeaconWS(weakSelf);
    HCKBeaconTaskOperation *operation = [[HCKBeaconTaskOperation alloc] initOperationWithID:HCKBeaconSetBeaconPasswordOperation resetNum:NO commandBlock:^{
        [weakSelf sendCommandToPeripheral:commandString characteristic:weakSelf.peripheral.changePassword];
    } completeBlock:^(NSError *error, HCKBeaconTaskOperationID operationID, id returnData) {
        NSString *lev = returnData[HCKBeaconDataStatusLev];
        if ([lev isEqualToString:@"1"]) {
            //通用无附加信息的
            NSArray *dataList = (NSArray *)returnData[HCKBeaconDataInformation];
            if (!HCKBeaconValidArray(dataList)) {
                [HCKBeaconParser operationRequestDataErrorBlock:failedBlock];
                return;
            }
            NSDictionary *resultDic = dataList[0];
            if (![resultDic[@"result"] isEqualToString:@"00"]) {
                //密码错误
                [weakSelf connectPeripheralFailed:YES];
                return;
            }
            iBeacon_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
        }
    }];
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
}

#pragma mark - connect state

- (void)updatePeripheralConnectState:(HCKBeaconConnectStatus)connectStatus{
    self.connectStatus = connectStatus;
    if ([self.stateDelegate respondsToSelector:@selector(peripheralConnectStateChanged:manager:)]) {
        iBeacon_main_safe (^{
            [self.stateDelegate peripheralConnectStateChanged:connectStatus manager:manager];
        });
    }
}

#pragma mark - setter & getter
- (NSOperationQueue *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
