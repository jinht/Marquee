//
//  JhtHorizontalMarquee.m
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2016/11/15.
//  Copyright © 2016年 JhtMarquee. All rights reserved.
//

#import "JhtHorizontalMarquee.h"

/** 跑马灯展示文字label动画结束Block名字 */
NSString *const KMarqueeShowLabelAnimationCompletionBlockName = @"MarqueeLabelAnimationCompletionBlock";

@interface JhtHorizontalMarquee () <CAAnimationDelegate> {
    // 单次滚动时间
    NSTimeInterval _singleScrollDuration;
}
/** 跑马灯展示文字Label */
@property (nonatomic, strong) UILabel *marqueeShowLabel;

@end


@implementation JhtHorizontalMarquee
#pragma mark - Public Method
/** 初始化
 *  duration：单次滚动时间
 */
- (instancetype)initWithFrame:(CGRect)frame withSingleScrollDuration:(NSTimeInterval)duration {
    if (self = [super initWithFrame:frame]) {
        // 开启交互
        self.userInteractionEnabled = YES;
        
        if (!_marqueeShowLabel) {
            self.clipsToBounds = YES;
            self.numberOfLines = 1;
            // 开启交互
            self.marqueeShowLabel.userInteractionEnabled = YES;
            
            // 初始化展示文字的label
            _marqueeShowLabel = [[UILabel alloc] initWithFrame:self.bounds];
            _marqueeShowLabel.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
            [self addSubview:_marqueeShowLabel];
            _marqueeShowLabel.backgroundColor = [UIColor clearColor];
            
            // 注册app切换至前台通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hmqRestartMarquee) name:UIApplicationDidBecomeActiveNotification object:nil];
            // 注册app切换至后台通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hmqShutdownMarquee) name:UIApplicationDidEnterBackgroundNotification object:nil];
        }
        // 单次滚动时间
        _singleScrollDuration = duration;
    }
    return self;
}

#pragma mark 设置跑马灯状态
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（枚举）
 *  注：“开启跑马灯”放在viewDidAppear中，“关闭跑马灯”放在viewWillDisappear中
 */
- (void)marqueeOfSettingWithState:(MarqueeState_H)marqueeState {
    // 如果不能滚动就别动了
    if (![self mqlShowLabelShouldScroll]) {
        return;
    }
    switch (marqueeState) {
        case MarqueeStart_H: {
            // 延迟0.8S调用，给人相应反应时间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 重启
                [self hmqRestartMarquee];
            });
            
            break;
        }
            
        case MarqueeShutDown_H: {
            // 关闭
            [self hmqShutdownMarquee];
            
            break;
        }
            
        case MarqueePause_H: {
            // 暂停
            [self hmqPauseMarquee];
            
            break;
        }
            
        case MarqueeContinue_H: {
            // 延迟0.8S调用，给人相应反应时间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 取消暂停（继续）
                [self hmqCancelPauseMarquee];
            });
            
            break;
        }
            
        default:
            break;
    }
}



#pragma mark - Private Method
#pragma mark 重启/关闭 防止右滑返回时出现跑马灯失效
/** 重启跑马灯 */
- (void)hmqRestartMarquee {
    // 如果不能滚动就别动了
    if (![self mqlShowLabelShouldScroll]) {
        return;
    }
    // 如果暂停了，先让他恢复工作
    if (self.isPaused) {
        [self hmqCancelPauseMarquee];
    }
    // 滚动
    [self mqlScrollLabel];
}

/** 关闭跑马灯 */
- (void)hmqShutdownMarquee {
    // 如果不能滚动就别动了
    if (![self mqlShowLabelShouldScroll]) {
        return;
    }
    [self.layer.mask removeAllAnimations];
    [self.marqueeShowLabel.layer removeAllAnimations];
}


#pragma mark 暂停/取消暂停（继续）跑马灯
/** 暂停跑马灯 */
- (void)hmqPauseMarquee {
    @synchronized(self) {
        if (!_isPaused) {
            CFTimeInterval labelPauseTime = [self.marqueeShowLabel.layer convertTime:CACurrentMediaTime() fromLayer:nil];
            self.marqueeShowLabel.layer.speed = 0.0;
            self.marqueeShowLabel.layer.timeOffset = labelPauseTime;
            
            CFTimeInterval gradientPauseTime = [self.layer.mask convertTime:CACurrentMediaTime() fromLayer:nil];
            self.layer.mask.speed = 0.0;
            self.layer.mask.timeOffset = gradientPauseTime;
            
            _isPaused = YES;
        }
    }
}

