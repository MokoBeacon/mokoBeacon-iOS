


/**
 头文件说明：
 1、与设备有关的宏定义
 */
#pragma mark - *************************  block弱引用强引用  *************************
//弱引用对象
#define WS(weakSelf)          __weak __typeof(&*self)weakSelf = self;
#define StrongSelf(weakSelf)  __strong __typeof(self) = weakSelf





#pragma mark - *************************  硬件相关  *************************
/** 获取屏幕尺寸、宽度、高度 */
#define kScreenRect                 ([[UIScreen mainScreen] bounds])            //屏幕frame
#define kScreenSize                 ([UIScreen mainScreen].bounds.size)         //屏幕size
#define kScreenWidth                ([UIScreen mainScreen].bounds.size.width)   //屏幕宽度
#define kScreenHeight               ([UIScreen mainScreen].bounds.size.height)  //屏幕高度
#define kScreenScale                ([[UIScreen mainScreen] scale])             //缩放系数
#define kScreenCurrModeSize         [[UIScreen mainScreen] currentMode].size    //currentModel的size

#define kScreenMaxLength            (MAX(kScreenWidth, kScreenHeight))          //获取屏幕宽高最大者
#define kScreenMinLength            (MIN(kScreenWidth, kScreenHeight))          //获取屏幕宽高最小者

#define isIPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    //是否是ipad设备
#define isIPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  //是否是iPhone设备
#define isRetina                    (kScreenScale >= 2.0)                                     //是否是retina屏幕

//是否是垂直
#define isPortrait                  ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

//UIScreen是否响应currentMode方法
#define isRespondCurrModel          [UIScreen instancesRespondToSelector:@selector(currentMode)]
#define isEqualToCurrModelSize(w,h) CGSizeEqualToSize(CGSizeMake(w,h), kScreenCurrModeSize)

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4                     (isRespondCurrModel ? isEqualToCurrModelSize(640,960) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5                     (isRespondCurrModel ? isEqualToCurrModelSize(640,1136) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6                     (isRespondCurrModel ? isEqualToCurrModelSize(750, 1334) || isEqualToCurrModelSize(640, 1136) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6Plus                 (isRespondCurrModel ? isEqualToCurrModelSize(1125, 2001) || isEqualToCurrModelSize(1242, 2208) : NO)

#define iPhone6PlusZoom             (isRespondCurrModel ? isEqualToCurrModelSize(1125, 2001) : NO)

//自动调整x、y比例
#define AutoSizeScaleForX (kScreenWidth > 480 ? kScreenWidth/320 : 1.0)
#define AutoSizeScaleForY (kScreenHeight > 480 ? kScreenHeight/568 : 1.0)

#pragma mark - *************************  系统相关  *************************
//delegate对象//AppWindow
#define kAppDelegate            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kAppWindow              ([UIApplication sharedApplication].keyWindow)

/** 获取系统版本 */
#define kSystemVersionString    ([[UIDevice currentDevice] systemVersion])
#define kSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])

/** 获取APP名称 */
#define kAppName                ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
/** 获取APP版本 */
#define kAppVersion             ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
/** 获取APP build版本 */
#define kAppBuildVersion        ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

/** 是否为iOS6、7、8、9、10系统 */
#define iOS6                    ((kSystemVersion >= 6.0) ? YES : NO)
#define iOS7                    ((kSystemVersion >= 7.0) ? YES : NO)
#define iOS8                    ((kSystemVersion >= 8.0) ? YES : NO)
#define iOS9                    ((kSystemVersion >= 9.0) ? YES : NO)
#define iOS10                   ((kSystemVersion >= 10.0) ? YES : NO)



#pragma mark - *************************  本地文档相关  *************************
/** 获取Documents目录 */
#define kDocumentsPath          ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject])

/** 获得Documents下指定文件名的文件路径 */
#define kFilePath(filename)     ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename])

/** 获取Library目录 */
#define kLibraryPath            ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject])

/** 获取Caches目录 */
#define kCachesPath             ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject])

/** 获取Tmp目录 */
#define kTmpPath                 NSTemporaryDirectory()






#pragma mark - **************************  华创恒达APP通用设置宏定义  *********************************
//TODO:备注说明：所有新项目使用kScreenWidth和kScreenHeight，以下两个是兼容旧项目
#define SCREEN_WIDTH        (kScreenWidth)
#define SCREEN_HEIGHT       (kScreenHeight)


