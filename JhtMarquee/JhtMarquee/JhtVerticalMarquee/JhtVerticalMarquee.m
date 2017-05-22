 
//
//  JhtVerticalMarquee.m
//  JhtMarquee
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Zl on 2017/3/6.
//  Copyright © 2017年 JhtMarquee. All rights reserved.
//

#import "JhtVerticalMarquee.h"

@interface JhtVerticalMarquee() <UIScrollViewDelegate> {
    // 定时器
    NSTimer *_scrollTimer;
    // 每次滚动到某一个值 显示的block
    verticalMarqueeBlock _block;
    
    // 是否需要停止SC
    BOOL _isNeedStop;
    
    // 滚动的字体
    UIFont *_verticalTextFont;
    // 滚动的颜色
    UIColor *_verticalTextColor;
    // 显示内容的对齐方式
    NSTextAlignment _verticalTextAlignment;
    // 显示内容的行数
    NSInteger _verticalNumberOfLines;
}

/** 放置滚动文字的SC */
@property (nonatomic, strong) UIScrollView *bigScrollView;

/** 循环滚动的三个Lable的索引 */
@property (nonatomic, assign) NSUInteger firstLabelIndex;
@property (nonatomic, assign) NSUInteger secondLabelIndex;
@property (nonatomic, assign) NSUInteger thirdLabelIndex;
/** 循环滚动的三个Lable */
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;

@end


@implementation JhtVerticalMarquee
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        // 初始化参数
        self.index = 0;
        _isNeedStop = NO;
        // 开启越界剪辑
        self.clipsToBounds = YES;
        
        // 注册app切换至前台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vmqStartMarquee) name:UIApplicationDidBecomeActiveNotification object:nil];
        // 注册app切换至后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vmqShutdownMarquee) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}


#pragma mark Init Method
/** 开启定时器 */
- (void)vmqStartMarquee {
    [self marqueeOfSettingWithState:MarqueeContinue_V];
}

/** 关闭定时器 */
- (void)vmqShutdownMarquee {
    [self marqueeOfSettingWithState:MarqueePause_V];
}



#pragma mark - Public Method
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（MarqueeState_V）
 */
- (void)marqueeOfSettingWithState:(MarqueeState_V)marqueeState {
    switch (marqueeState) {
        case MarqueeStart_V: {
            // 开启
            _isNeedStop = NO;
            [self vmqStartTimer];
            
            break;
        }
        case MarqueeShutDown_V: {
            // 关闭
            _isNeedStop = YES;
            [_scrollTimer invalidate];
            _scrollTimer = nil;
            
            break;
        }
            
        case MarqueePause_V: {
            // 暂停
            _isNeedStop = YES;
            [_scrollTimer setFireDate:[NSDate distantFuture]];
            
            break;
        }
        case MarqueeContinue_V: {
            // 延迟1.5S调用，给人相应反应时间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 取消暂停（继续）
                _isNeedStop = NO;
                // 判断定时器是否被销毁
                if (_scrollTimer != nil) {
                    [_scrollTimer setFireDate:[NSDate distantPast]];
                } else {
                    // 开启
                    [self vmqStartTimer];
                }
            });
            
            break;
        }
    }
}

/** 每次滚动回调的Block */
- (void)scrollWithCallbackBlock:(verticalMarqueeBlock)block {
    _block = block;
}



