/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "HNADateView.h"       // for the HNAViewDelegate protocol

@class HNALogic;

@protocol SelectedDateDelegate;

@interface HNAViewController : UIViewController <HNAViewDelegate>
{
  HNALogic *logic;
}
@property (nonatomic, weak)id<SelectedDateDelegate>selectDateDelegate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSArray *vacationDate;
@property (nonatomic, assign) HNASelectionMode selectionMode;
@property (nonatomic, assign) HNASelDateType selectedDateType;
@property (nonatomic, strong) NSDate *minAvailableDate;
@property (nonatomic, strong) NSDate *maxAVailableDate;
@property (nonatomic, strong) UIView *preaSuperView;

- (id)initWithSelectionMode:(HNASelectionMode)selectionMode dateType:(HNASelDateType)selectedDateType;

- (void)showAndSelectDate:(NSDate *)date;           // Updates the state of the calendar to display the specified date's month and selects the tile for that date.
- (void)showDatePickerView;
//add super view
- (void)addPreaSuperView:(UIView *)preaSuperView;
@end

@protocol SelectedDateDelegate
- (void)requestDate:(NSDate *)startDate endDate:(NSDate *)endDate;
@end
