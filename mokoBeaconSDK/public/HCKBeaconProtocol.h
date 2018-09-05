
typedef NS_ENUM(NSInteger, HCKBeaconConnectStatus) {
    HCKBeaconConnectStatusUnknow,                                           //未知状态
    HCKBeaconConnectStatusConnecting,                                       //正在连接
    HCKBeaconConnectStatusConnected,                                        //连接成功
    HCKBeaconConnectStatusConnectedFailed,                                  //连接失败
    HCKBeaconConnectStatusDisconnect,                                       //连接断开
};

typedef NS_ENUM(NSInteger, HCKBeaconCentralManagerState) {
    HCKBeaconCentralManagerStateEnable,                           //可用状态
    HCKBeaconCentralManagerStateUnable,                           //不可用
};

@class HCKBeaconBaseModel;
@class HCKBeaconCentralManager;

@protocol HCKCentralScanDelegate <NSObject>
@required
/**
 扫描到新的设备
 
 @param beaconModel 设备model
 */
- (void)centralManagerScanNewDeviceModel:(HCKBeaconBaseModel *)beaconModel manager:(HCKBeaconCentralManager *)manager;
@optional
/**
 中心开始扫描设备
 */
- (void)centralManagerStartScan:(HCKBeaconCentralManager *)manager;

/**
 停止扫描，注意，开始连接设备的时候，会停止扫描，并且不会触发该方法
 */
- (void)centralManagerStopScan:(HCKBeaconCentralManager *)manager;

@end

@protocol HCKCentralStatesChangedDelegate <NSObject>
@required
- (void)centralManagerStateChanged:(HCKBeaconCentralManagerState)managerState manager:(HCKBeaconCentralManager *)manager;
- (void)peripheralConnectStateChanged:(HCKBeaconConnectStatus)connectState manager:(HCKBeaconCentralManager *)manager;

@end

@protocol HCKBeaconThreeAxisAccelerationDelegate <NSObject>
@required
/**
 接收到三轴加速度数据
 */
- (void)receiveThreeAxisAccelerationData:(NSDictionary *)dic;

@end

@protocol HCKBeaconRssiValueChangedDelegate <NSObject>
@required
/**
 当前已经连接的外设rssi值改变

 @param rssi 当前rssi
 */
- (void)HCKBeaconRssiValueChanged:(NSNumber *)rssi;

@end
