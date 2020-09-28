
/*
    cell编辑代理,目前只支持删除功能。
 */

@protocol HCKCellEditDelegate <NSObject>

@optional

/**
 cell被点击了
 
 @param path cell所在path
 */
- (void)cellSelected:(NSIndexPath *)path;

/**
 删除
 
 @param path 要删除的cell所在path
 */
- (void)cellDeleteButtonPressed:(NSIndexPath *)path;

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)cellResetFrame;

@end