#pragma mark - Private Method
/** 开启定时器 */
- (void)vmqStartTimer {
    _block(self, self.index);
    
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollDelay target:self selector:@selector(vmqChangeScrollViewOffset) userInfo:nil repeats:YES];
    // 解决scrollview滑动过程中_scrollTimer被冻结问题
    [[NSRunLoop mainRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
}

/** 定时器改变SC的contentOffset */
- (void)vmqChangeScrollViewOffset {
    [UIView animateWithDuration:self.scrollDuration animations:^{
        NSInteger index = 2;
        // 判断是否为逆时针滚动
        if (self.isCounterclockwise) {
            index = 0;
        }
        [self.bigScrollView setContentOffset:CGPointMake(0, index * CGRectGetHeight(self.frame)) animated:NO];
    } completion:^(BOOL finished) {
        // SC滚动处理
        [self vmqScrollWithScrollView:self.bigScrollView];
    }];
}

/** SC滚动处理 */
- (void)vmqScrollWithScrollView:(UIScrollView *)scrollView {
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    
    if (self.isCounterclockwise) {
        // 逆时针
        if (_bigScrollView.contentOffset.y == viewHeight * 2) {
            _secondLabelIndex = _secondLabelIndex - 1;
            _firstLabelIndex = _firstLabelIndex - 1;
            _thirdLabelIndex = _thirdLabelIndex - 1;
            
            if (_firstLabelIndex == -1) {
                _firstLabelIndex = _sourceArray.count - 1;
            }
            if (_secondLabelIndex == -1) {
                _secondLabelIndex = _sourceArray.count - 1;
            }
            if (_thirdLabelIndex == -1) {
                _thirdLabelIndex = _sourceArray.count - 1;
            }
        } else if (_bigScrollView.contentOffset.y == 0) {
            _secondLabelIndex = _secondLabelIndex + 1;
            _firstLabelIndex = _firstLabelIndex + 1;
            _thirdLabelIndex = _thirdLabelIndex + 1;
            
            if (_firstLabelIndex == _sourceArray.count) {
                _firstLabelIndex = 0;
            }
            if (_secondLabelIndex == _sourceArray.count) {
                _secondLabelIndex = 0;
            }
            if (_thirdLabelIndex == _sourceArray.count) {
                _thirdLabelIndex = 0;
            }
        } else {
            return;
        }
        
        _firstLabel.text = _sourceArray[_firstLabelIndex];
        _secondLabel.text = _sourceArray[_secondLabelIndex];
        _thirdLabel.text = _sourceArray[_thirdLabelIndex];
        self.index = _secondLabelIndex;
        
        if (_block) {
            _block(self, self.index);
        }
        _bigScrollView.contentOffset = CGPointMake(0, viewHeight);
    } else {
        // 顺时针
        if (_bigScrollView.contentOffset.y == 0) {
            _secondLabelIndex = _secondLabelIndex - 1;
            _firstLabelIndex = _firstLabelIndex - 1;
            _thirdLabelIndex = _thirdLabelIndex - 1;
            
            if (_firstLabelIndex == -1) {
                _firstLabelIndex = _sourceArray.count - 1;
            }
            if (_secondLabelIndex == -1) {
                _secondLabelIndex = _sourceArray.count - 1;
            }
            if (_thirdLabelIndex == -1) {
                _thirdLabelIndex = _sourceArray.count - 1;
            }
        } else if (_bigScrollView.contentOffset.y == viewHeight * 2) {
            _secondLabelIndex = _secondLabelIndex + 1;
            _firstLabelIndex = _firstLabelIndex + 1;
            _thirdLabelIndex = _thirdLabelIndex + 1;
            
            if (_firstLabelIndex == _sourceArray.count) {
                _firstLabelIndex = 0;
            }
            if (_secondLabelIndex == _sourceArray.count) {
                _secondLabelIndex = 0;
            }
            if (_thirdLabelIndex == _sourceArray.count) {
                _thirdLabelIndex = 0;
            }
        } else {
            return;
        }
        
        _firstLabel.text = _sourceArray[_firstLabelIndex];
        _secondLabel.text = _sourceArray[_secondLabelIndex];
        _thirdLabel.text = _sourceArray[_thirdLabelIndex];
        self.index = _secondLabelIndex;
        
        if (_block) {
            _block(self, self.index);
        }
        _bigScrollView.contentOffset = CGPointMake(0, viewHeight);
    }
}



#pragma mark - Get
/** 放置滚动文字的SC */
- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        _bigScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _bigScrollView.showsHorizontalScrollIndicator = NO;
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.pagingEnabled = YES;
        _bigScrollView.bounces = NO;
        _bigScrollView.delegate = self;
        // 关闭scrollview交互
        _bigScrollView.userInteractionEnabled = NO;
    }
    return _bigScrollView;
}

/** 滚动时间（default：0.5f） */
- (CGFloat)scrollDuration {
    if (!_scrollDuration) {
        _scrollDuration = 0.5f;
    }
    return _scrollDuration;
}

/** 滚动延迟（default：2.5f） */
- (CGFloat)scrollDelay {
    if (!_scrollDelay) {
        _scrollDelay = 2.5f;
    }
    return _scrollDelay;
}

/** 滚动文字的颜色（default：blackColor） */
- (UIColor *)verticalTextColor {
    if (!_verticalTextColor) {
        _verticalTextColor = [UIColor blackColor];
    }
    return _verticalTextColor;
}

/** 滚动文字的字体（default：14） */
- (UIFont *)verticalTextFont {
    if (!_verticalTextFont) {
        _verticalTextFont = [UIFont systemFontOfSize:14];
    }
    return _verticalTextFont;
}

/** 显示文字的对齐方式（default：NSTextAlignmentLeft）*/
- (NSTextAlignment)verticalTextAlignment {
    if (!_verticalTextAlignment) {
        return NSTextAlignmentLeft;
    }
    return _verticalTextAlignment;
}

/** 显示文字的行数（default：2） */
- (NSInteger)verticalNumberOfLines {
    if (!_verticalNumberOfLines) {
        // 默认两行
        return 2;
    }
    return _verticalNumberOfLines;
}



#pragma mark - Set
/** 是否为逆时针滚动（default：NO）
 *  顺时针：底部 ===> 顶部
 *  逆时针：顶部 ===> 底部
 */
