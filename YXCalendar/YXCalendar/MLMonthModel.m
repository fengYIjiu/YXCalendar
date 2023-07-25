//
//  MLMonthModel.m
//  Exchange
//
//  Created by Mac on 2023/7/24.
//  Copyright © 2023 alpha. All rights reserved.
//

#import "MLMonthModel.h"

@implementation MLMonthModel

- (void)setCurrentDate:(NSDate *)currentDate {
    
    _currentDate = currentDate;
    
    self.yearMonthText = _yearMonthText;
    self.cellLineNum = _cellLineNum;
    self.height = _height;
    self.dayList = _dayList;
}

- (NSString *)yearMonthText {
    
    if (!_yearMonthText) {
        
        _yearMonthText = [[YXDateHelpObject manager] getStrFromDateFormat:@"MM/yyyy" Date:_currentDate];
    }
    
    return _yearMonthText;
}

- (NSInteger)cellLineNum {
    
    if (_cellLineNum <= 0) {
        
        _cellLineNum = [[YXDateHelpObject manager] getRows:_currentDate];
    }
    
    return _cellLineNum;
}

- (CGFloat)height {
    
    if (_height <= 0) {
        
        _height = self.cellLineNum * dayCellH + weeksH;
    }
    
    return _height;
}

- (NSArray<MLDayModel *> *)dayList {
    
    if (!_dayList) {
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.cellLineNum * 7; i++) {
            
            MLDayModel* model = [[MLDayModel alloc]init];
            model.currentMon = self.currentDate;
            model.cellDate = [self dateForCellAtIndex:i];
            [arr addObject:model];
        }
        
        _dayList = [NSArray arrayWithArray:arr.copy];
    }
    
    return _dayList;
}

- (void)setCellStartToEnd {
    
    BOOL isNull = NO;

    if (!self.startDate && !self.endDate) {
        
        isNull = YES;
    }else if (self.startDate){
        
        if (self.endDate) {
            
            if ([[YXDateHelpObject manager] compareOneMonth:self.startDate withAnotherMonth:self.currentDate] || [[YXDateHelpObject manager] compareOneMonth:self.currentDate withAnotherMonth:self.endDate]) {
                
                isNull = NO;
            }else {
                
                isNull = YES;
            }
        }else {
            
            if ([[YXDateHelpObject manager] checkSameMonth:self.currentDate AnotherMonth:self.startDate]) {
                
                isNull = NO;
            }else {
                
                isNull = YES;
            }
        }
    }
    
    [self.dayList enumerateObjectsUsingBlock:^(MLDayModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          
        if (isNull) {
            
            [obj setStartDate:nil andEndDate:nil];
        }else {
            
            [obj setStartDate:self.startDate andEndDate:self.endDate];
        }
       
    }];
}

- (NSDate *)dateForCellAtIndex:(NSInteger)index {
    
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    NSDate *firstOfMonth = [[YXDateHelpObject manager] GetFirstDayOfMonth:self.currentDate];
    NSInteger ordinalityOfFirstDay = [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstOfMonth];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = (1 - ordinalityOfFirstDay) + index;
    return [myCalendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
    
}

@end

@implementation MLDayModel

- (void)setCellDate:(NSDate *)cellDate {
    
    // 当前月份不显示
    _cellDate = cellDate;
    if (![[YXDateHelpObject manager] checkSameMonth:cellDate AnotherMonth:self.currentMon]){
        
        self.dayText = @"";
        return;
    }
    
    // cell时间等于今天
    if ([[YXDateHelpObject manager] isSameDate:cellDate AnotherDate:[NSDate date]]) {
        
        self.dayText = @"今";
        self.isCanClick = YES;
        self.isToday = YES;
    }else {
        
        self.dayText = [[YXDateHelpObject manager] getStrFromDateFormat:@"d" Date:cellDate];
        
        // 大于今天
        if ([[YXDateHelpObject manager] compareOneDay:cellDate withAnotherDay:[NSDate date]]) {
            
            self.isCanClick = YES;
        }
    }
}

- (void)setStartDate:(nullable NSDate*)startDate andEndDate:(nullable NSDate*)endDate {
    
    self.isStartOrEndDate = NO;
    
    self.isShowRight = NO;
    
    self.isShowLeft = NO;
    
    // 开始结束时间不存在
    if (!startDate && !endDate) {
        
        return;
    }
    
    if (startDate && endDate) {
        
        if ([[YXDateHelpObject manager] isSameDate:self.cellDate AnotherDate:endDate]) {
            
            self.isStartOrEndDate = YES;
            self.isShowLeft = YES;
            
        }else if ([[YXDateHelpObject manager] isSameDate:self.cellDate AnotherDate:startDate]) {
            
            self.isStartOrEndDate = YES;
            self.isShowRight = YES;
            
        }else if ([[YXDateHelpObject manager] compareOneDay:self.cellDate withAnotherDay:startDate] && [[YXDateHelpObject manager] compareOneDay:endDate withAnotherDay:self.cellDate]) {
            
            self.isShowLeft = YES;
            self.isShowRight = YES;
        }
    }else if (startDate) {
        
        if ([[YXDateHelpObject manager] isSameDate:self.cellDate AnotherDate:startDate]) {
            
            self.isStartOrEndDate = YES;
        }
    }
}

@end
