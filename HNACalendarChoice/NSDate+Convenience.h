//
//  NSDate+Convenience.h
//  HNACalendarChoice
//
//  Created by Curry on 14-3-13.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)

- (int)year;
- (int)month;
- (int)day;
- (int)hour;
- (NSString *)weekString;
- (NSDate *)offsetDay:(int)numDays;
- (BOOL)isToday;

+ (NSDate *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year;
+ (NSDate *)dateStartOfDay:(NSDate *)date;
+ (int)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDate *)dateFromStringBySpecifyTime:(NSString *)dateString hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDateComponents *)nowDateComponents;
+ (NSDateComponents *)dateComponentsFromNow:(NSInteger)days;

@end
