/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"

@interface KalView ()
{
    UIView *selfheaderView;
    UIView *monthSelectView;
    NSInteger monthNumber;
    NSMutableArray *jumpArray;
    UILabel *datelabel;
    UILabel *datelableling;
}
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;

@end

static const CGFloat HeaderHeight = 74.f;
static const CGFloat ToolHeight = 44.f;
static const CGFloat ContentViewHeight = 45 * 6 - 25;
@implementation KalView

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
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

- (void)setViewSelectionMode:(KalSelectionMode)viewSelectionMode
{
    if (viewSelectionMode == KalSelectionModeSingle) {
        datelabel.text = @"起程时间: ";
    }else
    {
        datelabel.text = @"往返时间: ";
    }
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
    const CGFloat kMonthLabelWidth = 100.0f;
    const CGFloat kHeaderVerticalAdjust = 0.f;
    const CGFloat MonthLabelHeight = 44.0f;
    // Draw the selected month name centered and at the top of the view
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
    //add whith lin
    UIView *whiteLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, self.width, 1)];
    whiteLineView.backgroundColor = kTextWhiteColor;
    [headerView addSubview:whiteLineView];
    
    // Add column labels for each weekday (adjusting based on the current locale's first weekday)
    NSArray *weekdayNames = [[[NSDateFormatter alloc] init] veryShortStandaloneWeekdaySymbols];
    static CGFloat width = 46.0f;
    static CGFloat height = 30.0f;
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
    // Both the tile grid and the list of events will automatically lay themselves
    // out to fit the # of weeks in the currently displayed month.
    // So the only part of the frame that we need to specify is the width.
    CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);
    
    // The tile grid (the calendar body)
    self.gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:self.delegate];
    [self.gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [contentView addSubview:self.gridView];
    
    // Trigger the initial KVO update to finish the contentView layout
    [self.gridView sizeToFit];
}

- (void)addSubviewsToToolView:(UIView *)toolView
{

    const CGFloat tdonebuttonWidth = 80.f;
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
    

    UIButton *dateDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateDoneButton.frame = CGRectMake(self.width - tdonebuttonWidth, 0, tdonebuttonWidth, 44);
    [dateDoneButton setTitle:@"完成" forState:UIControlStateNormal];
    [dateDoneButton setTitleColor:kGridRedColor forState:UIControlStateNormal];
    [dateDoneButton addTarget:self action:@selector(clinkButtonDateDone) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:dateDoneButton];
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

//设置去程时间
- (void)setBeginDateLabelText:(NSString *)beginDateLabelText
{
    beginDateLabel.text = beginDateLabelText;
}
//设置返程时间
- (void)setEndDateLabelText:(NSString *)endDateLabelText
{
    endDateLabel.text = endDateLabelText;
    datelableling.hidden = NO;
}

- (void)jumpToSelectedMonth { [self.gridView jumpToSelectedMonth]; }

- (BOOL)isSliding { return self.gridView.transitioning; }

- (void)markVacationForDates:(NSArray *)dates {[self.gridView markVacationForDates:dates];}

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
    [UIView animateWithDuration:0.5 animations:^{
        if (monthSelectView.frame.size.height == 0) {
            monthSelectView.frame = CGRectMake(0, selfheaderView.frame.origin.y + 44, self.width, ContentViewHeight + 2 *ToolHeight);
            [monthSelectView setAlpha:0.96];
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

//日期转换 转成月 形式
- (NSString *)changeDateType:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];  //实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy.MM"];//设定时间格式,这里可以设置成自己需要的格式
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

- (void)addSelectMonthButton:(UIView *)monthSelectedView
{
    
}
@end
