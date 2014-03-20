/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "HNAGridView.h"

@class HNALogic;
@protocol HNAViewDelegate, HNADataSourceCallbacks;

@interface HNAView : UIView
{
    UILabel *headerTitleLabel;
    UILabel *beginDateLabel;
    UILabel *endDateLabel;
    CGPoint oldLocation;
    HNALogic *logic;
}
@property (nonatomic, assign) HNASelectionMode viewSelectionMode;
@property (nonatomic, assign) HNASelDateType selectedDateType;
@property (nonatomic, weak) id<HNAViewDelegate> delegate;
@property (nonatomic, strong) HNAGridView *gridView;
@property (nonatomic, strong) NSString *beginDateLabelText;
@property (nonatomic, strong) NSString *endDateLabelText;
- (id)initWithFrame:(CGRect)frame delegate:(id<HNAViewDelegate>)delegate logic:(HNALogic *)logic;
- (BOOL)isSliding;
- (void)markVacationForDates:(NSArray *)dates;
- (void)redrawEntireMonth;
- (void)stopshowAnimationView;
// These 3 methods are exposed for the delegate. They should be called 
// *after* the HNALogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")

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
