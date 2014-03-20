//
//  HNADatePicker.m
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import "HNADatePicker.h"
#import "HNALogic.h"
#import "UIViewAdditions.h"
#import "NSDateAdditions.h"

#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};
    
    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

@interface HNADatePicker ()
{
    HNALogic *logic;
}
@end

@implementation HNADatePicker


#pragma -mark - init begin end max min Date

- (void)setBeginDate:(NSDate *)beginDate
{
    _beginDate = beginDate;
    self.calendarView.gridView.beginDate = _beginDate;
    [self showAndSelectDate:_beginDate];
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    self.calendarView.gridView.endDate = _endDate;
    [(HNADateView *)self.view redrawEntireMonth];
}

- (void)setMinAvailableDate:(NSDate *)minAvailableDate
{
    _minAvailableDate = minAvailableDate;
    ((HNADateView *)self.view).gridView.minAvailableDate = minAvailableDate;
    [(HNADateView *)self.view redrawEntireMonth];
}

- (void)setMaxAVailableDate:(NSDate *)maxAVailableDate
{
    _maxAVailableDate = maxAVailableDate;
    ((HNADateView *)self.view).gridView.maxAVailableDate = maxAVailableDate;
    [(HNADateView *)self.view redrawEntireMonth];
}

#pragma mark- HNALogic init

- (id)initWithSelectionMode:(HNASelectionMode)selectionMode dateType:(HNASelDateType)selectedDateType;
{
    if ((self = [super init])) {
        
        logic = [[HNALogic alloc] initForDate:[NSDate date]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];

        self.selectionMode = selectionMode;
        self.selectedDateType = selectedDateType;
        //->设置最小的选择是哪天  往前5天
        //->HNA.minAvailableDate = [NSDate dateStartOfDay:[[NSDate date] offsetDay:-5]];
        self.minAvailableDate = [NSDate dateStartOfDay:[NSDate date]];
        //->设置最大能选择的天是哪天  往后6个月
        self.maxAVailableDate = [self.minAvailableDate offsetDay:31 * 6];
    }
    return self;
}

- (id)init
{
    return [self initWithSelectionMode:HNASelectionModeSingle dateType:HNASelDateTypeAirLine];
}

- (void)requestDate:(DatePieckerDoneBlock)block
{
    _datePickerblock = [block copy];
}

//初始化起始和终止laebel日期
- (void)setTripLabelText:(HNASelectionMode)selectionMode
{
    //日期转换 转成2014.12.12 形式
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];  //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy.MM.dd"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *startDate,*endDate,*firstDate,*secondDate;
    if (self.selectionMode == HNASelectionModeSingle) {
        startDate = [dateFormat stringFromDate:_beginDate];
        endDate = @"";
        [dateFormat setDateFormat:@"yyyy年MM月dd日          eeee"];
        firstDate = [dateFormat stringFromDate:_beginDate];
        secondDate = @"";
    }else
    {
        startDate = [dateFormat stringFromDate:_beginDate];
        endDate = [dateFormat stringFromDate:_endDate];
        [dateFormat setDateFormat:@"yyyy年MM月dd日          eeee"];
        firstDate = [dateFormat stringFromDate:_beginDate];
        secondDate = [dateFormat stringFromDate:_endDate];
    }
    [(HNADateView *)self.view setBeginDateLabelText:startDate];
    [(HNADateView *)self.view setEndDateLabelText:endDate];
    
    _datePickerblock(firstDate,secondDate);
}

- (HNADateView*)calendarView { return (HNADateView*)self.view; }

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
}

// -----------------------------------------
#pragma mark- HNADateViewDelegate protocol

- (void)didSelectDate:(NSDate *)date
{
    _beginDate = date;
    [self setTripLabelText:self.selectionMode];
}

- (void)didSelectBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    _beginDate = beginDate;
    _endDate = endDate;
    [self setTripLabelText:self.selectionMode];
}

- (void)showPreviousMonth
{
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
}

- (void)showFollowingMonth
{
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
}

- (void)selectDateDone
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        self.preaSuperView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.preaSuperView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.preaSuperView.userInteractionEnabled = YES;
        [(HNADateView *)self.view stopshowAnimationView];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
        //改变状态栏颜色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //把view从window中移除
        [self.view removeFromSuperview];
    }];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
#if PROFILER
    uint64_t start, end;
    struct timespec tp;
    start = mach_absolute_time();
#endif
    
    [[self calendarView] jumpToSelectedMonth];
    
#if PROFILER
    end = mach_absolute_time();
    mach_absolute_difference(end, start, &tp);
    printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
}

// -----------------------------------------------------------------------------------
#pragma mark- UIViewController

- (void)loadView
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    HNADateView *hnaDateView = [[HNADateView alloc] initWithFrame:[[UIScreen mainScreen] bounds] delegate:self logic:logic];
    hnaDateView.viewSelectionMode = self.selectionMode;
    hnaDateView.gridView.selectionMode = self.selectionMode;
    hnaDateView.selectedDateType = self.selectedDateType;
    hnaDateView.gridView.selectedDateType = self.selectedDateType;
    [hnaDateView setDateLabelShowType];
    self.view = hnaDateView;
    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//设置父VIEW
- (void)addPreaSuperView:(UIView *)preaSuperView{
    self.preaSuperView = preaSuperView;
}

//弹出VIEW
- (void)showDatePickerView
{
    //改变状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //把view添加到window中
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self.view];
    //    [self setTripLabelText:self.selectionMode];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -10, self.view.frame.size.width, self.view.frame.size.height);
        self.preaSuperView.transform = CGAffineTransformMakeScale(0.90, 0.90);
        self.preaSuperView.alpha = 0.6;
        self.preaSuperView.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }];
}

#pragma mark -

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
}

@end
