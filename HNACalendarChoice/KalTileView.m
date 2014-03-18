/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalPrivate.h"
#import <CoreText/CoreText.h>

extern const CGSize kTileSize;

@implementation KalTileView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.backgroundColor = kTextWhiteColor;
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

    CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);

    if (self.isDisable) {
        textColor = kGrayColor;
    } else if (self.belongsToAdjacentMonth) {
        //-> 其它月份的字的背景色
        [kbackgroundGrayClor setFill];
        CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
        textColor = kGrayColor;
    } else {
        textColor = kDarkGrayColor;
        if (self.isToday)
        {
            textColor = kGridRedColor;
        }
    }
        //->判断是否为假期
    if (self.isVacation) {
        UIImage *vacationImage = [UIImage imageNamed:@"kal_tile_selected.png"];
        [vacationImage drawInRect:CGRectMake(2.f, 2.f, 15.f, 15.f)];
    }
    
    if (self.state == KalTileStateHighlighted || self.state == KalTileStateSelected) {
        UIImage *image = [UIImage imageNamed:@"kal_tile_selected.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin.x = (kTileSize.width - frame.size.width) / 2;
        frame.origin.y = (kTileSize.height - frame.size.height) / 2;
        [image drawInRect:frame];
        textColor = kTextWhiteColor;
        if (self.isToday) {
            image = [UIImage imageNamed:@"kal_tile_selected_today.png"];
            textColor = kGridRedColor;
        }
    } else if (self.state == KalTileStateLeftEnd) {
        UIImage *image = [UIImage imageNamed:@"kal_tile_range_left.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin.x = (kTileSize.width - frame.size.width) / 2;
        frame.origin.y = (kTileSize.height - frame.size.height) / 2;
        [image drawInRect:frame];
        textColor = kTextWhiteColor;
        if (self.isToday) {
            image = [UIImage imageNamed:@"kal_tile_range_left_today.png"];
            textColor = kTextWhiteColor;
        }
    } else if (self.state == KalTileStateRightEnd) {
        UIImage *image = [UIImage imageNamed:@"kal_tile_range_right.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin.x = (kTileSize.width - frame.size.width) / 2;
        frame.origin.y = (kTileSize.height - frame.size.height) / 2;
        [image drawInRect:frame];
        textColor = kTextWhiteColor;
        if (self.isToday) {
            image = [UIImage imageNamed:@"kal_tile_range_right_today.png"];
            textColor = kTextWhiteColor;
        }
    } else if (self.state == KalTileStateInRange) {
        UIImage *image = [UIImage imageNamed:@"kal_tile_range.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin.y = (kTileSize.height - frame.size.height) / 2;
        textColor = kTextWhiteColor;
        [image drawInRect:frame];
    }
    
    NSUInteger n = [self.date day];
    NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
    if (self.isToday)
    {
//        dayText = NSLocalizedString(@"Today", @"");
    }
    CGSize textSize = [dayText sizeWithFont:font];
    CGFloat textX, textY;
    textX = roundf(0.5f * (kTileSize.width - textSize.width));
    textY = roundf(0.5f * (kTileSize.height - textSize.height));
    [textColor setFill];
    [dayText drawAtPoint:CGPointMake(textX, textY) withFont:font];
}

- (void)resetState
{
    // realign to the grid
    CGRect frame = self.frame;
    frame.origin = origin;
    frame.size = kTileSize;
    self.frame = frame;
    
    self.date = nil;
    _type = KalTileTypeRegular;
    self.state = KalTileStateNone;
}

- (void)setDate:(NSDate *)aDate
{
    if (_date == aDate)
        return;
    
    _date = aDate;
    
    [self setNeedsDisplay];
}

- (void)setState:(KalTileState)state
{
    if (_state != state) {
        _state = state;
        [self setNeedsDisplay];
    }
}

- (void)setType:(KalTileType)tileType
{
    if (_type != tileType) {
        _type = tileType;
        [self setNeedsDisplay];
    }
}

- (BOOL)isToday { return self.type & KalTileTypeToday; }
- (BOOL)isFirst { return self.type & KalTileTypeFirst; }
- (BOOL)isLast { return self.type & KalTileTypeLast; }
- (BOOL)isDisable { return self.type & KalTileTypeDisable; }
- (BOOL)isVacation { return self.type & KalTileTypeVacation; }

- (BOOL)belongsToAdjacentMonth { return self.type & KalTileTypeAdjacent; }

@end
