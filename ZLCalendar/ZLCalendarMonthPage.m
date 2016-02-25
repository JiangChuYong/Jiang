//
//  MonthView.m
//  ZLCalendar
//

//

#import "ZLCalendarMonthPage.h"
#import "ZLCustomScrollerView.h"
#import "ZLCalendarView.h"

@interface ZLCalendarMonthPage()<UIScrollViewDelegate>
{
    float d_width;
    float d_x;
    float d_height;
    float d_y;
}

@property (assign, nonatomic) CGFloat s_width;
@property (assign, nonatomic) CGFloat s_height;
@property (assign, nonatomic) CGSize s_contentSize;
@property (assign, nonatomic) CGPoint s_contentOffset;
@property (assign, nonatomic) CGFloat s_Offset;
@property (assign, nonatomic) CGFloat s_size;
@property (assign, nonatomic) BOOL isVertical;//是否垂直方向
@property (assign, nonatomic) int index;

@property (retain, nonatomic) ZLCustomScrollerView *scrollView;
@property (retain, nonatomic) NSMutableArray *viewArrays;
@property (retain, nonatomic) NSDate *currentDate;
@property (retain, nonatomic) NSMutableArray *dayViews;
@end

@implementation ZLCalendarMonthPage

-(void)dealloc{
    [_scrollView release];
    [_viewArrays release];
    [_currentDate release];
    [_dayViews release];
    [_monthModel release];
    
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dayViews = [NSMutableArray array];
        self.viewArrays = [NSMutableArray array];
    }
    
    return self;
}


-(void)drawRect:(CGRect)rect
{
    self.currentDate = _monthModel.currentDate;
    
    self.index = -1;
    switch (_monthModel.choiceMode) {
        case DateChoiceMode_Radio:
        {
            [self dayViewOfDateChoiceRadio];
        }
            break;
        case DateChoiceMode_Multiple:
        {
            [self dayViewOfDateChoiceMultiple];
        }
            break;
        case DateChoiceMode_DoublePoint:
        {
            [self dayViewOfDateChoiceDoublePoint];
        }
            break;
        default:
            break;
    }
}

///单选
-(void)dayViewOfDateChoiceRadio
{
    [self showScrollView];
    [self initScrollDataSource];
    
    [self reuseMechanismsLoadScrollViewData:CalendarReuseStyleDefualt];
}
///滑动多选
-(void)dayViewOfDateChoiceMultiple
{
    
}
///两点之间取时间段
-(void)dayViewOfDateChoiceDoublePoint
{
    
}

-(void)showScrollView
{
    if (self.scrollView){
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
    }
    
    ZLCustomScrollerView *tempScrollView = [[ZLCustomScrollerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    tempScrollView.backgroundColor = [UIColor whiteColor];
    tempScrollView.showsHorizontalScrollIndicator = NO;
    tempScrollView.showsVerticalScrollIndicator = NO;
    tempScrollView.pagingEnabled = YES;
    tempScrollView.delegate = self;
    tempScrollView.flag = YES;
    self.scrollView = tempScrollView;
    self.scrollView.contentSize = self.s_contentSize;
    self.scrollView.contentOffset = self.s_contentOffset;
    [self addSubview:self.scrollView];
    [tempScrollView release];
}
/** 初始化数据源*/
-(void)initScrollDataSource
{
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[ZLDayLayoutView class]]) {
            [view removeFromSuperview];
            view = nil;
        }
    }
    
    for (int i=0; i<VIEWCOUNT; i++) {
        ZLDayLayoutView *layoutView = [[ZLDayLayoutView alloc] initWithFrame:CGRectZero];
        layoutView.delegate = _delegate;
        layoutView.dataSource = _dataSource;
        [self.viewArrays addObject:layoutView];
        [self.scrollView addSubview:layoutView];
        [layoutView release];
    }
}
///矫正日期
-(void)correctDate
{
    self.currentDate = _monthModel.currentDate;
}
/** 日历滑动利用重用机制*/
-(void)reuseMechanismsLoadScrollViewData:(CalendarReuseStyle)style
{
    if (!self.viewArrays || !self.viewArrays.count) return;
    
    if ([_delegate respondsToSelector:@selector(calendarViewWithShowDate:)]) {
        [_delegate calendarViewWithShowDate:self.currentDate];
    }
    
    switch (style) {
        case CalendarReuseStyleLeft:
        {
            [self leftSlideWithScrollView];
        }
            break;
        case CalendarReuseStyleRight:
        {
            [self rightSlideWithScrollView];
        }
            break;
        default:
            break;
    }
    
    [self setCalendarFrame];
}
//左滑
-(void)leftSlideWithScrollView
{
    UIView *monthView0 = self.viewArrays.firstObject;
        
    [self.viewArrays removeObjectAtIndex:0];
    
    [self.viewArrays addObject:monthView0];
    
    self.index = 2;
    
    //上 中 下 / 下 上 中 / 中 下 上
}

