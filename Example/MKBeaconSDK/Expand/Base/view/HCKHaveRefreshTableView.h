//
//  HCKHaveRefreshTableView.h
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseTableView.h"

@class HCKHaveRefreshTableView;

@protocol HCKHaveRefreshTableViewDelegate <NSObject>

@optional
/**
 *  footer开始刷新执行的方法（写刷新逻辑）
 */
- (void)refreshTableView:(HCKHaveRefreshTableView *)tableView footerBeginRefreshing:(UIView *)footView;

/**
 *  header开始刷新执行的方法（写刷新逻辑）
 */
- (void)refreshTableView:(HCKHaveRefreshTableView *)tableView headBeginRefreshing:(UIView *)headView;

@end

typedef NS_ENUM(NSInteger, RequestType){
    REQUEST_REFRESH = 1,    //下拉刷新请求数据
    OPERATE_LOADINGMORE = 2 //上拉加载更多请求数据
};

typedef NS_ENUM(NSUInteger, PLHaveRefreshSourceType){
    PLHaveRefreshSourceTypeAll,     // 默认显示下拉刷新和上拉加载更多
    PLHaveRefreshSourceTypeHeader,  // 只显示下拉刷新
    PLHaveRefreshSourceTypeFooter,  // 只显示上拉加载更多
    PLHaveRefreshSourceTypeNone     // 都不显示
};

@interface HCKHaveRefreshTableView : HCKBaseTableView
{
    @package
    RequestType _requestType;
    NSUInteger  _currentPage;
}

@property (nonatomic,assign)RequestType requestType;
@property (nonatomic,assign)NSUInteger  currentPage;
@property (nonatomic,assign)PLHaveRefreshSourceType sourceType;

// 上拉下拉刷代理
@property (nonatomic,assign)id <HCKHaveRefreshTableViewDelegate>refreshDelegate;

/**
 *  初始化，sourceType:指定显示的内容
 *
 */
- (instancetype)initWithFrame:(CGRect)frame sourceType:(PLHaveRefreshSourceType)sourceType;

/**
 *  停止刷新
 */
- (void)stopRefresh;



#pragma 点击按钮自动开始刷新
/**
 *  footer自动开始刷新执行的方法
 */
- (void)footerAutomaticRefresh;

/**
 *  header自动开始刷新执行的方法
 */
- (void)headerAutomaticRefresh;

@end