/** 取消暂停（继续）跑马灯 */
- (void)hmqCancelPauseMarquee {
    @synchronized(self) {
        if (_isPaused) {
            CFTimeInterval labelPausedTime = self.marqueeShowLabel.layer.timeOffset;
            self.marqueeShowLabel.layer.speed = 1.0;
            self.marqueeShowLabel.layer.timeOffset = 0.0;
            self.marqueeShowLabel.layer.beginTime = 0.0;
            self.marqueeShowLabel.layer.beginTime = [self.marqueeShowLabel.layer convertTime:CACurrentMediaTime() fromLayer:nil] - labelPausedTime;
            
            CFTimeInterval gradientPauseTime = self.layer.mask.timeOffset;
            self.layer.mask.speed = 1.0;
            self.layer.mask.timeOffset = 0.0;
            self.layer.mask.beginTime = 0.0;
            self.layer.mask.beginTime = [self.layer.mask convertTime:CACurrentMediaTime() fromLayer:nil] - gradientPauseTime;
            _isPaused = NO;
        }
    }
}



#pragma mark - layer
+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

/** 获取复制器层 */
- (CAReplicatorLayer *)replicatorLayer {
    return (CAReplicatorLayer *)self.layer;
}



#pragma mark - Get
- (NSString *)text {
    return self.marqueeShowLabel.text;
}

- (NSAttributedString *)attributedText {
    return self.marqueeShowLabel.attributedText;
}

- (UIFont *)font {
    return self.marqueeShowLabel.font;
}

- (UIColor *)textColor {
    return self.marqueeShowLabel.textColor;
}

- (UIColor *)backgroundColor {
    return self.marqueeShowLabel.backgroundColor;
}

- (UIColor *)shadowColor {
    return self.marqueeShowLabel.shadowColor;
}

- (CGSize)shadowOffset {
    return self.marqueeShowLabel.shadowOffset;
}

- (UIColor *)highlightedTextColor {
    return self.marqueeShowLabel.highlightedTextColor;
}

- (BOOL)isHighlighted {
    return self.marqueeShowLabel.isHighlighted;
}

- (BOOL)isEnabled {
    return self.marqueeShowLabel.isEnabled;
}

- (UIBaselineAdjustment)baselineAdjustment {
    return self.marqueeShowLabel.baselineAdjustment;
}

- (CGSize)intrinsicContentSize {
    return self.marqueeShowLabel.intrinsicContentSize;
}



#pragma mark - Set
- (void)setText:(NSString *)text {
    // 为展示文字的label赋值
    if ([text isEqualToString:self.marqueeShowLabel.text]) {
        return;
    }
    self.marqueeShowLabel.text = text;
    super.text = nil;
    
    [self mqlUpdateShowLabel];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    // 为展示文字的label赋值
    if ([attributedText isEqualToAttributedString:self.marqueeShowLabel.attributedText]) {
        return;
    }
    self.marqueeShowLabel.attributedText = attributedText;
    super.attributedText = attributedText;
    
    [self mqlUpdateShowLabel];
}

- (void)setFont:(UIFont *)font {
    // 为展示文字的label设置字体
    if ([font isEqual:self.marqueeShowLabel.font]) {
        return;
    }
    self.marqueeShowLabel.font = font;
    super.font = font;
    
    [self mqlUpdateShowLabel];
}

- (void)setTextColor:(UIColor *)textColor {
    self.marqueeShowLabel.textColor = textColor;
    super.textColor = textColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.marqueeShowLabel.backgroundColor = backgroundColor;
    super.backgroundColor = backgroundColor;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.marqueeShowLabel.shadowColor = shadowColor;
    super.shadowColor = shadowColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.marqueeShowLabel.shadowOffset = shadowOffset;
    super.shadowOffset = shadowOffset;
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.marqueeShowLabel.highlightedTextColor = highlightedTextColor;
    super.highlightedTextColor = highlightedTextColor;
}

- (void)setHighlighted:(BOOL)highlighted {
    self.marqueeShowLabel.highlighted = highlighted;
    super.highlighted = highlighted;
}

- (void)setEnabled:(BOOL)enabled {
    self.marqueeShowLabel.enabled = enabled;
    super.enabled = enabled;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    [super setNumberOfLines:1];
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    [super setAdjustsFontSizeToFitWidth:NO];
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize {
    [super setMinimumFontSize:0.0];
}

- (void)setBaselineAdjustment:(UIBaselineAdjustment)baselineAdjustment {
    self.marqueeShowLabel.baselineAdjustment = baselineAdjustment;
    super.baselineAdjustment = baselineAdjustment;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [self.marqueeShowLabel sizeThatFits:size];
    return fitSize;
}

- (void)setAdjustsLetterSpacingToFitWidth:(BOOL)adjustsLetterSpacingToFitWidth {
    [super setAdjustsLetterSpacingToFitWidth:NO];
}

- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor {
    [super setMinimumScaleFactor:0.0f];
}



#pragma mark - UIViewHierarchy
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self mqlUpdateShowLabel];
}

- (void)didMoveToWindow {
    if (self.window) {
        [self mqlUpdateShowLabel];
    }
}



#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void(^completionBlock)(BOOL finished);
    completionBlock = [anim valueForKey:KMarqueeShowLabelAnimationCompletionBlockName];
    if (completionBlock) {
        completionBlock(flag);
    }
}



