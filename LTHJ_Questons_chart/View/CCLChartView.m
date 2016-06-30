//
//  CCLChartView.m
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/19.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import "CCLChartView.h"
#import "CCLChartModel.h"
#import "CCLChartContentView.h"
#import "Masonry.h"

#define kViewHeight self.frame.size.height
#define kViewWidth  self.frame.size.width
/**
 *  全局常量 chart Y轴距视图左边距
 */
const CGFloat CCLChartView_LeftMargin = 40.0;
/**
 *  全局常量 chart X轴到视图底边距
 */
const CGFloat CCLChartView_BottomMargin = 20.0;

@interface CCLChartView ()

@property (nonatomic, strong) UIButton *changeDaysBtn;
/**
 *  scrollView 的 contentView
 */
@property (nonatomic, strong) CCLChartContentView *contentView;
/**
 *  contentView 十字线 显示 的 label所在的View
 */
@property (nonatomic, strong) UIView *showDateAndCloseView;
/**
 *  当前页面显示天数
 */
@property (nonatomic, assign) NSInteger days;

@end

@implementation CCLChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.scrollView.hidden = NO;
        self.changeDaysBtn.hidden = NO;
        _days = 20;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    const CGPoint kOrigin = CGPointMake(CCLChartView_LeftMargin, kViewHeight -  CCLChartView_BottomMargin);
    
/*
 * 绘制坐标轴
 */
    UIBezierPath *coordinatesPath = [UIBezierPath bezierPath];
    [coordinatesPath moveToPoint:CGPointMake(kOrigin.x, 0)];
    [coordinatesPath addLineToPoint:kOrigin];
    [coordinatesPath addLineToPoint:CGPointMake(kViewWidth, kOrigin.y)];
    
    coordinatesPath.lineWidth = 1;
    [[UIColor blackColor] setStroke];
    [coordinatesPath stroke];
/*
 * 绘制刻度
 */
    UIBezierPath *scale_x_Path = [UIBezierPath bezierPath];
    // 刻度  day - 1
    for (int i = 1; i < self.days; i++) {
        
        [scale_x_Path moveToPoint:CGPointMake(CCLChartView_LeftMargin + i * self.scale_X, kOrigin.y)];
        [scale_x_Path addLineToPoint:CGPointMake(CCLChartView_LeftMargin + i * self.scale_X, 0)];
    }
    scale_x_Path.lineWidth  = 0.2;
    [[UIColor lightGrayColor] setStroke];
    [scale_x_Path stroke];
/* 
 *  初始化contentView
 *  初始化 十字线 显示label所在view
 */
     self.contentView.showDateAndCloseView = self.showDateAndCloseView;
    
}
#pragma mark - 属性 setter method

- (void)setContentOffsetInScrolling:(CGPoint)contentOffsetInScrolling {
    
    NSAssert(self.scale_X > 0, @"scale_X必须 大于0");

    CGFloat location = contentOffsetInScrolling.x / self.scale_X;
     NSRange range = NSMakeRange((NSInteger)location, self.days);
    self.contentView.currentPageModelArrM = [self.chartModelArrM subarrayWithRange:range];
    [self.contentView setNeedsDisplay];
    
}

#pragma mark - Lazy Loading

- (CGFloat)scale_X {
    // kViewWidth - CCLChartView_LeftMargin  == self.scrollView.frame.size.width
    return (kViewWidth - CCLChartView_LeftMargin) / (self.days - 1);
}

