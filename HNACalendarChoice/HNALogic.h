//
//  HNALogic.h
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNALogic : NSObject
{
    NSDate *baseDate;
    NSDate *fromDate;
    NSDate *toDate;
    NSArray *daysInSelectedMonth;
    NSArray *daysInFinalWeekOfPreviousMonth;
    NSArray *daysInFirstWeekOfFollowingMonth;
    NSDateFormatter *monthAndYearFormatter;
}

@property (nonatomic, strong) NSDate *baseDate;                                 //当前选中的第一天
@property (nonatomic, strong, readonly) NSDate *fromDate;  // 日期对应于日历在当前选中的左上角
@property (nonatomic, strong, readonly) NSDate *toDate;    // 相对应的日期在当前选中的右下角
@property (nonatomic, strong, readonly) NSArray *daysInSelectedMonth;             // 当前月
@property (nonatomic, strong, readonly) NSArray *daysInFinalWeekOfPreviousMonth;  // 上一月
@property (nonatomic, strong, readonly) NSArray *daysInFirstWeekOfFollowingMonth; // 下一月
@property (copy, nonatomic, readonly) NSString *selectedMonthNameAndYear;

- (id)initForDate:(NSDate *)date; // 初始化

- (void)retreatToPreviousMonth;
- (void)advanceToFollowingMonth;
- (void)retreatToPreviousMonthNum:(int)num;
- (void)advanceToFollowingMonthNum:(int)num;
- (NSDate *)getAdvanceToFollowingMonthNum:(int)num;
- (void)moveToMonthForDate:(NSDate *)date;

@end
