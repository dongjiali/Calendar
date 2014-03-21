//
//  HNAGridView.m
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import "HNAGridView.h"

#import <CoreGraphics/CoreGraphics.h>

#import "HNAGridView.h"
#import "HNADateView.h"
#import "HNAMonthView.h"
#import "HNATileView.h"
#import "HNALogic.h"
#import "UIViewAdditions.h"
#import "NSDateAdditions.h"

#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2

const CGSize kTileSize = { 46.f, 44.f };

static NSString *kSlideAnimationId = @"HNASwitchMonths";

@interface HNAGridView ()

@property (nonatomic, strong) NSMutableArray *rangeTiles;

- (void)swapMonthViews;

@end

@implementation HNAGridView
{
    BOOL _needRemoveRanges;
}

- (void)setBeginDate:(NSDate *)beginDate
{
    HNATileView *preTile = [frontMonthView tileForDate:_beginDate];
    preTile.state = HNATileStateNone;
    _beginDate = beginDate;
    HNATileView *currentTile = [frontMonthView tileForDate:_beginDate];
    currentTile.state = HNATileStateSelected;
    [self removeRanges];
    self.endDate = nil;
}

- (void)setEndDate:(NSDate *)endDate
{
    HNATileView *beginTile = [frontMonthView tileForDate:self.beginDate];
    
    HNATileView *preTile = [frontMonthView tileForDate:_endDate];
    preTile.state = HNATileStateNone;
    _endDate = endDate;
    
    HNATileView *currentTile = [frontMonthView tileForDate:_endDate];
    
    NSDate *realBeginDate;
    NSDate *realEndDate;
    
    [self removeRanges];
    
    if (!_endDate || [_endDate isEqualToDate:self.beginDate]) {
        //->
        //-> 多选时选择begin end是同一天设置成选择
        realBeginDate = self.beginDate;
        realEndDate = self.endDate;
        beginTile.state = HNATileStateSelected;
        currentTile.state = HNATileStateSelected;
        return;
    } else if ([self.beginDate compare:self.endDate] == NSOrderedAscending) {
        realBeginDate = self.beginDate;
        realEndDate = self.endDate;
        beginTile.state = HNATileStateLeftEnd;
        currentTile.state = HNATileStateRightEnd;
    } else {
        realBeginDate = self.endDate;
        realEndDate = self.beginDate;
        beginTile.state = HNATileStateRightEnd;
        currentTile.state = HNATileStateLeftEnd;
    }
    
    int dayCount = [NSDate dayBetweenStartDate:realBeginDate endDate:realEndDate];
    for (int i=1; i<dayCount; i++) {
        NSDate *nextDay = [realBeginDate offsetDay:i];
        HNATileView *nextTile = [frontMonthView tileForDate:nextDay];
        if (nextTile) {
            nextTile.state = HNATileStateInRange;
            [nextTile setNeedsDisplay];
            [self.rangeTiles addObject:nextTile];
        }
    }
}

- (void)removeRanges
{
    if (_needRemoveRanges) {
        for (HNATileView *tile in self.rangeTiles) {
            tile.state = HNATileStateNone;
        }
        [self.rangeTiles removeAllObjects];
    }
}

- (id)initWithFrame:(CGRect)frame logic:(HNALogic *)theLogic delegate:(id<HNAViewDelegate>)theDelegate
{
    if (self = [super initWithFrame:frame]) {
        _needRemoveRanges = YES;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        logic = theLogic;
        delegate = theDelegate;
        
        CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
        frontMonthView = [[HNAMonthView alloc] initWithFrame:monthRect];
        backMonthView = [[HNAMonthView alloc] initWithFrame:monthRect];
        backMonthView.hidden = YES;
        self.userInteractionEnabled = YES;
        [self addSubview:backMonthView];
        [self addSubview:frontMonthView];
        self.selectionMode = HNASelectionModeSingle;
        _rangeTiles = [[NSMutableArray alloc] init];
        
        [self jumpToSelectedMonth];
    }
    return self;
}

