//
//  rootViewController.m
//  HNACalendarChoice
//
//  Created by Curry on 14-3-14.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import "rootViewController.h"
#import "AppDelegate.h"
#import "Kal.h"
#import "NSDate+Convenience.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface rootViewController ()
{
    KalViewController *kalViewController;
    id dataSource;
    UILabel *firstlabel;
    UILabel *secondlabel;
}
@end

@implementation rootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //假期数据数组
        NSArray *vacations = [NSArray arrayWithObjects:@"2014-03-08",@"2014-03-09",@"2014-03-10", nil];
//#define Single
#ifdef Single
        kalViewController = [[KalViewController alloc] initWithSelectionMode:KalSelectionModeSingle];
        kalViewController.vacationDate = vacations;
        kalViewController.selectedDate = [NSDate dateStartOfDay:[NSDate date]];
#else
        kalViewController = [[KalViewController alloc] initWithSelectionMode:KalSelectionModeRange];
        //-> 多选时设置的开始时间和结束时间
        //    kal.selectedDate = [NSDate dateStartOfDay:[NSDate date]];
        kalViewController.vacationDate = vacations;
        kalViewController.beginDate = [NSDate dateStartOfDay:[NSDate date]];
        kalViewController.endDate = [NSDate dateStartOfDay:[NSDate date]];
#endif
        kalViewController.selectDateDelegate = self;
        [kalViewController addPreaSuperView:self.view];
        
        
        self.view.backgroundColor = [UIColor yellowColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 100, 100, 100);
        [button setTitle:@"选择日期" forState:0];
        [button setTitleColor:[UIColor blackColor] forState:0];
        button.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(selectdate:) forControlEvents:UIControlEventTouchUpInside];
        
        firstlabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 230, 200, 20)];
        firstlabel.textColor = [UIColor blackColor];
        [self.view addSubview:firstlabel];
        
        secondlabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 270, 200, 20)];
        [self.view addSubview:secondlabel];
        firstlabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)requestDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    firstlabel.text = [self changeDateType:startDate];
    secondlabel.text = [self changeDateType:endDate];
}

//日期转换 转成2014.12.12 形式
- (NSString *)changeDateType:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];  //实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy.MM.dd eeee"];//设定时间格式,这里可以设置成自己需要的格式
    return [dateFormat stringFromDate:date];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)selectdate:(id)sender
{
    [kalViewController showDatePickerView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
