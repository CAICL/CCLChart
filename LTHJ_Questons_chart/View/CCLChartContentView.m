//
//  CCLChartView.m
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/17.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import "CCLChartContentView.h"
#import "CCLChartModel.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

#define kViewHeight self.frame.size.height
#define kViewWidth  self.frame.size.width

extern const CGFloat CCLChartScrollView_LeftMargin;
extern const CGFloat CCLChartScrollView_BottomMargin;

/**
 *  最大收盘价标识线距视图顶端距离
 */
static const CGFloat kMaxLineTopMargin = 10.0;
/**
 *  最小收盘价标识线距X轴距离
 */
static const CGFloat kMinLineBottomMargin = 10.0;

@implementation CCLChartContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isZoom = false;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {

// 在Y轴上的三个标尺点
    const CGPoint kOrigin = CGPointMake(CCLChartScrollView_LeftMargin, self.frame.size.height - CCLChartScrollView_BottomMargin);
    const CGPoint kMaxPoint = CGPointMake(kOrigin.x, kMaxLineTopMargin);
    const CGPoint kMinPoint = CGPointMake(kOrigin.x, kOrigin.y - kMinLineBottomMargin);
    NSLog(@"%@", self.chartModelArrM);
// 计算Y轴刻度
//    float midValue =  [self p_maxClose] - [self p_minClose];
//    CGFloat midPx =  kMinPoint.y - kMaxPoint.y;
    float maxClose = [self p_maxClose];
    float minClose = [self p_minClose];
    float originClose = minClose -  (int)minClose % 10;
    CGFloat scale_Y = (kOrigin.y - kMaxPoint.y) / (maxClose - originClose);
    
    
    
/// Y轴刻度  收盘价 y坐标 = kOrigin.y - scale_Y * (model.chartClose.floatValue - originClose)
    //CGFloat scale_Y = midPx / midValue;
    NSLog(@"Y轴刻度 %lf", scale_Y);
// 计算X轴刻度
    int days = 0;
    if (self.isZoom == true) {
        days = 10;
    }else {
        days = 20;
    }
    CGFloat scale_X = [self p_scaleXwithDays:days];
    

    
/*
 * 绘制 最高和最低线(虚线).
 */
    UIBezierPath *dashPath = [UIBezierPath bezierPath];
    [dashPath setLineWidth:0.5];
    CGFloat dashPattern[] = {5,5};// 3实线，1空白
    [dashPath setLineDash:dashPattern count:2 phase:1];
    [[UIColor colorWithHex:0x4A90E2] setStroke];
    // maxline
    [dashPath moveToPoint: kMaxPoint];
    [dashPath addLineToPoint:CGPointMake(kViewWidth, kMaxPoint.y)];
    // minline
    [dashPath moveToPoint:kMinPoint];
    [dashPath addLineToPoint:CGPointMake(kViewWidth , kMinPoint.y)];
    
    [dashPath stroke];
   
/*
 * 绘制收盘价走势图
 */
    UIBezierPath *closePath = [UIBezierPath bezierPath];
    closePath.lineWidth = 1;
    closePath.lineJoinStyle = 2;
    for (int i = 0; i < self.chartModelArrM.count; i++) {
        CCLChartModel *model = self.chartModelArrM[i];
        CGPoint closePoint = CGPointMake(kOrigin.x + i * scale_X,kOrigin.y -  (model.chartClose.floatValue - originClose) * scale_Y );
       // NSLog(@"(%lf,%lf)", closePoint.x, closePoint.y);
        if (i == 0) {
            [closePath moveToPoint:closePoint];
        }
        [closePath addLineToPoint:closePoint];
        NSLog(@"%@ %lf", model.chartDate,closePoint.y );
    }
    [closePath stroke];
    
     NSLog(@"height %f", kViewHeight);
    

}

#pragma 私有方法

/// 返回的最高的收盘价
- (float)p_maxClose {
    float maxClose = 0.0;
    for (CCLChartModel *model in self.chartModelArrM) {
        if (maxClose < model.chartClose.floatValue) {
            maxClose = model.chartClose.floatValue;
        }
    }
    NSLog(@"最大的收盘价为%f", maxClose);
    return maxClose;
}

/// 返回最低的收盘价
- (float)p_minClose {
    float minClose = MAXFLOAT;
    for (CCLChartModel *model in self.chartModelArrM) {
        if (minClose > model.chartClose.floatValue) {
            minClose = model.chartClose.floatValue;
        }
    }
    NSLog(@"最小的收盘价为%f", minClose);
    return minClose;
}
/// 计算X轴刻度
- (CGFloat)p_scaleXwithDays:(int)days {
    
    return ([UIScreen mainScreen].bounds.size.width - CCLChartScrollView_LeftMargin) / days;
}
@end
