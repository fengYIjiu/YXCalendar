//
//  MLMonthModel.h
//  Exchange
//
//  Created by Mac on 2023/7/24.
//  Copyright © 2023 alpha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "YXDateHelpObject.h"

NS_ASSUME_NONNULL_BEGIN

@class MLDayModel;
@interface MLMonthModel : NSObject

/**
 data
 */
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong, nullable) NSDate *startDate;

@property (nonatomic, strong, nullable) NSDate *endDate;

@property (nonatomic, copy)NSArray<MLDayModel*>* dayList;

- (void)setCellStartToEnd;

/**
 UI-data
 */
@property (nonatomic, strong) NSString *yearMonthText;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) NSInteger cellLineNum;

@end

@interface MLDayModel : NSObject

/**
 data
 */
@property (nonatomic, strong) NSDate *currentMon;

@property (nonatomic, strong) NSDate *cellDate;

- (void)setStartDate:(nullable NSDate*)startDate andEndDate:(nullable NSDate*)endDate;

/**
 UI-data
 */
@property (nonatomic, strong) NSString *dayText;

@property (nonatomic, assign) BOOL isToday;

@property (nonatomic, assign) BOOL isCanClick;

@property (nonatomic, assign) BOOL isStartOrEndDate;

@property (nonatomic, assign) BOOL isShowRight;

@property (nonatomic, assign) BOOL isShowLeft;

@end

NS_ASSUME_NONNULL_END
