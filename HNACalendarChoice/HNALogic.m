//
//  HNALogic.m
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import "HNALogic.h"
#import "UIViewAdditions.h"
#import "NSDateAdditions.h"

@interface HNALogic ()
- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, strong) NSArray *daysInSelectedMonth;
@property (nonatomic, strong) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, strong) NSArray *daysInFirstWeekOfFollowingMonth;

@end

@implementation HNALogic

@synthesize baseDate, fromDate, toDate, daysInSelectedMonth, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth;

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
    return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
    if ((self = [super init])) {
        monthAndYearFormatter = [[NSDateFormatter alloc] init];
        [monthAndYearFormatter setDateFormat:@"yyyy.MM"];
        [self moveToMonthForDate:date];
    }
    return self;
}

- (id)init
{
    return [self initForDate:[NSDate date]];
}

- (void)moveToMonthForDate:(NSDate *)date
{
    self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
    [self recalculateVisibleDays];
}

- (void)retreatToPreviousMonth
{
    [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth:-1]];
}

- (void)advanceToFollowingMonth
{
    [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth:1]];
}

- (void)retreatToPreviousMonthNum:(int)num
{
    [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth:num]];
}

- (void)advanceToFollowingMonthNum:(int)num
{
    [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth:num]];
}

- (NSDate *)getAdvanceToFollowingMonthNum:(int)num
{
    NSDate *date = [[NSDate date] cc_dateByMovingToFirstDayOfTheFollowingMonth:num];
    return [date  cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSString *)selectedMonthNameAndYear;
{
    return [monthAndYearFormatter stringFromDate:self.baseDate];
}

#pragma mark Low-level implementation details

- (NSUInteger)numberOfDaysInPreviousPartialWeek
{
    NSInteger num = [self.baseDate cc_weekday] - 1;
    if (num == 0)
        num = 7;
    return num;
}

- (NSUInteger)numberOfDaysInFollowingPartialWeek
{
    //  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
    //  c.day = [self.baseDate cc_numberOfDaysInMonth];
    //    NSLog(@"%d",c.day);
    //  NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
    //->设置最下月的显示天数，一共6行 每行7天 42-当月和前月
    NSInteger num = 42 - self.daysInSelectedMonth.count - self.daysInFinalWeekOfPreviousMonth.count;
    //    NSInteger num = 7 - [lastDayOfTheMonth cc_weekday];
    //    if (num == 0)
    //        num = 7;
    return num;
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth:-1];
    NSInteger n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
    NSInteger numPartialDays = [self numberOfDaysInPreviousPartialWeek];
    NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
    for (long i = n - (numPartialDays - 1); i < n + 1; i++)
        [days addObject:[NSDate dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
    
    return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
    NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
    for (NSInteger i = 1; i < numDays + 1; i++)
        [days addObject:[NSDate dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
    
    return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth:1] cc_componentsForMonthDayAndYear];
    NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
    
    for (int i = 1; i < numPartialDays + 1; i++)
        [days addObject:[NSDate dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
    
    return days;
}

- (void)recalculateVisibleDays
{
    self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
    self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
    self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
    NSDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
    NSDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
    self.fromDate = [from cc_dateByMovingToBeginningOfDay];
    self.toDate = [to cc_dateByMovingToEndOfDay];
}

#pragma mark -


@end
