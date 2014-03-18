/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "KalGridView.h"

@class KalLogic;
@protocol KalViewDelegate, KalDataSourceCallbacks;

@interface KalView : UIView
{
    UILabel *headerTitleLabel;
    UILabel *beginDateLabel;
    UILabel *endDateLabel;
    CGPoint oldLocation;
    KalLogic *logic;
}
@property (nonatomic, assign) KalSelectionMode viewSelectionMode;
@property (nonatomic, weak) id<KalViewDelegate> delegate;
@property (nonatomic, strong) KalGridView *gridView;
@property (nonatomic, strong) NSString *beginDateLabelText;
@property (nonatomic, strong) NSString *endDateLabelText;
- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)delegate logic:(KalLogic *)logic;
- (BOOL)isSliding;
- (void)markVacationForDates:(NSArray *)dates;
- (void)redrawEntireMonth;
- (void)stopshowAnimationView;
// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")

@end

#pragma mark -

@protocol KalViewDelegate

@optional

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)selectDateDone;
- (void)didSelectDate:(NSDate *)date;
- (void)didSelectBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
@end
