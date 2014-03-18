/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

@implementation KalMonthView

@synthesize numWeeks,vacationsDay;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        tileAccessibilityFormatter = [[NSDateFormatter alloc] init];
        [tileAccessibilityFormatter setDateFormat:@"EEEE, MMMM d"];
        self.opaque = NO;
        self.clipsToBounds = YES;
        for (int i=0; i<6; i++) {
            for (int j=0; j<7; j++) {
                CGRect r = CGRectMake(j* (kTileSize.width), i* (kTileSize.height + 1), kTileSize.width, kTileSize.height);
                [self addSubview:[[KalTileView alloc] initWithFrame:r]];
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
            KalTileView *tile = [self.subviews objectAtIndex:tileNum];
            [tile resetState];
            tile.date = d;
            if ((minAvailableDate && [d compare:minAvailableDate] == NSOrderedAscending) || (maxAvailableDate && [d compare:maxAvailableDate] == NSOrderedDescending)) {
                tile.type = KalTileTypeDisable;
            }
            if (i == 0 && j == 0) {
                tile.type |= KalTileTypeFirst;
            }
            if (i == 2 && j == dates[i].count-1) {
                tile.type |= KalTileTypeLast;
            }
            if (dates[i] != mainDates) {
                tile.type |= KalTileTypeAdjacent;
            }
            if ([d isToday]) {
                tile.type |= KalTileTypeToday;
            }
            if ([self isVacationDay:tile]) {
                tile.type |= KalTileTypeVacation;
            }
            tileNum++;
        }
    }
    
    //-> 设置为固定的6行
//    numWeeks = ceilf(tileNum / 7.f);
    numWeeks = 6;
    [self sizeToFit];
    [self setNeedsDisplay];
}

- (void)markVacationForDates:(NSArray *)dates
{
    self.vacationsDay = dates;
}

- (BOOL)isVacationDay:(KalTileView *)tileDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];  //实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
     NSString *currentDateStr = [dateFormat stringFromDate:tileDate.date];
    return [self.vacationsDay containsObject:currentDateStr];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"kal_tile.png"] CGImage]);
}

- (KalTileView *)firstTileOfMonth
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if (!t.belongsToAdjacentMonth) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

- (KalTileView *)tileForDate:(NSDate *)date
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
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

#pragma mark -


@end
