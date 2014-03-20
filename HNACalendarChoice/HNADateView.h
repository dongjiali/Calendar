//
//  HNADateView.h
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGridView.h"

@class HNALogic;
@protocol HNAViewDelegate, HNADataSourceCallbacks;

@interface HNADateView : UIView

@property (nonatomic, assign) HNASelectionMode viewSelectionMode;
@property (nonatomic, assign) HNASelDateType selectedDateType;
@property (nonatomic, weak) id<HNAViewDelegate> delegate;
@property (nonatomic, strong) HNAGridView *gridView;
@property (nonatomic, strong) NSString *beginDateLabelText;
@property (nonatomic, strong) NSString *endDateLabelText;

- (id)initWithFrame:(CGRect)frame delegate:(id<HNAViewDelegate>)delegate logic:(HNALogic *)logic;
- (BOOL)isSliding;
- (void)redrawEntireMonth;
- (void)stopshowAnimationView;
- (void)setDateLabelShowType;
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth; 

@end

#pragma mark -

@protocol HNAViewDelegate

@optional

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)selectDateDone;
- (void)didSelectDate:(NSDate *)date;
- (void)didSelectBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
@end
