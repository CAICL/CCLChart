//
//  CCLChartView.h
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/19.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import <UIKit/UIKit.h>


extern const CGFloat CCLChartScrollView_LeftMargin;
extern const CGFloat CCLChartScrollView_BottomMargin;

@interface CCLChartView : UIView

/**
 *  用于滑动的scrollView 使用时在Controller中 设置 UIScrollView的代理
 */
@property (nonatomic, strong) UIScrollView  *scrollView;

/**
 *  保存模型类数据的数组
 */
@property (nonatomic, weak)   NSMutableArray *chartModelArrM;

/**
 *  使用在"UIScrollViewDelegate" 方法 scrollViewDidScroll 中 
 *  动态接收 scrollView 滑动进行中 的滑动距离 
 */
@property (nonatomic, assign) CGPoint contentOffsetInScrolling;





@end
