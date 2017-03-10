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
#pragma mark - Block
/** 每次滚动到某一个值 显示的block */
typedef void(^verticalMarqueeBlock)(JhtVerticalMarquee *view, NSInteger currentIndex);



#pragma mark - Property
#pragma mark required
/** 数据源 滚动数值 数组 */
@property (nonatomic, strong) NSArray <NSString *>*sourceArray;


#pragma mark optional
/** 当前显示展示的文字在数据源数组中的索引_只读 */
@property (nonatomic, assign, readonly) NSInteger index;

/** 是否为逆时针滚动（default：NO）
 *  顺时针：底部 ===> 顶部
 *  逆时针：顶部 ===> 底部
 */
@property (nonatomic, assign) BOOL isCounterclockwise;

/** 单次滚动时间（default：0.5f） */
@property (nonatomic, assign) CGFloat scrollDuration;
/** 滚动延迟（default：2.5f） */
@property (nonatomic, assign) CGFloat scrollDelay;

/** 滚动字的颜色（default：blackColor） */
@property (nonatomic, strong) UIColor *verticalTextColor;
/** 滚动的字体（default：14） */
@property (nonatomic, strong) UIFont *verticalTextFont;
/** 显示内容的对齐方式（default：NSTextAlignmentLeft） */
@property (nonatomic, assign) NSTextAlignment verticalTextAlignment;
/** 显示内容的行数（default：2） */
@property (nonatomic, assign) NSInteger verticalNumberOfLines;



#pragma mark - Public Method
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（枚举）
 */
- (void)marqueeOfSettingWithState:(MarqueeState_V)marqueeState;

/** 每次滚动回调的Block */
- (void)scrollWithCallbackBlock:(verticalMarqueeBlock)block;


@end
