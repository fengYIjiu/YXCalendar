//
//  UITableView+refresh.m
//  BFWallet
//
//  Created by floyd on 2018/1/6.
//  Copyright © 2018年 gongjice. All rights reserved.
//

#import "UITableView+refresh.h"
#import <objc/runtime.h>
#import "UIView+MJExtension.h"
#import "MJRefresh.h"
#import "MLDIYHeader.h"
#import "Masonry.h"

#define KWeakSelf __weak typeof(self) weakSelf = self;

static NSString const *refreshBlockKey = @"refreshBlockKey";
static NSString const *loadBlockKey = @"loadBlockKey";

@implementation UITableView (refresh)

- (void)startRefresh {
    if (self.refreshBlock) {
        [self.mj_header beginRefreshing];
    }
}

- (void)endRefresh {
    if (!self.mj_header && !self.mj_footer) {
        return;
    }
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

- (void)endLoadDataWithNoMoreData {
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)resetNoMoreData{
    if (self.mj_footer) {
        [self.mj_footer resetNoMoreData];
    }
}

#pragma mark runtime

- (void)setRefreshBlock:(voidBlock)refreshBlock {
    KWeakSelf;
    if (refreshBlock) {
//        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weakSelf.refreshBlock();
//        }];
//        //隐藏刷新时间提示
//        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.mj_header;
//		header.backgroundColor = [EXColor backColor_theme];
//        header.lastUpdatedTimeLabel.hidden = YES;
        
        self.mj_header = [MLDIYHeader headerWithRefreshingBlock:^{
            weakSelf.refreshBlock();
        }];
    }
    objc_setAssociatedObject(self, &refreshBlockKey, refreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setwhiteHeader{
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.mj_header;
    header.backgroundColor = UIColor.whiteColor;
}

- (voidBlock)refreshBlock {
    return objc_getAssociatedObject(self, &refreshBlockKey);
}

- (void)setLoadBlock:(voidBlock)loadBlock {
    if (loadBlock) {
        //MJRefreshAutoNormalFooter
        KWeakSelf;
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.loadBlock();
        }];
    }
    else {
        self.mj_footer = nil;
    }
    objc_setAssociatedObject(self, &loadBlockKey, loadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)enableLoadMore{
    self.mj_footer.hidden = NO;
}


- (void)disableLoadMore{
    self.mj_footer.hidden = YES;
}

- (void)enableRefresh{
    self.mj_header.hidden = NO;
}

- (void)disableRefresh{
    self.mj_header.hidden = YES;
}

- (void)refreshLanguage{
    //设置header
    
    MLDIYHeader *header = (MLDIYHeader *)self.mj_header;
    header.titlelLabel.textColor = UIColor.blueColor;//kIsNight ? [EXColor desColor] : [EXColor desColor2];
//    header.loadingView.activityIndicatorViewStyle = kIsNight ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray;
    
    //设置footer
    if([self.mj_footer isKindOfClass:[MJRefreshBackNormalFooter class]]){
        MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)self.mj_footer;
        [footer setTitle:MJRefreshBackFooterIdleText forState:MJRefreshStateIdle];
        [footer setTitle:MJRefreshBackFooterPullingText forState:MJRefreshStatePulling];
        [footer setTitle:MJRefreshBackFooterRefreshingText forState:MJRefreshStateRefreshing];
        [footer setTitle:MJRefreshBackFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
        
        footer.stateLabel.textColor = UIColor.grayColor;
    }
    else if ([self.mj_footer isKindOfClass:[MJRefreshAutoStateFooter class]]){
        MJRefreshAutoStateFooter *footer = (MJRefreshAutoStateFooter *)self.mj_footer;
        [footer setTitle:MJRefreshAutoFooterIdleText forState:MJRefreshStateIdle];
        [footer setTitle:MJRefreshAutoFooterRefreshingText forState:MJRefreshStateRefreshing];
        [footer setTitle:MJRefreshAutoFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
    }
}

- (voidBlock)loadBlock {
    return objc_getAssociatedObject(self, &loadBlockKey);
}
- (void)setIgnoredScrollViewContentInsetBottom {
    self.mj_footer.ignoredScrollViewContentInsetBottom = 34.f;
}

@end


@interface BlankView : UIView
@property (nonatomic, copy) NSString *blankTip;
@end

@interface BlankView ()
@property (nonatomic, strong) UILabel *blankTipLabel;
@end

@implementation BlankView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    
    UIView *contentView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kong"]];
    
    [contentView addSubview:self.blankTipLabel];
    [contentView addSubview:imageView];
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.blankTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(contentView);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blankTipLabel.mas_bottom).offset(20);
        make.bottom.right.left.equalTo(contentView);
    }];
}

- (void)setBlankTip:(NSString *)blankTip {
    _blankTip = blankTip;
    self.blankTipLabel.text = blankTip;
}

- (UILabel *)blankTipLabel {
    if (!_blankTipLabel) {
        _blankTipLabel = [[UILabel alloc] init];
        _blankTipLabel.textColor = UIColor.grayColor;
        _blankTipLabel.font = [UIFont systemFontOfSize:17];
        _blankTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blankTipLabel;
}
@end

static NSString const *blankViewKey = @"blankViewKey";
static BlankView *tableViewBlankView = nil;

@implementation UITableView (blank)

- (void)showBlankViewWithContent:(NSString *)content {
    [self hideBlankView];
    if (!self.blankView) {
        self.blankView = [[BlankView alloc] initWithFrame:self.bounds];
    }
    self.blankView.blankTip = content;
    [self addSubview:self.blankView];
    [self.blankView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.center.equalTo(self);
    }];
    [self.superview layoutIfNeeded];
}

- (void)hideBlankView {
    if (!self.blankView) {
        return;
    }
    [self.blankView removeFromSuperview];
    self.blankView = nil;
}


#pragma mark runtime


- (void)setBlankView:(BlankView *)blankView {
    objc_setAssociatedObject(self, &blankViewKey, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BlankView *)blankView {
    return objc_getAssociatedObject(self, &blankViewKey);
}


@end



