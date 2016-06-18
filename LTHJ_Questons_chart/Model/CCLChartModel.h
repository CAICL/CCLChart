//
//  CCLChartModel.h
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/17.
//  Copyright © 2016年 CAICL. All rights reserved.
//

/*
 模型类 ---------- 收盘价曲线图
 */

#import <Foundation/Foundation.h>

@interface CCLChartModel : NSObject
/// 交易日期
@property (nonatomic, copy) NSString *chartDate;
/// 收盘价
@property (nonatomic, copy) NSString *chartClose;


@end
