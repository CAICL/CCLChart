//
//  CCLChartView.h
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/19.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLChartScrollView.h"

extern const CGFloat CCLChartScrollView_LeftMargin;
extern const CGFloat CCLChartScrollView_BottomMargin;

@interface CCLChartView : UIView
@property (nonatomic, strong) CCLChartScrollView  *scrollView;
@property (nonatomic, strong) UIButton *changeDaysBtn;
/**
 *  保存模型类数据的数组
 */
@property (nonatomic, weak)   NSMutableArray *chartModelArrM;
@property (nonatomic, assign) CGFloat scale_X;






@end
