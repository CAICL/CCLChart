//
//  ViewController.m
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/17.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import "ViewController.h"
#import "CCLChartModel.h"

#import "CCLChartView.h"
#import "Masonry.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) CCLChartView *chartView;

/**
 *  保存接收的数据的数组(现为假数据)
 */
@property (nonatomic , strong) NSArray *chartDataArr;
/**
 *  保存数据模型对象的数组
 */
@property (nonatomic, strong) NSMutableArray *chartModelArrM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.chartView.chartModelArrM = self.chartModelArrM;
    self.chartView.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.chartView.contentOffsetInScrolling = scrollView.contentOffset;
}


#pragma mark - lazy loading

- (CCLChartView *)chartView {
    if(_chartView == nil) {
        _chartView = [[CCLChartView alloc] init];
        [self.view addSubview:_chartView];
        [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(100);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(400);
        }];
        
    }
    return _chartView;
}

- (NSArray *)chartDataArr {
    if (_chartDataArr == nil) {
        _chartDataArr = @[  @"1月5日/3478.78", @"1月6日/3539.81", @"1月7日/3294.38", @"1月8日/3361.56", @"1月11日/3192.45", @"1月12日/3215.71", @"1月13日/3155.88", @"1月14日/3221.57", @"1月15日/3118.73", @"1月18日/3130.73", @"1月19日/3223.13", @"1月20日/3174.38", @"1月21日/3081.35", @"1月22日/3113.46", @"1月25日/3128.89", @"1月26日/2940.51", @"1月27日/2930.35", @"1月28日/2853.76", @"1月29日/2946.09", @"2月1日/2901.05", @"2月2日/2961.33", @"2月3日/2948.64", @"2月4日/2984.76", @"2月5日/2963.79", @"2月15日/2946.71"];
    }
    return _chartDataArr;
}
- (NSArray *)chartModelArrM {
	if(_chartModelArrM == nil) {
		_chartModelArrM = [[NSMutableArray alloc] init];
        
        for (NSString *str in self.chartDataArr) {
            NSArray *strArr = [str componentsSeparatedByString:@"/"];
            CCLChartModel *model = [CCLChartModel new];
            model.chartDate = strArr[0];
            model.chartClose = strArr[1];
            [_chartModelArrM addObject:model];
        }
        
	}
	return _chartModelArrM;
}




@end
