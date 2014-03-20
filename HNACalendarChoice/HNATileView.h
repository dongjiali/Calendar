//
//  HNATileView.h
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HNATileTypeRegular   = 0,
    HNATileTypeAdjacent  = 1 << 0,
    HNATileTypeToday     = 1 << 1,
    HNATileTypeFirst     = 1 << 2,
    HNATileTypeLast      = 1 << 3,
    HNATileTypeDisable   = 1 << 4,
} HNATileType;

typedef enum {
    HNATileStateNone = 0,
    HNATileStateSelected,
    HNATileStateHighlighted,
    HNATileStateInRange,
    HNATileStateLeftEnd,
    HNATileStateRightEnd,
} HNATileState;

@interface HNATileView : UIView
{
    CGPoint origin;
}
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) HNATileState state;
@property (nonatomic, assign) HNATileType type;
@property (nonatomic, assign) BOOL isVacation;
@property (nonatomic, getter = isToday) BOOL today;
@property (nonatomic, getter = isFirst) BOOL first;
@property (nonatomic, getter = isLast) BOOL last;

- (void)resetState;
- (BOOL)isToday;
- (BOOL)isFirst;
- (BOOL)isLast;
- (BOOL)isDisable;
- (BOOL)belongsToAdjacentMonth;

@end
