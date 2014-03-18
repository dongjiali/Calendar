//
//  HNACalendarChoice
//
//  Created by Curry on 14-3-13.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSDate (KalAdditions)

// All of the following methods use [NSCalendar currentCalendar] to perform
// their calculations.

- (NSDate *)cc_dateByMovingToBeginningOfDay;
- (NSDate *)cc_dateByMovingToEndOfDay;
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth:(int)jumpMontNum;
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth:(int)jumpMontNum;
- (NSDateComponents *)cc_componentsForMonthDayAndYear;
- (NSUInteger)cc_weekday;
- (NSUInteger)cc_numberOfDaysInMonth;

@end