//
//  HNADatePicker.h
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNADateView.h"
typedef void (^DatePieckerDoneBlock)(NSString *startDate,NSString *endDate);

@interface HNADatePicker : UIViewController<HNAViewDelegate>
{
    DatePieckerDoneBlock _datePickerblock;
}

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) HNASelectionMode selectionMode;
@property (nonatomic, assign) HNASelDateType selectedDateType;
@property (nonatomic, strong) NSDate *minAvailableDate;
@property (nonatomic, strong) NSDate *maxAVailableDate;
@property (nonatomic, strong) UIView *preaSuperView;

- (id)initWithSelectionMode:(HNASelectionMode)selectionMode dateType:(HNASelDateType)selectedDateType;

- (void)showAndSelectDate:(NSDate *)date;
// show date picker view in supperview
- (void)showDatePickerView;
//add super view
- (void)addPreaSuperView:(UIView *)preaSuperView;
//daterequest
- (void)requestDate:(DatePieckerDoneBlock)block;
@end
