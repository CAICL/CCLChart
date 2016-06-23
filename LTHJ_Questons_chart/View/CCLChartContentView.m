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
#import "CCLChartScrollView.h"


#define kViewHeight self.frame.size.height
#define kViewWidth  self.frame.size.width

extern const CGFloat CCLChartView_LeftMargin;
extern const CGFloat CCLChartView_BottomMargin;

/**
 *  最大收盘价标识线距视图顶端距离
 */
static const CGFloat kMaxLineTopMargin = 10.0;


@interface CCLChartContentView ()

/**
 *  长按手势(长安出现"十"形线)
 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UIView *horizontalView;
@property (nonatomic, assign) CGFloat scale_Y;
@property (nonatomic, assign) CGFloat originClose;
@property (nonatomic, assign) CGPoint kOrigin;
//@property (nonatomic, strong)

@end


@implementation CCLChartContentView

@synthesize currentModelArrM = _currentModelArrM;

- (instancetype)init
{
    self = [super init];
    if (self) {
//      初始化手势
        [self addGestureRecognizer:self.longPress];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

// 标尺点
     CGPoint kOrigin = CGPointMake(0, self.frame.size.height - CCLChartView_BottomMargin);
     CGPoint kMaxPoint = CGPointMake(0, kMaxLineTopMargin);
    _kOrigin = kOrigin;
    
   
// 计算Y轴刻度

    float maxClose = [self p_maxCloseWithModelArray:[self.chartModelArrM mutableCopy]];
    
    float minClose = [self p_minCloseWithModelArray:[self.chartModelArrM mutableCopy]];
    
   // NSLog(@"%f - %f", maxClose, minClose);
/*       
        float midValue =  max - min;
        CGFloat midPx =  kMinPoint.y - kMaxPoint.y;
        Y轴刻度  收盘价 y坐标 = kOrigin.y - scale_Y * (model.chartClose.floatValue - originClose)
*/
        _originClose = minClose -  (int)minClose % 100;    // 让最小值在X轴上方一些的位置
        _scale_Y = (kOrigin.y - kMaxPoint.y) / (maxClose - _originClose);
    
    CGPoint kMinPoint = CGPointMake(0, kOrigin.y - (minClose - _originClose) * _scale_Y );
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
    closePath.lineWidth = 2;
    closePath.lineJoinStyle = 2;
    for (int i = 0; i < self.chartModelArrM.count; i++) {
        CCLChartModel *model = self.chartModelArrM[i];
        CGPoint closePoint = CGPointMake(i * self.scale_X, kOrigin.y - (model.chartClose.floatValue - _originClose) * _scale_Y );
        if (i == 0) {
            [closePath moveToPoint:closePoint];
        }
        [closePath addLineToPoint:closePoint];
    }
    [closePath stroke];

    NSLog(@"%@", self);
   
    self.horizontalView.hidden = YES;
    self.verticalView.hidden = YES;

}



/// 返回最高的收盘价
- (float)p_maxCloseWithModelArray:(NSArray *)modelArray {
    float maxClose = 0.0;
    for (CCLChartModel *model in modelArray) {
        if (maxClose < model.chartClose.floatValue) {
            maxClose = model.chartClose.floatValue;
        }
    }
    return maxClose;
}

/// 返回最低的收盘价
- (float)p_minCloseWithModelArray:(NSArray *)modelArray; {
    float minClose = MAXFLOAT;
    for (CCLChartModel *model in modelArray) {
        if (minClose > model.chartClose.floatValue) {
            minClose = model.chartClose.floatValue;
        }
    }
    return minClose;
}

- (NSMutableArray *)currentModelArrM {
    if(!_currentModelArrM) {
        _currentModelArrM = [NSMutableArray array];
        for (NSInteger i = self.chartModelArrM.count - self.days; i < self.chartModelArrM.count; i++) {
            [_currentModelArrM addObject:self.chartModelArrM[i]];
        }
    }
    return _currentModelArrM;
}

- (NSInteger)modelArrayCountMoreThanDays {
    return self.chartModelArrM.count - self.days;
}
#pragma mark - 长按手势
- (UILongPressGestureRecognizer *)longPress {
	if(_longPress == nil) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
        _longPress.minimumPressDuration = 1;
        
	}
	return _longPress;
}

- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress {
    
    CGPoint location = [longPress locationInView:self];

    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        self.superSrollView.scrollEnabled = NO;

        self.verticalView.hidden = NO;
        self.horizontalView.hidden = NO;
        self.showDateAndCloseView.hidden = NO;
        CGRect frame = self.verticalView.frame;
        frame.origin.x = location.x;
        self.verticalView.frame = frame;
        frame = self.horizontalView.frame;
        frame.origin.y = location.y;
        self.horizontalView.frame = frame;
       // 需要显示horizontalView 的 y 对应的close值  : location.y
        //       verticalView  的 x对应的日期       : location.x
        NSInteger dateCount = (NSInteger)location.x / self.scale_X;
        CCLChartModel *model = self.chartModelArrM[dateCount];
        
        // y = kOrigin.y - (model.chartClose.floatValue - _originClose) * _scale_Y
        //       close = (kOrigin.y - y) / _scale_y + _originClose
        
        CGFloat close = (_kOrigin.y - location.y) / _scale_Y + _originClose;
        NSLog(@"%@ - %@ - %f",model.chartDate, model.chartClose, close );
        UILabel *label = [self.showDateAndCloseView viewWithTag:111000];
        label.text = [NSString stringWithFormat:@"%.2f",close];
        label = [self.showDateAndCloseView viewWithTag:100000];
        label.text = model.chartDate;
    }
    if (longPress.state == UIGestureRecognizerStateEnded)
    {
        
        self.verticalView.hidden = YES;
        self.horizontalView.hidden = YES;
        self.superSrollView.scrollEnabled = YES;
        self.showDateAndCloseView.hidden = YES;
    }
}

- (UIView *)verticalView {
	if(_verticalView == nil) {
		_verticalView = [[UIView alloc] init];
        [self addSubview:_verticalView];
            _verticalView.backgroundColor = [UIColor redColor];
        [_verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1.5, 200));
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
        }];
	}
	return _verticalView;
}

- (UIView *)horizontalView {
    if (_horizontalView == nil) {
        _horizontalView = [UIView new];
        [self addSubview:_horizontalView];
        _horizontalView.backgroundColor = [UIColor redColor];
        [_horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 1.5));
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(50);
        }];
    }
    return _horizontalView;
}






@end
