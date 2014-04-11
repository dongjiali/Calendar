//
//  HNADateView.m
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import "HNADateView.h"
#import "HNADateView.h"
#import "HNAGridView.h"
#import "HNALogic.h"
#import "UIViewAdditions.h"
#import "NSDateAdditions.h"

@interface HNADateView ()
{
    UIView *selfheaderView;
    UIView *monthSelectView;
    NSInteger monthNumber;
    NSMutableArray *jumpArray;
    UILabel *datelabel;
    UILabel *datelableling;

    UILabel *headerTitleLabel;
    UILabel *beginDateLabel;
    UILabel *endDateLabel;
    CGPoint oldLocation;
    HNALogic *logic;
}
@end

static const CGFloat HeaderHeight = 64.f;
static const CGFloat ToolHeight = 44.f;
static const CGFloat ContentViewHeight = 44 * 6;
@implementation HNADateView

- (id)initWithFrame:(CGRect)frame delegate:(id<HNAViewDelegate>)theDelegate logic:(HNALogic *)theLogic
{
    if ((self = [super initWithFrame:frame])) {
        self.delegate = theDelegate;
        logic = theLogic;
        
        [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        CGRect headerViewframe = CGRectMake(0, screenHeight - (HeaderHeight + ToolHeight) - ContentViewHeight, self.width, HeaderHeight);
        selfheaderView = [[UIView alloc] initWithFrame:headerViewframe];
        selfheaderView.backgroundColor = kGridRedColor;
        selfheaderView.layer.cornerRadius = 5.0;
        [self addSubviewsToHeaderView:selfheaderView];
        [self addSubview:selfheaderView];
        
        CGRect contentViewframe = CGRectMake(0, screenHeight - ToolHeight - ContentViewHeight, self.width, ContentViewHeight);
        UIView *contentView = [[UIView alloc] initWithFrame:contentViewframe];
        contentView.backgroundColor = KTintLineColor;
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubviewsToContentView:contentView];
        [self addSubview:contentView];
        
        CGRect toolViewframe = CGRectMake(0, screenHeight - ToolHeight, self.width, ToolHeight + 10);
        UIView *toolView = [[UIView alloc]initWithFrame:toolViewframe];
        toolView.backgroundColor = kbackgroundGrayClor;
        [self addSubviewsToToolView:toolView];
        [self addSubview:toolView];
    }
    
    return self;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [self.gridView slideDown]; }
- (void)slideUp { [self.gridView slideUp]; }

