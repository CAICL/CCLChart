//
//  CCLChartView.h
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/17.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CCLChartContentViewBlock)(CGSize);

@interface CCLChartContentView : UIView
/// 保存模型类数据的数组
@property (nonatomic, weak)   NSMutableArray *chartModelArrM;
@property (nonatomic, assign) BOOL            isZoom;
@property (nonatomic, copy)   CCLChartContentViewBlock chartContentViewBlock;

@end
