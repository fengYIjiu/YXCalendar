//
//  YXMonthCell.h
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDayCell.h"
#import "MLMonthModel.h"

static CGFloat const yearMonthH = 45;   //年月高度

typedef void(^SendSelectDate)(NSDate *startDay ,NSDate *endDay);

@interface YXMonthCell : UITableViewCell

@property (nonatomic, strong) MLMonthModel *monModel;          //当前月份

@property (nonatomic, copy) SendSelectDate sendSelectDate;  //回传选中日期
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) UILabel *yearMonthL;      //年月label

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
