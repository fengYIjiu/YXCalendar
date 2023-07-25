//
//  YXMonthView.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXMonthCell.h"
#import "Masonry.h"

@interface YXMonthCell ()<UICollectionViewDataSource,UICollectionViewDelegate>


@end

@implementation YXMonthCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"YXMonthCell";
    YXMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YXMonthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
                
        _yearMonthL = [[UILabel alloc] initWithFrame:CGRectMake(22.f, 0, self.frame.size.width-44.f, yearMonthH)];
        _yearMonthL.textColor = UIColor.blackColor;
        _yearMonthL.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_yearMonthL];
        
        [self setCollectionView];
        
    }
    return self;
}

//MARK: - settingView
- (void)setCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(KScreenWidth / 7, dayCellH);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionV.scrollEnabled = NO;
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_collectionV];
    [_collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.yearMonthL.mas_bottom);
    }];
    
    [_collectionV registerClass:[YXDayCell class] forCellWithReuseIdentifier:@"YXDayCell"];
}

- (void)setMonModel:(MLMonthModel *)monModel {
    
    _monModel = monModel;
    
    self.yearMonthL.text = monModel.yearMonthText;
    
    [self.collectionV reloadData];
}

//MARK: - collectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.monModel.dayList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXDayCell" forIndexPath:indexPath];
    
    cell.dayModel = self.monModel.dayList[indexPath.row];
    
    return cell;
}

//MARK: - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
    MLDayModel* dayModel = self.monModel.dayList[indexPath.row];
    
    if (!dayModel.isCanClick) return;
        
    NSDate* startDay = self.monModel.startDate;
    NSDate* endDay   = self.monModel.endDate;
    // 无开始结束时间
    if (!startDay && !endDay) {
        
        startDay = dayModel.cellDate;
    }else {
        
        // 开始时间=cell时间
        if ([[YXDateHelpObject manager] isSameDate:startDay AnotherDate:dayModel.cellDate]) {
            
            startDay = endDay;
            endDay = nil;
            
            // 结束时间=cell时间
        }else if ([[YXDateHelpObject manager] isSameDate:endDay AnotherDate:dayModel.cellDate]) {
            
            endDay = nil;
            
            // 开始时间 = nil
        }else if(!startDay){
            
            startDay = dayModel.cellDate;
        }else {
            
            endDay = dayModel.cellDate;
        }
    }
    
    // 开始和结束时间排序
    if (!startDay && endDay) {
        
        startDay = endDay;
        endDay = nil;
    }else if (startDay && endDay){
        
        if ([[YXDateHelpObject manager] compareOneDay:startDay withAnotherDay:endDay]) {
            
            NSDate* MDate = startDay;
            startDay = endDay;
            endDay = MDate;
        }
    }
    
    if (_sendSelectDate) {
        _sendSelectDate(startDay,endDay);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
