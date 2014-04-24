//
//  HNA.h
//  HaiHangHui
//
//  Created by Curry on 14-3-24.
//  Copyright (c) 2014年 HaiHangHui. All rights reserved.
//

#ifndef HaiHangHui_Hna_datapicker_h
#define HaiHangHui_Hna_datapicker_h

#define RGBCOLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


#define HGridRedColor        RGBCOLOR(218, 56, 43)          //深红     ---所有红
#define HWeekBackGroundColor RGBCOLOR(225, 96, 85)          //周的背景色  ----浅红
#define HDarkGrayColor       RGBCOLOR(46, 53, 75)           //本月可选日期颜色  ---深蓝色
#define HDateLabelColor      RGBCOLOR(94, 127, 220)         //tool日期颜色
#define HTextWhiteColor      RGBCOLOR(249, 249, 249)        //选中的的日期颜色 ---所有白
#define HTintLineColor       RGBCOLOR(200, 199, 205)        //浅色灰线的颜色 背景色
#define HDarkLineColor       RGBCOLOR(127, 127, 127)        //深色灰线的颜色 背景色
#define HGrayColor           RGBCOLOR(189, 191, 199)        //不可选的日期颜色
#define HbackgroundGrayColor RGBCOLOR(248, 248, 248)        //深灰背景 > 其它月份的字的背景色

#define HGridViewWidth 46.0f
#define HGridViewHeight 44.0f
#endif

#import "UIViewAdditions.h"
#import "NSDateAdditions.h"
#import "NSDate+Convenience.h"