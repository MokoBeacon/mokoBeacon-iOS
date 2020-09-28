
/*
 与iBeacon服务特征相关的定义
 */

#pragma mark - 扫描过滤服务
//通用的不带三轴加速度数据的扫描服务
static NSString *const normalScanService = @"FF00";
//带三轴加速度数据的扫描服务
static NSString *const xyzDataScanService = @"FF01";

#pragma mark - 数据服务

#pragma mark - 通用数据服务,FF00
static NSString *const normalConfigService = @"FF00";

/******************FF00服务包含的特征****************/
static NSString *const iBeaconUUID = @"FF01";
static NSString *const iBeaconMajor = @"FF02";
static NSString *const iBeaconMinor = @"FF03";
static NSString *const iBeaconMeasurePower = @"FF04";
static NSString *const iBeaconTransmission = @"FF05";
static NSString *const iBeaconChangePassword = @"FF06";
static NSString *const iBeaconBroadcastInterval = @"FF07";
static NSString *const iBeaconDeviceID = @"FF08";
static NSString *const iBeaconDeviceName = @"FF09";
static NSString *const iBeaconMacAddress = @"FF0C";
static NSString *const iBeaconConnectMode = @"FF0E";
static NSString *const iBeaconSoftReboot = @"FF0F";
static NSString *const iBeaconHeartBeat = @"FF10";
static NSString *const iBeaconElapsedTime = @"FFE0";

#pragma mark - 电池服务,180F
static NSString *const batteryService = @"180F";

/*******************180F服务包含的特征*****************/
static NSString *const iBeaconBattery = @"2A19";

#pragma mark - 系统信息,180A
static NSString *const systemService = @"180A";

/*****************180A服务包含的特征**************/
static NSString *const iBeaconVendor = @"2A29";
static NSString *const iBeaconModeID = @"2A24";
static NSString *const iBeaconProductionDate = @"2A25";
static NSString *const iBeaconFirmware = @"2A26";
static NSString *const iBeaconHardware = @"2A27";
static NSString *const iBeaconSoftware = @"2A28";
static NSString *const iBeaconSystemID = @"2A23";
static NSString *const iBeaconIEEEInfo = @"2A2A";

#pragma mark - dfu,00001530-1212-EFDE-1523-785FEABCD123
static NSString *const dfuService = @"00001530-1212-EFDE-1523-785FEABCD123";

/*******************dfu服务包含的特征*****************/
static NSString *const iBeaconDFU = @"00001531-1212-EFDE-1523-785FEABCD123";

