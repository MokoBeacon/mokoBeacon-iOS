
typedef NS_ENUM(NSInteger, HCKBeaconTaskOperationID) {
    HCKBeaconTaskDefaultOperation,
#pragma mark - read
    HCKBeaconReadUUIDOperation,             //读取UUID
    HCKBeaconReadMajorOperation,            //读取major
    HCKBeaconReadMinorOperation,            //读取minor
    HCKBeaconReadMeasurePowerOperation,     //读取校验距离
    HCKBeaconReadTransmissionOperation,     //读取广播功率
    HCKBeaconReadBroadcastIntervalOperation,//读取广播周期
    HCKBeaconReadDeviceIDOperation,         //读取设备ID
    HCKBeaconReadDeviceNameOperation,       //读取设备名称
    HCKBeaconReadMacAddressOperation,       //读取mac地址
    HCKBeaconReadConnectStatusOperation,    //读取可连接状态
    HCKBeaconReadElapsedTimeOperation,      //读取运行时间
    HCKBeaconReadHardwareModuleOperation,   //读取芯片类型
    HCKBeaconStartReadXYZDataOperation,     //读取三轴加速度数据
    HCKBeaconStopReadXYZDataOperation,      //停止读取三轴加速度数据
    HCKBeaconReadBatteryOperation,          //读取电池电量
    HCKBeaconReadSystemIDOperation,         //读取系统标示
    HCKBeaconReadModeIDOperation,           //读取产品型号
    HCKBeaconReadProductionDateOperation,   //读取生产日期
    HCKBeaconReadFirmwareOperation,         //读取固件信息
    HCKBeaconReadHardwareOperation,         //读取硬件版本
    HCKBeaconReadSoftwareOperation,         //读取软件版本
    HCKBeaconReadVendorOperation,           //读取厂商信息
    HCKBeaconReadIEEEInfoOperation,         //读取IEEE标准
    
#pragma mark - set
    HCKBeaconHeartBeatOperation,            //心跳包
    HCKBeaconSetBeaconUUIDOperation,        //设置iBeacon的UUID
    HCKBeaconSetBeaconMajorOperation,       //设置iBeacon的major
    HCKBeaconSetBeaconMinorOperation,       //设置iBeacon的minor
    HCKBeaconSetBeaconMeasurePowerOperation,//设置iBeacon的MeasurePower
    HCKBeaconSetBeaconTransmissionOperation,//设置iBeacon的广播功率
    HCKBeaconSetBeaconPasswordOperation,    //设置iBeacon的密码
    HCKBeaconSetBeaconBroadcastIntervalOperation,  //设置广播周期
    HCKBeaconSetBeaconDeviceIDOperation,    //设置device id
    HCKBeaconSetBeaconNameOperation,        //设置iBeacon的名字
    HCKBeaconSetBeaconConnectModeOperation, //设置iBeacon的可连接状态
    HCKBeaconSetBeaconPowerOffOperation,    //关机
};
