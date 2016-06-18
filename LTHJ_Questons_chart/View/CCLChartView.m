//
//  CCLChartView.m
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/17.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import "CCLChartView.h"
#import "CCLChartModel.h"
#import "UIColor+Hex.h"

#define kViewHeight self.frame.size.height
#define kViewWidth  self.frame.size.width

extern const CGFloat CCLChartScrollView_LeftMargin;
extern const CGFloat CCLChartScrollView_BottomMargin;

/**
 *  最大收盘价标识线距视图顶端距离
 */
static const CGFloat kMaxLineTopMargin = 20.0;
/**
 *  最小收盘价标识线距视图底端距离
 */
static const CGFloat kMinLineBottomMargin = 20.0;

@implementation CCLChartView


- (void)drawRect:(CGRect)rect {

// 在Y轴上的三个标尺点
    const CGPoint kOrigin = CGPointMake(CCLChartScrollView_LeftMargin, self.frame.size.height - CCLChartScrollView_BottomMargin);
    const CGPoint kMaxPoint = CGPointMake(kOrigin.x, kMaxLineTopMargin);
    const CGPoint kMinPoint = CGPointMake(kOrigin.x, kViewHeight - kMinLineBottomMargin);
    NSLog(@"%@", self.chartModelArrM);
    [self p_maxClose];
    [self p_minClose];
    
/*
 * 绘制 最高和最低线(虚线).
 */
    UIBezierPath *dashPath = [UIBezierPath bezierPath];
    [dashPath setLineWidth:1];
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
@end
