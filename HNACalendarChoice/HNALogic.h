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

@property (nonatomic, strong) NSDate *baseDate;    // The first day of the currently selected month
@property (nonatomic, strong, readonly) NSDate *fromDate;  // The date corresponding to the tile in the upper-left corner of the currently selected month
@property (nonatomic, strong, readonly) NSDate *toDate;    // The date corresponding to the tile in the bottom-right corner of the currently selected month
@property (nonatomic, strong, readonly) NSArray *daysInSelectedMonth;             // array of NSDate
@property (nonatomic, strong, readonly) NSArray *daysInFinalWeekOfPreviousMonth;  // array of NSDate
@property (nonatomic, strong, readonly) NSArray *daysInFirstWeekOfFollowingMonth; // array of NSDate
@property (copy, nonatomic, readonly) NSString *selectedMonthNameAndYear; // localized (e.g. "September 2010" for USA locale)

- (id)initForDate:(NSDate *)date; // designated initializer.

- (void)retreatToPreviousMonth;
- (void)advanceToFollowingMonth;
- (void)retreatToPreviousMonthNum:(int)num;
- (void)advanceToFollowingMonthNum:(int)num;
- (NSDate *)getAdvanceToFollowingMonthNum:(int)num;
- (void)moveToMonthForDate:(NSDate *)date;

@end
