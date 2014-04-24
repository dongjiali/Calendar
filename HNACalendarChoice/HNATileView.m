//
//  HNATileView.m
//  HNACalendarChoice
//
//  Created by Curry on 14-3-20.
//  Copyright (c) 2014年 HNACalendarChoice. All rights reserved.
//

#import "HNATileView.h"
#import "Hna_datapicker.h"
#import <CoreText/CoreText.h>

extern const CGSize kTileSize;

@implementation HNATileView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.backgroundColor = HTextWhiteColor;
        self.clipsToBounds = NO;
        origin = frame.origin;
        [self setIsAccessibilityElement:YES];
        [self setAccessibilityTraits:UIAccessibilityTraitButton];
        [self resetState];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat fontSize = 17;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    UIColor *textColor = nil;
    
    if (self.isDisable) {
        textColor = HGrayColor;
    } else if (self.belongsToAdjacentMonth) {
        //-> 其它月份的字的背景色
        [HTextWhiteColor setFill];
        CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
        
        textColor = HGrayColor;
    } else {
        textColor = HDarkGrayColor;
        if (self.isToday)
        {
            textColor = HGridRedColor;
        }
    }
    //画线
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 200.0/255, 199.0/255,205.0/255.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 0);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 0, kTileSize.height);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    if (self.state == HNATileStateHighlighted || self.state == HNATileStateSelected) {
        UIImage *image = [UIImage imageNamed:@"DateImage.bundle/HNA_tile_selected"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin.x = (kTileSize.width - frame.size.width) / 2;
        frame.origin.y = (kTileSize.height - frame.size.height) / 2;
        [image drawInRect:frame];
        textColor = HGridRedColor;
        if (self.isToday) {
            image = [UIImage imageNamed:@"DateImage.bundle/HNA_tile_today"];
            textColor = HGridRedColor;
        }
    } else if (self.state == HNATileStateLeftEnd) {
        UIImage *image = [UIImage imageNamed:@"DateImage.bundle/HNA_tile_range_left"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin.x = (kTileSize.width - frame.size.width) / 2;
        frame.origin.y = (kTileSize.height - frame.size.height) / 2;
        [image drawInRect:frame];
        textColor = HGridRedColor;
    } else if (self.state == HNATileStateRightEnd) {
        UIImage *image = [UIImage imageNamed:@"DateImage.bundle/HNA_tile_range_right"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin.x = (kTileSize.width - frame.size.width) / 2;
        frame.origin.y = (kTileSize.height - frame.size.height) / 2;
        [image drawInRect:frame];
        textColor = HGridRedColor;
    } else if (self.state == HNATileStateInRange) {
        UIImage *image = [UIImage imageNamed:@"DateImage.bundle/HNA_tile_range"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin.y = (kTileSize.height - frame.size.height) / 2;
        textColor = HTextWhiteColor;
        [image drawInRect:frame];
    }
    
    //判断是否为节假日
    if (self.isVacation && !self.isToday) {
        UIImage *image = [UIImage imageNamed:@"DateImage.bundle/HNA_tile_holiday"];
        CGRect frame = CGRectMake(2, 0, 10, 10);
        [image drawInRect:frame];
    }
    
    NSUInteger n = [self.date day];
    NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
    CGSize textSize = [dayText sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat textX, textY;
    textX = roundf(0.5f * (kTileSize.width - textSize.width));
    textY = roundf(0.5f * (kTileSize.height - textSize.height));
    [dayText drawAtPoint:CGPointMake(textX, textY) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    
    if (self.isToday) {
        textColor = HGridRedColor;
        [@"今" drawAtPoint:CGPointMake(2, 0) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:textColor}];
    }
}

- (void)resetState
{
    // realign to the grid
    CGRect frame = self.frame;
    frame.origin = origin;
    frame.size = kTileSize;
    self.frame = frame;
    
    self.date = nil;
    _type = HNATileTypeRegular;
    self.state = HNATileStateNone;
}

- (void)setDate:(NSDate *)aDate
{
    if (_date == aDate)
        return;
    
    _date = aDate;
    
    [self setNeedsDisplay];
}

- (void)setState:(HNATileState)state
{
    if (_state != state) {
        _state = state;
        [self setNeedsDisplay];
    }
}

- (void)setType:(HNATileType)tileType
{
    if (_type != tileType) {
        _type = tileType;
        [self setNeedsDisplay];
    }
}

- (BOOL)isToday { return self.type & HNATileTypeToday; }
- (BOOL)isFirst { return self.type & HNATileTypeFirst; }
- (BOOL)isLast { return self.type & HNATileTypeLast; }
- (BOOL)isDisable { return self.type & HNATileTypeDisable; }
- (BOOL)belongsToAdjacentMonth { return self.type & HNATileTypeAdjacent; }

@end
