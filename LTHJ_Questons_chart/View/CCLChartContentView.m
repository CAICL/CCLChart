//
//  CCLChartView.m
//  LTHJ_Questons_chart
//
//  Created by 蔡春雷 on 16/6/17.
//  Copyright © 2016年 CAICL. All rights reserved.
//

#import "CCLChartContentView.h"
#import "CCLChartModel.h"
#import "Masonry.h"

#define kViewHeight self.frame.size.height
#define kViewWidth  self.frame.size.width
extern const CGFloat CCLChartView_LeftMargin;
extern const CGFloat CCLChartView_BottomMargin;
/**
 *  最大收盘价标识线距视图顶端距离 maxPoint.y
 */
static const CGFloat kMaxLineTopMargin = 10.0;

@interface CCLChartContentView ()

/**
 *  长按手势(长安出现"十"形线)
 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
/**
 *  十字线 丨
 */
@property (nonatomic, strong) UIView *verticalView;
/**
 *  十字线 一
 */
@property (nonatomic, strong) UIView *horizontalView;
/**
 *  Y轴刻度
 */
@property (nonatomic, assign) CGFloat scale_Y;
/**
 *  坐标轴原点
 */
@property (nonatomic, assign) CGPoint kOrigin;

@property (nonatomic, assign) CGFloat maxClose;

@end

@implementation CCLChartContentView

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
     CGPoint kMinPoint = CGPointMake(0, kOrigin.y - 10);
    _kOrigin = kOrigin;
    
   
// 计算Y轴刻度

    _maxClose = [self p_maxCloseWithModelArray:self.currentPageModelArrM ];
    float minClose = [self p_minCloseWithModelArray:self.currentPageModelArrM ];
/*
 * Y轴 刻度
 */
    
    _scale_Y = (_maxClose - minClose) / (kMaxPoint.y - kMinPoint.y);
    
/*
 * 绘制 最高和最低线(虚线).
 */
    UIBezierPath *dashPath = [UIBezierPath bezierPath];
    [dashPath setLineWidth:0.5];
    CGFloat dashPattern[] = {5,5};// 3实线，1空白
    [dashPath setLineDash:dashPattern count:2 phase:1];
    [[UIColor blueColor] setStroke];
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
    UIBezierPath *nodePath = [UIBezierPath bezierPath];
    closePath.lineWidth = 2;
    closePath.lineJoinStyle = 2;
    for (int i = 0; i < self.chartModelArrM.count; i++) {
        CCLChartModel *model = self.chartModelArrM[i];
        CGFloat y = kMaxPoint.y - (( _maxClose - model.chartClose.floatValue) / self.scale_Y);
        if (y > kViewHeight) {
            y = kViewHeight;
        }
        CGPoint closePoint = CGPointMake(i * self.scale_X, y);
        [nodePath moveToPoint:closePoint];
        [nodePath addArcWithCenter:closePoint radius:2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        if (i == 0) {
            [closePath moveToPoint:closePoint];
        }
        [closePath addLineToPoint:closePoint];
    }
    [closePath stroke];
    nodePath.lineWidth = 2;
    [[UIColor blackColor] setStroke];
    [[UIColor whiteColor] setFill];
    [nodePath stroke];
    [nodePath fill];

// 初始化 十字线 视图
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

    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        
// 长按时显示的视图
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
// 通过滑动位置计算需要显示的日期 且让日期显示在刻度线上
        NSInteger dateCount = ((NSInteger)location.x + self.scale_X / 2) / self.scale_X;
        if (dateCount > self.chartModelArrM.count - 1) {
            dateCount = self.chartModelArrM.count - 1;
        }
        CCLChartModel *model = self.chartModelArrM[dateCount];
        
       // 公式 :  y = kMaxPoint.y - (( maxClose - model.chartClose.floatValue) / self.scale_Y);
        CGFloat close = _maxClose - (kMaxLineTopMargin - location.y) * self.scale_Y;
        UILabel *label = [self.showDateAndCloseView viewWithTag:111000];
        label.text = [NSString stringWithFormat:@"%.2f",close];
        frame = label.frame;
        frame.origin.y = location.y - (frame.size.height)/2;
        label.frame = frame;
        label = [self.showDateAndCloseView viewWithTag:100000];
        label.text = model.chartDate;
        frame = label.frame;

        if ((kViewWidth - location.x) < frame.size.width/2) {
            frame.origin.x = location.x - CCLChartView_BottomMargin - frame.size.width*1.5;
        }else {
            frame.origin.x = location.x - CCLChartView_LeftMargin - frame.size.width/2;
        }
        label.frame = frame;

    }
    if (longPress.state == UIGestureRecognizerStateEnded)
    {
        
        self.verticalView.hidden = YES;
        self.horizontalView.hidden = YES;
        self.showDateAndCloseView.hidden = YES;
    }
}

- (UIView *)verticalView {
	if(_verticalView == nil) {
		_verticalView = [[UIView alloc] init];
        [self addSubview:_verticalView];
            _verticalView.backgroundColor = [UIColor redColor];
        [_verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1.5);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-CCLChartView_BottomMargin);
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
            make.height.mas_equalTo(1.5);
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(50);
        }];
    }
    return _horizontalView;
}



@end
