//
//  JhtVerticalMarquee.h
//  JhtMarquee
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Zl on 2017/3/6.
//  Copyright © 2017年 JhtMarquee. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 跑马灯状态_枚举 */
typedef NS_ENUM(NSUInteger, MarqueeState_V) {
    // 开启
    MarqueeStart_V,
    // 关闭
    MarqueeShutDown_V,
    // 暂停
    MarqueePause_V,
    // 取消暂停（继续）
    MarqueeContinue_V
};

/** 上下滚动的跑马灯 */
@interface JhtVerticalMarquee : UIView
#pragma mark - Property
#pragma mark required
/** 滚动文字的 数据源数组（支持attributedText与text混合） */
@property (nonatomic, strong) NSArray *sourceArray;


#pragma mark optional
/** 当前显示展示的文字 在数据源数组中的索引_只读 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/** 是否为逆时针滚动（default：NO）
 *  顺时针：底部 ===> 顶部
 *  逆时针：顶部 ===> 底部
 */
@property (nonatomic, assign) BOOL isCounterclockwise;

/** 单次滚动时间
 *  default：0.5f
 */
@property (nonatomic, assign) CGFloat scrollDuration;
/** 滚动延迟
 *  default：2.5f
 */
@property (nonatomic, assign) CGFloat scrollDelay;

/** 滚动文字的颜色
 *  default：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *verticalTextColor;
/** 滚动文字的字体
 *  default：[UIFont systemFontOfSize:14]
 */
@property (nonatomic, strong) UIFont *verticalTextFont;
/** 显示文字的对齐方式
 *  default：NSTextAlignmentLeft
 */
@property (nonatomic, assign) NSTextAlignment verticalTextAlignment;
/** 显示文字的行数
 *  default：2（注意一下self.frame的设置）
 */
@property (nonatomic, assign) NSInteger verticalNumberOfLines;



#pragma mark - Public Method
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（MarqueeState_V）
 */
- (void)marqueeOfSettingWithState:(MarqueeState_V)marqueeState;

/** 每次滚动回调的Block */
typedef void(^verticalMarqueeBlock)(JhtVerticalMarquee *view, NSInteger currentIndex);
- (void)scrollWithCallbackBlock:(verticalMarqueeBlock)block;


@end