- (void)showPreviousMonth
{
    if (!self.gridView.transitioning)
        [self.delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
    if (!self.gridView.transitioning)
        [self.delegate showFollowingMonth];
}

- (void)setDateLabelShowType
{
    NSString *dateshowtext;
    
    if (_viewSelectionMode == HNASelectionModeSingle) {
        dateshowtext = @"起程时间: ";
        if (_selectedDateType == HNASelDateTypeHotle) {
            dateshowtext = @"入住时间";
        }
    }else
    {
        dateshowtext = @"往返时间: ";
        if (_selectedDateType == HNASelDateTypeHotle) {
            dateshowtext = @"入离时间";
        }
    }
    datelabel.text = dateshowtext;
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
    const CGFloat kMonthLabelWidth = 100.0f;
    const CGFloat kHeaderVerticalAdjust = 0.f;
    const CGFloat MonthLabelHeight = 44.0f;
    const CGFloat tdonebuttonWidth = 80.f;
    // 绘制所选月集中和顶部的视图名称
    CGRect monthLabelFrame = CGRectMake((self.width - kMonthLabelWidth)/2,
                                        kHeaderVerticalAdjust,
                                        kMonthLabelWidth,
                                        MonthLabelHeight);
    headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
    headerTitleLabel.backgroundColor = [UIColor clearColor];
    headerTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    headerTitleLabel.textColor = kTextWhiteColor;
    [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
    [headerView addSubview:headerTitleLabel];
    
    UIButton *dateDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateDoneButton.frame = CGRectMake(self.width - tdonebuttonWidth, 0, tdonebuttonWidth, 44);
    [dateDoneButton setTitle:@"完成" forState:UIControlStateNormal];
    [dateDoneButton setTitleColor:kTextWhiteColor forState:UIControlStateNormal];
    [dateDoneButton addTarget:self action:@selector(clinkButtonDateDone) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:dateDoneButton];
    
    //add whith lin
    UIView *whiteLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, self.width, 1)];
    whiteLineView.backgroundColor = kTextWhiteColor;
    [headerView addSubview:whiteLineView];

    // 添加列标签为每个工作日调整基于当前语言环境的第一个工作日
    NSArray *weekdayNames = [[[NSDateFormatter alloc] init] veryShortStandaloneWeekdaySymbols];
    static CGFloat width = 46.0f;
    static CGFloat height = 20.0f;
    for (int i = 0 ;i < 7 ;i++) {
        CGRect weekdayFrame = CGRectMake(i * (width), 44, width, height);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = kWeekLabel;
        weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.textColor = kTextWhiteColor;
        weekdayLabel.text = [weekdayNames objectAtIndex:i];
        [headerView addSubview:weekdayLabel];
    }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{

    CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);
    
    self.gridView = [[HNAGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:self.delegate];

    [self.gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [contentView addSubview:self.gridView];
    
    [self.gridView sizeToFit];
}

- (void)addSubviewsToToolView:(UIView *)toolView
{
    const CGFloat labelwidth = 90.f;
    const CGFloat tlabelHeight = 44;
    const CGFloat tlabelLeft = 10;
    const CGFloat tdatelabelwidth = 85;
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1.5)];
    topLine.backgroundColor = KDarkLineColor;
    [toolView addSubview:topLine];
    
    //显示去返程标签
    datelabel = [[UILabel alloc]initWithFrame:CGRectMake(tlabelLeft, 0, labelwidth, tlabelHeight)];
    datelabel.textColor = kDarkGrayColor;
    datelabel.font = [UIFont systemFontOfSize:14];
    [toolView addSubview:datelabel];
    //显示 -
    datelableling = [[UILabel alloc]initWithFrame:CGRectMake(155, 0, 5, tlabelHeight)];
    datelableling.textColor = kDateLabelColor;
    datelableling.textAlignment = NSTextAlignmentCenter;
    datelableling.text = @"-";
    datelableling.hidden = YES;
    [toolView addSubview:datelableling];
    
    //去程时间日期label
    beginDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 1, tdatelabelwidth, tlabelHeight)];
    beginDateLabel.textAlignment = NSTextAlignmentLeft;
    beginDateLabel.textColor = kDateLabelColor;
    beginDateLabel.font = [UIFont systemFontOfSize:15];
    [toolView addSubview:beginDateLabel];
    
    //回程时间日期label
    endDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 1, tdatelabelwidth, tlabelHeight)];
    endDateLabel.textAlignment = NSTextAlignmentLeft;
    endDateLabel.textColor = kDateLabelColor;
    endDateLabel.font = [UIFont systemFontOfSize:15];
    [toolView addSubview:endDateLabel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.gridView && [keyPath isEqualToString:@"frame"]) {
        
    } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
        [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//完成 选择日期后退出
- (void)clinkButtonDateDone
{
    [self.delegate selectDateDone];
}

//设置标题头数据
- (void)setHeaderTitleText:(NSString *)text
{
    [headerTitleLabel setText:text];
    //    [headerTitleLabel sizeToFit];
    headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

//设置起始时间
- (void)setBeginDateLabelText:(NSString *)beginDateLabelText
{
    beginDateLabel.text = beginDateLabelText;
}
//设置结束时间
- (void)setEndDateLabelText:(NSString *)endDateLabelText
{
    endDateLabel.text = endDateLabelText;
    if(endDateLabelText.length >0)
    datelableling.hidden = NO;
}

- (void)jumpToSelectedMonth { [self.gridView jumpToSelectedMonth]; }

- (BOOL)isSliding { return self.gridView.transitioning; }

- (void)dealloc
{
    [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
    
    [self.gridView removeObserver:self forKeyPath:@"frame"];
}
//添加手滑动手势
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    oldLocation = [touch locationInView:self];
    if (oldLocation.x>=0 && oldLocation.y >=0 && oldLocation.x < self.frame.size.width && oldLocation.y < self.frame.size.height - (HeaderHeight + ToolHeight) - ContentViewHeight) {
        [self clinkButtonDateDone];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint newLocation = [touch locationInView:self];
    if (newLocation.y - oldLocation.y > 20) {
        [self clinkButtonDateDone];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint Location = [touch locationInView:selfheaderView];
    if (CGRectContainsPoint([headerTitleLabel frame], Location)) {
        if (monthSelectView == nil) {
            monthSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, selfheaderView.frame.origin.y + 44, self.width, 0)];
            [self addSubview:monthSelectView];
            monthSelectView.backgroundColor = [UIColor whiteColor];
            [monthSelectView setAlpha:0.7];
            monthSelectView.clipsToBounds = YES;
            jumpArray = [NSMutableArray array];
            for (int i = 0; i<=6; i++) {
                NSDate *date = [logic getAdvanceToFollowingMonthNum:i];
                NSString *string = [self changeDateType:date];
                [jumpArray addObject:string];
                NSArray *textArray = [string componentsSeparatedByString:@"."];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(i%3 * self.width/3, i/3 * 60, self.width/3, 60);
                button.layer.borderColor = KTintLineColor.CGColor;
                button.layer.borderWidth = 0.5;
                button.titleLabel.font = [UIFont boldSystemFontOfSize:40];
                [button setTitleColor:kDarkGrayColor forState:0];
                [button setTitle:[NSString stringWithFormat:@"%d",[textArray[1] intValue]] forState:0];
                button.tag = i;
                [monthSelectView addSubview:button];
                [button addTarget:self action:@selector(selectecMonthNum:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [self startAnimationView];
    }
}


- (void)selectecMonthNum:(UIButton *)btn
{
    int head = [headerTitleLabel.text intValue];
    int select = [jumpArray[btn.tag] intValue];
    int headernum = [headerTitleLabel.text floatValue] * 100;
    int selectnnum = [jumpArray[btn.tag] floatValue] * 100;
    
    selectnnum = (select - head) * 12 + selectnnum%100;
    headernum =  headernum%100;
    int num = selectnnum - headernum;
    if (num >= 0) {
        [self showFollowingMonthNum:num];
    }
    else
    {
        [self showPreviousMonthNum:num];
    }
    [self startAnimationView];
}

- (void)startAnimationView
{
    [UIView animateWithDuration:0.4 animations:^{
        if (monthSelectView.frame.size.height == 0) {
            monthSelectView.frame = CGRectMake(0, selfheaderView.frame.origin.y + 44, self.width, ContentViewHeight + 2 *ToolHeight);
            [monthSelectView setAlpha:0.95];
        }
        else{
            [self stopshowAnimationView];
        }
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        
    }];
}

- (void)stopshowAnimationView
{
    monthSelectView.frame = CGRectMake(0, selfheaderView.frame.origin.y + 44, self.width, 0);
    [monthSelectView setAlpha:0.7];
}

- (NSString *)changeDateType:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy.MM"];
    return [dateFormat stringFromDate:date];
}

- (void)showPreviousMonthNum:(int)num
{
    if (!self.gridView.transitioning)
    {
        [logic retreatToPreviousMonthNum:num];
        [self.gridView slideDown];
    }
}

- (void)showFollowingMonthNum:(int)num
{
    if (!self.gridView.transitioning)
    {
        [logic advanceToFollowingMonthNum:num];
        [self.gridView slideUp];
    }
}

@end