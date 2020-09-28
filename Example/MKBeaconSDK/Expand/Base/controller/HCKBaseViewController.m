//
//  HCKBaseViewController.m
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseViewController.h"

@interface HCKBaseViewController ()<UIGestureRecognizerDelegate>
{
    GYNaviType _naviType;
}
@end

@implementation HCKBaseViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        _naviType = GYNaviTypeShow;
        _isFirstAppear = YES;
    }
    return self;
}

- (instancetype)initWithNavigationType:(GYNaviType)type{
    self = [self init];
    if (self) {
        _naviType = type;
        _isFirstAppear = YES;
    }
    return self;
}
#pragma mark - 更新右侧按钮宽度（jmx/2017/3/16 add）
- (void)updateRightBtnWith:(CGFloat)width
{
    CGRect rect = CGRectMake(kScreenWidth-width, 2.0f, width, 40.0f);
    self.rightButton.frame = rect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_VIEW_COLOR;
    [self setNavigationBarImage:[UIImage imageWithColor:NAVIGATION_BAR_COLOR]];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 7.0f, kScreenWidth-120.0f, 30.0f)];
    _titleLabel.font              = HCKFont(18);
    _titleLabel.textColor         = COLOR_WHITE_MACROS;
    _titleLabel.tintColor         = COLOR_WHITE_MACROS;
    _titleLabel.textAlignment     = NSTextAlignmentCenter;
    _titleLabel.backgroundColor   = COLOR_CLEAR_MACROS;
    self.navigationItem.titleView = _titleLabel;
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 2.0f, 40.0f, 40.0f)];
    [_leftButton setImage:LOADIMAGE(@"navigation_back_button_white",@"png") forState:UIControlStateNormal];
    [_leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_leftButton.titleLabel setFont:HCKFont(16)];
    [_leftButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4] forState:UIControlStateHighlighted];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40.0f, 2.0f, 40.0f, 40.0f)];
    [_rightButton.titleLabel setFont:HCKFont(16)];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:RGBACOLOR(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    
    _rightCorner = [[UIView alloc] initWithFrame:CGRectMake(29.0f, 7.0f, 7.0f, 7.0f)];
    _rightCorner.hidden = YES;
    _rightCorner.clipsToBounds = YES;
    _rightCorner.layer.cornerRadius = 3.5f;
    _rightCorner.backgroundColor = RGBCOLOR(253, 115, 38);
    [_rightButton addSubview:_rightCorner];
    
    [self setRootNavigationTitle:self.title == nil ? [self defaultTitle]:self.title];
    
    if (_naviType == GYNaviTypeHide)
        {
        _customNaviView = [[HCKCustomNaviView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _customNaviView.backgroundColor = COLOR_CLEAR_MACROS;
        
        [_customNaviView.leftButton setImage:LOADIMAGE(@"navigation_back_button_white",@"png")
                                    forState:UIControlStateNormal];
        [_customNaviView.leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_customNaviView.leftButton.titleLabel setFont:HCKFont(16)];
        [_customNaviView.leftButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_customNaviView.leftButton setTitleColor:RGBACOLOR(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
        [_customNaviView.leftButton addTarget:self action:@selector(leftButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        _customNaviView.leftButton.acceptEventInterval = 1.0f;
        [_customNaviView.leftButton setBackgroundColor:COLOR_CLEAR_MACROS];
        
        [_customNaviView.rightButton.titleLabel setFont:HCKFont(16)];
        [_customNaviView.rightButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_customNaviView.rightButton setTitleColor:RGBACOLOR(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
        [_customNaviView.rightButton addTarget:self action:@selector(rightButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        _customNaviView.rightButton.acceptEventInterval = 1.0f;
        [_customNaviView.rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_customNaviView.titleLabel setText:self.title == nil ? [self defaultTitle]:self.title];
        
        [self.view addSubview:_customNaviView];
        }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_naviType == GYNaviTypeShow) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.view bringSubviewToFront:self.customNaviView];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (instancetype)weakSelf{
    __weak __typeof__ (self) wself = self;
    return wself;
}

#pragma mark - custom method
-(void)setRootNavigationTitle:(NSString*)title{
    if (_naviType == GYNaviTypeHide) {
        [self.customNaviView.titleLabel setText:title];
        [self.customNaviView setNeedsLayout];
    }
    else{
        self.titleLabel.text = title;
    }
}

-(void)setNavigationBarImage:(UIImage*)image{
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *image1 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1)];
        [self.navigationController.navigationBar setBackgroundImage:image1 forBarMetrics:UIBarMetricsDefault];
    }
}

-(void)leftButtonMethod{
    if (self.isPrensent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightButtonMethod{
}

- (void)setLeftButton:(UIButton *)leftButton{
    _leftButton = nil;
    _leftButton = leftButton;
    [_leftButton addTarget:self action:@selector(leftButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.acceptEventInterval = 1.0f;
    [_leftButton setNeedsLayout];
    UIBarButtonItem *leftbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    [self.navigationItem setLeftBarButtonItem1:leftbuttonItem];
}

- (void)setRightButton:(UIButton *)rightButton{
    _rightButton = nil;
    _rightButton = rightButton;
    [_rightButton addTarget:self action:@selector(rightButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.acceptEventInterval = 1.0f;
    [rightButton setNeedsLayout];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem1:rightButtonItem];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)defaultTitle{
    return @"";
}

- (void)popToViewControllerWithClassName:(NSString *)className{
    UIViewController *popController = nil;
    
    for (UIViewController *v in self.navigationController.viewControllers) {
        if ([v isKindOfClass:NSClassFromString(className)]) {
            popController = v;
            break;
        }
    }
    
    if (popController) {
        [self.navigationController popToViewController:popController animated:YES];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self isRootViewController]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (BOOL)isRootViewController
{
    return (self == self.navigationController.viewControllers.firstObject);
}

@end


#pragma mark - end

@implementation UINavigationItem (margin)
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem1:(UIBarButtonItem *)_leftBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -5;
    
    if (_leftBarButtonItem)
        {
        [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
        }
    else
        {
        [self setLeftBarButtonItems:@[spaceButtonItem]];
        }
}

- (void)setLeftBarButtonItemsCustom:(NSArray *)leftBarButtonItems
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6.1) {
        spaceButtonItem.width = -20;
    }
    else{
        spaceButtonItem.width = -10;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:leftBarButtonItems];
    
    [mutableArray insertObject:spaceButtonItem atIndex:0];
    
    {
    [self setLeftBarButtonItems:mutableArray];
    }
}

- (void)setRightBarButtonItem1:(UIBarButtonItem *)_rightBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -10;
    
    if (_rightBarButtonItem)
        {
        [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];
        }
    else
        {
        [self setRightBarButtonItems:@[spaceButtonItem]];
        }
}

- (void)setRightBarButtonItemsCustom:(NSArray *)rightBarButtonItems
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6.1) {
        spaceButtonItem.width = -15;
    }
    else{
        spaceButtonItem.width = -10;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:rightBarButtonItems];
    
    [mutableArray insertObject:spaceButtonItem atIndex:0];
    
    {
    [self setRightBarButtonItems:mutableArray];
    }
}

#endif

@end