//右滑
-(void)rightSlideWithScrollView
{
    UIView *monthView2 = self.viewArrays.lastObject;
    
    [self.viewArrays removeLastObject];
    
    [self.viewArrays insertObject:monthView2 atIndex:0];
    
    self.index = 0;
    
    //上 中 下 / 中 下 上 / 下 上 中
}

/** 设置calendarMonthView的frame*/
-(void)setCalendarFrame
{
    for (int i = 0; i < self.viewArrays.count; i++) {
        ZLDayLayoutView *view = self.viewArrays[i];
        view.frame = CGRectMake([self monthViewOrginx:i], [self monthViewOrginy:i], CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        if (i==self.index || self.index == -1) {
            self.monthModel.currentDate = self.currentDate;
            [view dayViewLayOutWithPage:self.monthModel choiceType:[self getMonthTypeWithIndex:i]];
        }
        [view reloadDayViewData];
    }
    self.scrollView.contentOffset = self.s_contentOffset;
}
///月份选择
-(MonthChoiceType)getMonthTypeWithIndex:(int)index
{
    switch (index) {
        case 0:
            return MonthChoiceTypePre;
        case 1:
            return MonthChoiceTypeCurrent;
        case 2:
            return MonthChoiceTypeNext;
        default:
            return MonthChoiceTypeNull;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    int offset = self.s_Offset;
    //往下翻一张
    if(offset >= (2*self.s_size)) {
        self.currentDate = [self.currentDate dayInTheFollowingMonth];
        [self reuseMechanismsLoadScrollViewData:CalendarReuseStyleLeft];
    }
    
    //往上翻
    if(offset <= 0) {
        self.currentDate = [self.currentDate dayInThePreviousMonth];
        [self reuseMechanismsLoadScrollViewData:CalendarReuseStyleRight];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
    self.scrollView.contentOffset = self.s_contentOffset;
}



#pragma mark - 私有方法
-(BOOL)isVertical
{
    return _monthModel.arrangeStyle==CalendarArrangeStyleVertical?YES:NO;
}

-(CGFloat)monthViewOrginx:(int)i
{
    return self.isVertical?0:CGRectGetWidth(_scrollView.frame)*i;
}
-(CGFloat)monthViewOrginy:(int)i
{
    return self.isVertical?CGRectGetHeight(_scrollView.frame)*i:0;
}

-(CGFloat)s_width
{
    return CGRectGetWidth(self.frame);
}
-(CGFloat)s_height
{
    return CGRectGetHeight(self.frame);
}

-(CGFloat)s_Offset
{
    return self.isVertical?_scrollView.contentOffset.y:_scrollView.contentOffset.x;
}

-(CGFloat)s_size
{
    return self.isVertical?CGRectGetHeight(self.scrollView.frame):CGRectGetWidth(self.scrollView.frame);
}

-(CGPoint)s_contentOffset
{
    CGFloat x = !self.isVertical?CGRectGetWidth(self.frame):0;
    CGFloat y = self.isVertical?CGRectGetHeight(self.frame):0;
    return CGPointMake(x, y);
}
-(CGSize)s_contentSize
{
    CGFloat w = !self.isVertical?CGRectGetWidth(self.frame)*VIEWCOUNT:CGRectGetWidth(self.frame);
    CGFloat h = self.isVertical?CGRectGetHeight(self.frame)*VIEWCOUNT:CGRectGetHeight(self.frame);
    return CGSizeMake(w, h);
}
@end

