//
//  HNAGridView.h
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HNASelectionModeSingle = 0, //单选
    HNASelectionModeRange,      //多选
} HNASelectionMode;

typedef enum {
    HNASelDateTypeAirLine = 0,  //航班
    HNASelDateTypeHotle,        //酒店
}HNASelDateType;

@class HNATileView, HNAMonthView, HNALogic;
@protocol HNAViewDelegate;

/*
 *    HNAGridView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the HNA system you should not need to use this class directly
 *  (it is managed by HNAView).
 *
 */
@interface HNAGridView : UIView
{
    id<HNAViewDelegate> delegate;  // Assigned.
    HNALogic *logic;
    HNAMonthView *frontMonthView;
    HNAMonthView *backMonthView;
}

@property (nonatomic, assign) BOOL transitioning;
@property (nonatomic, assign) HNASelectionMode selectionMode;
@property (nonatomic, assign) HNASelDateType selectedDateType;
@property (nonatomic, strong) NSDate *minAvailableDate;
@property (nonatomic, strong) NSDate *maxAVailableDate;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
- (id)initWithFrame:(CGRect)frame logic:(HNALogic *)logic delegate:(id<HNAViewDelegate>)delegate;

// These 3 methods should be called *after* the HNALogic
// has moved to the previous or following month.
- (void)slideUp;
- (void)slideDown;
- (void)jumpToSelectedMonth;    // see comment on HNAView

@end
