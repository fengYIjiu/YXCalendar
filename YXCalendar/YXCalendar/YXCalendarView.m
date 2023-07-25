//
//  YXCalendarView.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXCalendarView.h"
#import "Masonry.h"
#import "UITableView+refresh.h"
#import "MJRefresh.h"

#define ViewW self.frame.size.width     //当前视图宽度
#define ViewH self.frame.size.height    //当前视图高度

@interface YXCalendarView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign)NSInteger currenMonIndex;

@property (nonatomic, strong)NSMutableArray<MLMonthModel*>* monList;

@end

@implementation YXCalendarView

- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date {
    
    if (self = [super initWithFrame:frame]) {
        
        self.currenMonIndex = 0;
        
        [self settingViews];
        
        self.currentDate = date;
    }
    return self;
}

- (void)settingViews {
    [self settingHeadLabel];
    [self settingTableView];
    
    [self setRefreshTableview];
}

- (void)settingHeadLabel {
    
    NSArray *weekdays = @[@"周日",
                          @"周一",
                          @"周二",
                          @"周三",
                          @"周四",
                          @"周五",
                          @"周六",];
    CGFloat weekdayW = ViewW/7;
    for (int i = 0; i < 7; i++) {
        UILabel *weekL = [[UILabel alloc] initWithFrame:CGRectMake(i*weekdayW, 0, weekdayW, weeksH)];
        weekL.textAlignment = NSTextAlignmentCenter;
        weekL.font = [UIFont systemFontOfSize:16];
        weekL.text = weekdays[i];
        [self addSubview:weekL];
        
        if (i == 0 || i==6) {
            
            weekL.textColor = UIColor.blueColor;
        }else {
            
            weekL.textColor = UIColor.grayColor;
        }
    }
}

- (void)settingTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(weeksH));
    }];
}

- (void)setCurrentDate:(NSDate *)currentDate {
    
    _currentDate = currentDate;
    
    self.monList = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 6; i++) {
        
        MLMonthModel* monModel = [[MLMonthModel alloc]init];
        monModel.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:currentDate LeadTime:i Type:1];
        monModel.startDate = self.startDay;
        monModel.endDate = self.endtDay;
        [monModel setCellStartToEnd];
        
        [self.monList addObject:monModel];
    }
    
    [self.tableView reloadData];
}

- (void)setRefreshTableview{
    
    KWeakSelf
    self.tableView.refreshBlock = ^{
        [weakSelf refreshMore];
    };
    self.tableView.loadBlock = ^{
        [weakSelf loadMore];
    };
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 34;
    
    [self.tableView refreshLanguage];
}

- (void)refreshMore {
    
    [self.tableView.mj_header beginRefreshing];
    
    for (NSInteger i = 1; i < 7; i++) {
        
        MLMonthModel* monModel = [[MLMonthModel alloc]init];
        monModel.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:self.currentDate LeadTime:- i - self.currenMonIndex Type:1];
        monModel.startDate = self.startDay;
        monModel.endDate = self.endtDay;
        
        [monModel setCellStartToEnd];
        
        [self.monList insertObject:monModel atIndex:0];
    }
    
    self.currenMonIndex = self.currenMonIndex + 6;
    
    [self.tableView.mj_header endRefreshing];
    
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)loadMore{
    
    [self.tableView.mj_footer beginRefreshing];
    
    NSInteger count = self.monList.count;
    for (NSInteger i = count - 1; i < count + 5; i++) {
        
        MLMonthModel* monModel = [[MLMonthModel alloc]init];
        monModel.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:self.currentDate LeadTime:count - self.currenMonIndex + i Type:1];
        monModel.startDate = self.startDay;
        monModel.endDate = self.endtDay;
        
        [monModel setCellStartToEnd];
        
        [self.monList addObject:monModel];
    }
    
    [self.tableView.mj_footer endRefreshing];
    
    [self.tableView reloadData];
}

- (void)resetFresh {
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.monList enumerateObjectsUsingBlock:^(MLMonthModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        obj.startDate = nil;
        obj.endDate = nil;
        [obj setCellStartToEnd];
    }];

    [self.tableView reloadData];
}

//MARKK -- UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.monList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YXMonthCell *cell = [YXMonthCell cellWithTableView:tableView];
    
    cell.monModel = self.monList[indexPath.row];
    
    KWeakSelf
    cell.sendSelectDate = ^(NSDate *startDay, NSDate *endDay) {
        
        weakSelf.startDay = startDay;
        weakSelf.endtDay = endDay;
        
        if(weakSelf.sendSelectDate) {
            weakSelf.sendSelectDate(startDay, endDay);
        }
        
        [weakSelf.monList enumerateObjectsUsingBlock:^(MLMonthModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
            obj.startDate = startDay;
            obj.endDate = endDay;
            [obj setCellStartToEnd];
        }];
        
        [weakSelf.tableView reloadData];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MLMonthModel* monModel = self.monList[indexPath.row];
    return monModel.height;
}

// 最多滑动到本月！！
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    if (scrollView.contentOffset.y <= 0) {
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//    }
//}

@end