- (void)sizeToFit
{
    self.height = frontMonthView.height;
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if (!hitView)
        return;
    
    if ([hitView isKindOfClass:[HNATileView class]]) {
        HNATileView *tile = (HNATileView*)hitView;
        if (tile.type & HNATileTypeDisable)
            return;
        NSDate *date = tile.date;
        
        
        if(self.selectionMode == HNASelectionModeRange)
        {
            //多选
            if ([date isEqualToDate:self.beginDate]) {
                date = self.beginDate;
                _beginDate = _endDate;
                _endDate = date;
            } else if ([date isEqualToDate:self.endDate]) {
                
            } else {
                if ([date compare:self.endDate] != NSOrderedAscending) {
                    
                }else
                {
                    self.beginDate = date;
                }
            }
        }
        else{
            //单选
            self.beginDate = date;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.selectionMode == HNASelectionModeSingle)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if (!hitView)
        return;
    
    if ([hitView isKindOfClass:[HNATileView class]]) {
        HNATileView *tile = (HNATileView*)hitView;
        if (tile.type & HNATileTypeDisable)
            return;
        
        NSDate *endDate = tile.date;
        if ([endDate isEqualToDate:self.endDate])
            return;
        self.endDate = endDate;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if ([hitView isKindOfClass:[HNATileView class]]) {
        HNATileView *tile = (HNATileView*)hitView;
        if (tile.type & HNATileTypeDisable)
            return;

        if (self.selectionMode == HNASelectionModeRange) {
            NSDate *endDate = tile.date;
            if ([tile.date isEqualToDate:self.beginDate]) {
                if ([[endDate offsetDay:1] compare:self.maxAVailableDate] == NSOrderedDescending) {
                    endDate = [endDate offsetDay:-1];
                } else {
                    if (self.selectedDateType == HNASelDateTypeHotle) {
                        endDate = [endDate offsetDay:1];
                    }
                }
            }
            self.endDate = endDate;
            
            NSDate *realBeginDate = self.beginDate;
            NSDate *realEndDate = self.endDate;
            if ([self.beginDate compare:self.endDate] == NSOrderedDescending) {
                realBeginDate = self.endDate;
                realEndDate = self.beginDate;
            }
            if ([(id)delegate respondsToSelector:@selector(didSelectBeginDate:endDate:)]) {
                [delegate didSelectBeginDate:realBeginDate endDate:realEndDate];
            }
        } else {
            if ([(id)delegate respondsToSelector:@selector(didSelectDate:)]) {
                [delegate didSelectDate:self.beginDate];
            }
        }
        if ((self.selectionMode == HNASelectionModeSingle && tile.belongsToAdjacentMonth) ||
            (self.selectionMode == HNASelectionModeRange && tile.belongsToAdjacentMonth)) {
            if ([tile.date compare:logic.baseDate] == NSOrderedDescending) {
                [delegate showFollowingMonth];
            } else {
                [delegate showPreviousMonth];
            }
        }
    }
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
    backMonthView.hidden = NO;
    self.userInteractionEnabled = NO;
    // set initial positions before the slide
    if (direction == SLIDE_UP) {
        backMonthView.top = keepOneRow
        ? frontMonthView.bottom - kTileSize.height
        : frontMonthView.bottom;
    } else if (direction == SLIDE_DOWN) {
        NSUInteger numWeeksToKeep = keepOneRow ? 1 : 0;
        NSInteger numWeeksToSlide = [backMonthView numWeeks] - numWeeksToKeep;
        backMonthView.top = -numWeeksToSlide * kTileSize.height;
    } else {
        backMonthView.top = 0.f;
    }
    // trigger the slide animation
    [UIView beginAnimations:kSlideAnimationId context:NULL]; {
        [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        frontMonthView.top = -backMonthView.top;
        backMonthView.top = 0.f;
        
        frontMonthView.alpha = 1.f;
        backMonthView.alpha = 1.f;
        
        self.height = backMonthView.height;
        
        [self swapMonthViews];
    } [UIView commitAnimations];
    [UIView setAnimationsEnabled:YES];
}

- (void)slide:(int)direction
{
    self.transitioning = YES;
    
    [backMonthView showDates:logic.daysInSelectedMonth
        leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
       trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth
            minAvailableDate:self.minAvailableDate
            maxAvailableDate:self.maxAVailableDate];
    
    // At this point, the calendar logic has already been advanced or retreated to the
    // following/previous month, so in order to determine whether there are
    // any cells to keep, we need to check for a partial week in the month
    // that is sliding offscreen.
    
    BOOL keepOneRow = (direction == SLIDE_UP && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
    || (direction == SLIDE_DOWN && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
    
    [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
    
    if (self.selectionMode == HNASelectionModeSingle) {
        self.beginDate = _beginDate;
    } else {
        _needRemoveRanges = NO;
        self.endDate = _endDate;
        _needRemoveRanges = YES;
    }
}

- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.transitioning = NO;
    backMonthView.hidden = YES;
    self.userInteractionEnabled = YES;
}

#pragma mark -

- (void)swapMonthViews
{
    HNAMonthView *tmp = backMonthView;
    backMonthView = frontMonthView;
    frontMonthView = tmp;
    [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
    [self slide:SLIDE_NONE];
}

#pragma mark -


@end