- (void)setIsCounterclockwise:(BOOL)isCounterclockwise {
    _isCounterclockwise = isCounterclockwise;
    if (_isCounterclockwise) {
        // 设置索引
        _firstLabelIndex = 1;
        _secondLabelIndex = 0;
        _thirdLabelIndex = _sourceArray.count - 1;
        // 如果label已经创建了，那么赋值
        if (_firstLabel) {
            self.firstLabel.text = _sourceArray[_firstLabelIndex];
            self.secondLabel.text = _sourceArray[_secondLabelIndex];
            self.thirdLabel.text = _sourceArray[_thirdLabelIndex];
        }
    }
}

/** 滚动的颜色（default：blackColor） */
- (void)setverticalTextColor:(UIColor *)verticalTextColor {
    _verticalTextColor = verticalTextColor;
    NSArray *arr = self.bigScrollView.subviews;
    for (NSInteger i = 0; i < arr.count; i ++) {
        if ([arr[i] isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)arr[i];
            label.textColor = _verticalTextColor;
        }
    }
}

/** 滚动的字体（default：14） */
- (void)setverticalTextFont:(UIFont *)verticalTextFont {
    _verticalTextFont = verticalTextFont;
    NSArray *arr = self.bigScrollView.subviews;
    for (NSInteger i = 0; i < arr.count; i ++) {
        if ([arr[i] isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)arr[i];
            label.font = _verticalTextFont;
        }
    }
}

/** 显示内容的对齐方式（default：NSTextAlignmentLeft） */
- (void)setVerticalTextAlignment:(NSTextAlignment)verticalTextAlignment {
    _verticalTextAlignment = verticalTextAlignment;
    NSArray *arr = self.bigScrollView.subviews;
    for (NSInteger i = 0; i < arr.count; i ++) {
        if ([arr[i] isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)arr[i];
            label.textAlignment = _verticalTextAlignment;
        }
    }
}

/** 显示内容的行数（default：2，注意一下frame.width的设置） */
- (void)setVerticalNumberOfLines:(NSInteger)verticalNumberOfLines {
    _verticalNumberOfLines = verticalNumberOfLines;
    NSArray *arr = self.bigScrollView.subviews;
    for (NSInteger i = 0; i < arr.count; i ++) {
        if ([arr[i] isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)arr[i];
            label.numberOfLines = _verticalNumberOfLines;
        }
    }
}

/** 数据源 滚动数值 数组 */
- (void)setSourceArray:(NSArray *)sourceArray {
    _sourceArray = sourceArray;
    if (_sourceArray.count == 1) {
        _firstLabelIndex = 0;
        _secondLabelIndex = 0;
        _thirdLabelIndex = 0;
    } else {
        if (_isCounterclockwise) {
            // 逆时针
            _firstLabelIndex = 1;
            _secondLabelIndex = 0;
            _thirdLabelIndex = _sourceArray.count - 1;
        } else {
            // 顺时针
            // 设置索引
            _firstLabelIndex = _sourceArray.count - 1;
            _secondLabelIndex = 0;
            _thirdLabelIndex = 1;
        }
    }
    for (NSInteger i = 0; i < 3; i ++) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) * i, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        contentLabel.tag = 100 + i;
        contentLabel.textAlignment = self.verticalTextAlignment;
        contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        contentLabel.textColor = self.verticalTextColor;
        contentLabel.font = self.verticalTextFont;
        contentLabel.numberOfLines = self.verticalNumberOfLines;
        [self.bigScrollView addSubview:contentLabel];
        
        if (i == 0) {
            contentLabel.text = _sourceArray[_firstLabelIndex];
            self.firstLabel = contentLabel;
        } else if (i == 1) {
            contentLabel.text = _sourceArray[_secondLabelIndex];
            self.secondLabel = contentLabel;
        } else {
            contentLabel.text = _sourceArray[_thirdLabelIndex];
            self.thirdLabel = contentLabel;
        }
    }
    [self addSubview:self.bigScrollView];
    
    // 添加放置滚动文字的SC
    self.bigScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 3);
    // 显示第一个
    self.bigScrollView.contentOffset = CGPointMake(0, CGRectGetHeight(self.bounds));
    
    self.index = 0;
}



#pragma mark - UIScrollViewDelegate
/** 开始拖拽 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}

/** 结束拖拽 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollDelay target:self selector:@selector(vmqChangeScrollViewOffset) userInfo:nil repeats:YES];
}

/** 手动滚动的时候减速代理 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self vmqScrollWithScrollView:scrollView];
}

/** 当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndScrollingAnimation");
//     [self vmqScrollWithScrollView:scrollView];
}



#pragma mark - dealloc
- (void)dealloc {
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}


@end