-(UIView *)showDateAndCloseView {
    
    if (!_showDateAndCloseView) {
        _showDateAndCloseView = [UIView new];
// 初始化设定为隐藏
        _showDateAndCloseView.hidden = YES;
        _showDateAndCloseView.backgroundColor = [UIColor clearColor];
        [self insertSubview:_showDateAndCloseView atIndex:0];
        [_showDateAndCloseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        UILabel *leftCloseLabel = [UILabel new];

        //leftCloseLabel.backgroundColor = [UIColor redColor];
        leftCloseLabel.text = @"test";
        leftCloseLabel.font = [UIFont systemFontOfSize:9];
        leftCloseLabel.tag = 111000;
        [_showDateAndCloseView addSubview:leftCloseLabel];
        leftCloseLabel.frame = CGRectMake(0, 0, 40, 20);
        UILabel *bottomDateLabel = [UILabel new];
        //bottomDateLabel.backgroundColor = [UIColor redColor];
        bottomDateLabel.text = @"test";
        bottomDateLabel.font = [UIFont systemFontOfSize:10];

        bottomDateLabel.tag = 100000;
        [_showDateAndCloseView addSubview:bottomDateLabel];
        bottomDateLabel.frame = CGRectMake(0, kViewHeight - CCLChartView_BottomMargin, 40, 20);
    }
    return _showDateAndCloseView;
}

- (UIScrollView*)scrollView {
    
	if(_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 1.0;
      
        [self addSubview:_scrollView];

        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.left.mas_equalTo(CCLChartView_LeftMargin);
        }];
	}
	return _scrollView;
}

- (UIButton *)changeDaysBtn {
    
    if(_changeDaysBtn == nil) {
        
        _changeDaysBtn = [UIButton buttonWithType:UIButtonTypeSystem];
       [_changeDaysBtn setTitle:@"10天数据" forState:UIControlStateNormal];
        [_changeDaysBtn setTitle:@"20天数据" forState:UIControlStateSelected];
        _changeDaysBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:_changeDaysBtn];
        [_changeDaysBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-40);
            make.size.mas_equalTo(CGSizeMake(50, 20));
        }];
        [_changeDaysBtn addTarget:self action:@selector(changeDays:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeDaysBtn;
}

- (void)changeDays:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    CGRect frame = CGRectZero;
//
    
    if (sender.selected) {
        
        self.days = 10;
        self.contentView.days = self.days;
        self.contentView.scale_X = self.scale_X;
        frame = self.contentView.frame;
        CGFloat width = (self.chartModelArrM.count - 1) * self.scale_X;
        frame.size = CGSizeMake(width, kViewHeight);
        self.contentView.frame = frame;
        self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        self.scrollView.contentOffset = CGPointMake((self.chartModelArrM.count- self.days) * self.scale_X, 0);
        [self setNeedsDisplay];
        [self.contentView setNeedsDisplay];
  
    }else {
        
        self.days = 20;
        self.contentView.days = self.days;
        self.contentView.scale_X = self.scale_X;
        frame = self.contentView.frame;
        CGFloat width = (self.chartModelArrM.count - 1) * self.scale_X;
        frame.size = CGSizeMake(width, kViewHeight);
        self.contentView.frame = frame;
        self.scrollView.contentSize = CGSizeMake(frame.size.width , frame.size.height);
        self.scrollView.contentOffset = CGPointMake((self.chartModelArrM.count - self.days) * self.scale_X, 0);
        [self setNeedsDisplay];
        [self.contentView setNeedsDisplay];
    }
}

- (CCLChartContentView *)contentView {
    
    if(_contentView == nil) {
        _contentView = [[CCLChartContentView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_contentView];
        NSInteger chartModelArrCount = self.chartModelArrM.count;
        if (chartModelArrCount <= 20) {
            _contentView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width , self.scrollView.frame.size.height);
        }else if (chartModelArrCount > 20 && chartModelArrCount <= 40) {
            CGFloat contentViewWidth = self.scrollView.frame.size.width + (chartModelArrCount-20) * self.scale_X;
            _contentView.frame = CGRectMake(0, 0, contentViewWidth, kViewHeight);
        }
        //_contentView.nodeViewSubChartView = self.nodeView;
        self.scrollView.contentSize = _contentView.frame.size;
        self.scrollView.contentOffset = CGPointMake((self.chartModelArrM.count - 20)*self.scale_X, 0);
        self.contentView.chartModelArrM  = self.chartModelArrM;
        self.contentView.scale_X = self.scale_X;
    }
    return _contentView;
}




@end
