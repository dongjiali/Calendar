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

@interface HNAGridView : UIView
{
    id<HNAViewDelegate> delegate;
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

//这三个方法应称为 HNALogic之后
//当前 之前 或之后。
- (void)slideUp;
- (void)slideDown;
- (void)jumpToSelectedMonth;

@end
