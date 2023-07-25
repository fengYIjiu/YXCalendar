//
//  UITableView+refresh.h
//  BFWallet
//
//  Created by floyd on 2018/1/6.
//  Copyright © 2018年 gongjice. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^voidBlock)(void);

@interface UITableView (refresh)

/**
 下拉刷新的block，实现了才能执行下拉刷新。
 */
@property (nonatomic, copy) voidBlock refreshBlock;

/**
 上拉加载的block，实现了才能执行上拉加载
 */
@property (nonatomic, copy) voidBlock loadBlock;

- (void)setwhiteHeader;

/**
 手动进行下拉刷新
 */
- (void)startRefresh;

/**
 手动刷新的动画
 */
- (void)endRefresh;

/**
允许上拉
 */
- (void)enableLoadMore;

/**
禁止上拉
 */
- (void)disableLoadMore;

/**
 允许下拉
 */
- (void)enableRefresh;

/**
 禁止下拉
 */
- (void)disableRefresh;


/**
 刷新国际化语言
 */
- (void)refreshLanguage;


/**
暂无数据
 */
- (void)endLoadDataWithNoMoreData;

/**
取消暂无数据的状态
 */
- (void)resetNoMoreData;
//
- (void)setIgnoredScrollViewContentInsetBottom;

@end

@class BlankView;
@interface UITableView (blank)

@property (nonatomic, strong) BlankView *blankView;
/**
 弹出tableView 的空白视图，注意目前只支持一个页面中只有一个tableView 的使用情景，提示文字不要过长没有限制长度

 @param content 空白视图中的提示内容
 */
- (void)showBlankViewWithContent:(NSString *)content;

- (void)hideBlankView;

@end
