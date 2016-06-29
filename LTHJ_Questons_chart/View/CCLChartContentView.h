//
//  CCLChartView.h
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/17.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CCLChartContentView : UIView

/**
 *  保存模型类数据的数组
 */
@property (nonatomic, weak)   NSMutableArray *chartModelArrM;
@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) CGFloat scale_X;
/**
 *  chartView视图上的引用 用来显示左边和底部 十字线 相交是的数据
 */
@property (nonatomic, weak) UIView *showDateAndCloseView;

/**
 *  模型数组count 减去 天数值
 */
@property (nonatomic, assign) NSInteger modelArrayCountMoreThanDays;
/**
 *  十字线相交Y轴 显示 收盘价
 */
@property (nonatomic, copy) NSString *leftCloseString;
/**
 *  十字线相交X轴 显示 日期
 */
@property (nonatomic, copy) NSString *bottomDateString;
@property (nonatomic, strong) NSArray *currentPageModelArrM;



@end
