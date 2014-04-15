//
//  rootViewController.m
//  HNACalendarChoice
//
//  Created by Curry on 14-3-14.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import "rootViewController.h"
#import "AppDelegate.h"
#import "NSDate+Convenience.h"
#import "HNADatePicker.h"
@interface rootViewController ()
{
    HNADatePicker *hnaDatePicker;
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

//#define Single
#ifdef Single
        hnaDatePicker = [[HNADatePicker alloc] initWithSelectionMode:HNASelectionModeSingle dateType:HNASelDateTypeAirLine];
        hnaDatePicker.beginDate = [NSDate dateStartOfDay:[NSDate date]];
#else
        hnaDatePicker = [[HNADatePicker alloc] initWithSelectionMode:HNASelectionModeRange dateType:HNASelDateTypeAirLine];
        //-> 多选时设置的开始时间和结束时间
        //    HNA.selectedDate = [NSDate dateStartOfDay:[NSDate date]];
        hnaDatePicker.beginDate = [NSDate dateStartOfDay:[NSDate date]];
        hnaDatePicker.endDate = [NSDate dateStartOfDay:[NSDate date]];
#endif
        
        [hnaDatePicker requestDate:^(NSString *startDate, NSString *endDate) {
            firstlabel.text = startDate;
            secondlabel.text = endDate;
        }];
        [hnaDatePicker addPreaSuperView:self.view];
        
        //
        self.view.backgroundColor = [UIColor yellowColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 100, 100, 100);
        [button setTitle:@"选择日期" forState:0];
        [button setTitleColor:[UIColor blackColor] forState:0];
        button.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(selectdate:) forControlEvents:UIControlEventTouchUpInside];
        
        firstlabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 230, 300, 20)];
        firstlabel.textColor = [UIColor blackColor];
        [self.view addSubview:firstlabel];
        
        secondlabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 270, 300, 20)];
        [self.view addSubview:secondlabel];
        firstlabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)selectdate:(id)sender
{
    [hnaDatePicker showDatePickerView];
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
