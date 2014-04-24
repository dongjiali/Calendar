//
//  HNAMonthView.m
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "HNAMonthView.h"
#import "HNATileView.h"
#import "HNADateView.h"
#import "Hna_datapicker.h"

extern const CGSize kTileSize;

@implementation HNAMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        self.vacationArray = [self getVacationArray];
        tileAccessibilityFormatter = [[NSDateFormatter alloc] init];
        [tileAccessibilityFormatter setDateFormat:@"EEEE, MMMM d"];
        self.opaque = NO;
        self.clipsToBounds = YES;
        for (int i=0; i<6; i++) {
            for (int j=0; j<7; j++) {
                CGRect r = CGRectMake(j* (kTileSize.width), i* (kTileSize.height + 0.5), kTileSize.width, kTileSize.height);
                 HNATileView *tileview = [[HNATileView alloc] initWithFrame:r];
                [self addSubview:tileview];
            }
        }
    }
    return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *) trailingAdjacentDates minAvailableDate:(NSDate *)minAvailableDate maxAvailableDate:(NSDate *)maxAvailableDate
{
    int tileNum = 0;
    NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
    
    for (int i=0; i<3; i++) {
        for (int j=0; j<dates[i].count; j++) {
            NSDate *d = dates[i][j];
            HNATileView *tile = [self.subviews objectAtIndex:tileNum];
            [tile resetState];
            tile.date = d;
            if ((minAvailableDate && [d compare:minAvailableDate] == NSOrderedAscending) || (maxAvailableDate && [d compare:maxAvailableDate] == NSOrderedDescending)) {
                tile.type = HNATileTypeDisable;
            }
            if (i == 0 && j == 0) {
                tile.type |= HNATileTypeFirst;
            }
            if (i == 2 && j == dates[i].count-1) {
                tile.type |= HNATileTypeLast;
            }
            if (dates[i] != mainDates) {
                tile.type |= HNATileTypeAdjacent;
            }
            if ([d isToday]) {
                tile.type |= HNATileTypeToday;
            }
            tile.isVacation = [self isVacationDay:tile.date];
    
            tileNum++;
        }
    }
    
    //-> 设置为固定的6行
    //    numWeeks = ceilf(tileNum / 7.f);
    numWeeks = 6;
    [self sizeToFit];
    [self setNeedsDisplay];
}

//判断是否为假期
- (BOOL )isVacationDay:(NSDate *)tileDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];  //实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:tileDate];
    return [self.vacationArray containsObject:currentDateStr];
}

- (NSMutableArray *)getVacationArray
{
     NSMutableArray *array = [NSMutableArray arrayWithObjects:@"2014-04-18",@"2014-04-19",@"2014-04-21",@"2014-04-22", nil];
    return array;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"HNA_tile.png"] CGImage]);
}

- (HNATileView *)firstTileOfMonth
{
    HNATileView *tile = nil;
    for (HNATileView *t in self.subviews) {
        if (!t.belongsToAdjacentMonth) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

- (HNATileView *)tileForDate:(NSDate *)date
{
    HNATileView *tile = nil;
    for (HNATileView *t in self.subviews) {
        if ([t.date isEqualToDate:date]) {
            tile = t;
            break;
        }
    }
    return tile;
}

- (void)sizeToFit
{
    self.height = 1.f + kTileSize.height * numWeeks;
}
@end
