//
//  HNACalendarChoice
//
//  Created by Curry on 14-3-13.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//
#import "NSDateAdditions.h"

@implementation NSDate (KalAdditions)

- (NSDate *)cc_dateByMovingToBeginningOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:0];
  [parts setMinute:0];
  [parts setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToEndOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:23];
  [parts setMinute:59];
  [parts setSecond:59];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth
{
  NSDate *d = nil;
  BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
  NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
  return d;
}

- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth:(int)jumpMontNum
{
  NSDateComponents *c = [[NSDateComponents alloc] init];
  c.month = jumpMontNum;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];  
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth:(int)jumpMontNum
{
  NSDateComponents *c = [[NSDateComponents alloc] init];
  c.month = jumpMontNum;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSDateComponents *)cc_componentsForMonthDayAndYear
{
  return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

- (NSUInteger)cc_weekday
{
  return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)cc_numberOfDaysInMonth
{
  return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

@end