#pragma mark - 更新展示文字Label
/** 更新展示文字Lable */
- (void)mqlUpdateShowLabel {
    if (self.window) {
        if (!self.marqueeShowLabel.text || !self.superview) {
            return;
        }
        // 计算展示文字label Size
        CGSize realTextSize = [self mqlCalculateShowLabelSize];
        // 判断展示文字label是否应该滚动
        if (![self mqlShowLabelShouldScroll]) {
            self.marqueeShowLabel.textAlignment = [super textAlignment];
            self.marqueeShowLabel.lineBreakMode = [super lineBreakMode];
            
            // 设置展开的最小rect
            CGRect labelFrame = CGRectIntegral(CGRectMake(0, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)));
            self.marqueeShowLabel.frame = CGRectIntegral(labelFrame);
            // 制定创建复制器层数
            self.replicatorLayer.instanceCount = 1;
            
            return;
        }
        
        [self.marqueeShowLabel setLineBreakMode:NSLineBreakByClipping];
        CGRect labelFrame = CGRectMake(0, 0.0f, realTextSize.width, CGRectGetHeight(self.bounds));
        // 修复不完美与屏幕上的像素对齐
        self.marqueeShowLabel.frame = CGRectIntegral(labelFrame);
        // 拷贝两份展示文字Label
        self.replicatorLayer.instanceCount = 2;
        // 两份拷贝的marqueeLabel，默认是重叠在一起的，通过转换将两个marqueeLabel水平间距拉开
        self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(self.marqueeShowLabel.frame.size.width, 0.0, 0.0);
        // 颜色值递减
        self.replicatorLayer.instanceGreenOffset = -0.03;
        // 颜色值递减
        self.replicatorLayer.instanceRedOffset = -0.02;
        // 颜色值递减
        self.replicatorLayer.instanceBlueOffset = -0.01;
    }
}

/** 计算展示文字label Size */
- (CGSize)mqlCalculateShowLabelSize {
    CGSize realTextSize = [self.marqueeShowLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    realTextSize.height = CGRectGetHeight(self.bounds);
    return realTextSize;
}

/** 判断展示文字label是否应该滚动 */
- (BOOL)mqlShowLabelShouldScroll {
    CGSize realTextSize = [self mqlCalculateShowLabelSize];
    BOOL labelShouldScroll = realTextSize.width > CGRectGetWidth(self.bounds);
    return labelShouldScroll;
}

/** 开始滚动 */
- (void)mqlScrollLabel {
    if (![self mqlIsLbelNeedScroll]) {
        return;
    }
    
    [self.layer.mask removeAllAnimations];
    [self.marqueeShowLabel.layer removeAllAnimations];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:(_singleScrollDuration)];
    
    void(^completionBlock)(BOOL finished);
    completionBlock = ^(BOOL finished) {
        if (!finished) {
            return;
        }
        if (self.window && ![self.marqueeShowLabel.layer animationForKey:@"position"]) {
            if ([self mqlShowLabelShouldScroll]) {
                [self mqlScrollLabel];
            }
        }
    };
    
    CGPoint homeOrigin = self.marqueeShowLabel.frame.origin;
    CGPoint awayOrigin = CGPointMake(-CGRectGetMaxX(self.marqueeShowLabel.frame), homeOrigin.y);
    NSArray *values = @[[NSValue valueWithCGPoint:homeOrigin],
                        [NSValue valueWithCGPoint:homeOrigin],
                        [NSValue valueWithCGPoint:awayOrigin]];
    
    CAKeyframeAnimation *awayAnim = [self mqlCreateKeyFrameAnimationForProperty:@"position" values:values];
    [awayAnim setValue:completionBlock forKey:KMarqueeShowLabelAnimationCompletionBlockName];
    
    [self.marqueeShowLabel.layer addAnimation:awayAnim forKey:@"position"];
    
    [CATransaction commit];
}

/** 判断是否需要滚动 */
- (BOOL)mqlIsLbelNeedScroll {
    if (!self.superview) {
        return NO;
    }
    
    if (!self.window) {
        return NO;
    }
    
    if (![self hmqIsCurrentViewControllerVisible:[self hmqFindViewController]]) {
        return NO;
    }
    
    return YES;
}

/** 创建关键帧动画 */
- (CAKeyframeAnimation *)mqlCreateKeyFrameAnimationForProperty:(NSString *)property values:(NSArray *)values {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:property];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    animation.keyTimes = @[@(0.0),@(0.0), @(1.0)];
    
    animation.timingFunctions = @[timingFunction,timingFunction];
    animation.values = values;
    animation.delegate = self;
    
    return animation;
}



#pragma mark - Tools
/** 是否处于当前页面 */
-(BOOL)hmqIsCurrentViewControllerVisible:(UIViewController *)viewController{
    return (viewController.isViewLoaded && viewController.view.window);
}

/** 查找当前的VC */
- (UIViewController *)hmqFindViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
