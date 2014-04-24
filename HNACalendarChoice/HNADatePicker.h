//
//  HNADatePicker.h
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNADateView.h"
#import "Hna_datapicker.h"
//BLOCK返回时间数据
typedef void (^DatePieckerDoneBlock)(NSString *startDate,NSString *endDate);

@interface HNADatePicker : UIViewController<HNAViewDelegate>

//初始化起始和终止时间
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSString *beginDateString;
@property (nonatomic, strong) NSString *endDateString;
//可选择的最小时间和最时间度
@property (nonatomic, strong) NSDate *minAvailableDate;
@property (nonatomic, strong) NSDate *maxAVailableDate;
@property (nonatomic, assign) HNASelectionMode selectionPickerMode;
@property (nonatomic, assign) HNASelDateType selectedDatePickerType;
//初始化
- (id)initWithSelectionMode:(HNASelectionMode)selectionMode dateType:(HNASelDateType)selectedDateType;
//设置选择的日期
- (void)showAndSelectDate:(NSDate *)date;
//弹出显示日历
- (void)showDatePickerView;
//设置添加到父试图
- (void)addPreaSuperView:(UIView *)preaSuperView;
//反回数据
- (void)requestDate:(DatePieckerDoneBlock)block;
@end
