/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

typedef enum {
    HNATileTypeRegular   = 0,
    HNATileTypeAdjacent  = 1 << 0,
    HNATileTypeToday     = 1 << 1,
    HNATileTypeFirst     = 1 << 2,
    HNATileTypeLast      = 1 << 3,
    HNATileTypeDisable   = 1 << 4,
    HNATileTypeVacation  = 1 << 5,
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
@property (nonatomic, getter = isVacation) BOOL marked;
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
