//
//  HNAMonthView.h
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNATileView;

@interface HNAMonthView : UIView
{
    NSUInteger numWeeks;
    NSDateFormatter *tileAccessibilityFormatter;
}

@property (nonatomic) NSUInteger numWeeks;
@property (nonatomic ,strong) NSMutableArray *vacationArray;
- (id)initWithFrame:(CGRect)rect;
- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *) trailingAdjacentDates minAvailableDate:(NSDate *)minAvailableDate maxAvailableDate:(NSDate *)maxAvailableDate;
- (HNATileView *)firstTileOfMonth;
- (HNATileView *)tileForDate:(NSDate *)date;
@end