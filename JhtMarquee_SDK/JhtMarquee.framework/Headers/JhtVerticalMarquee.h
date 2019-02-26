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
#import "JhtVerticalMarquee_Define.h"

/** 纵向 跑马灯 */
@interface JhtVerticalMarquee : UIView

#pragma mark - Property
#pragma mark required
/** 跑马灯文字 数据源数组（支持attributedText && text混合） */
@property (nonatomic, strong) NSArray *sourceArray;


#pragma mark optional
/** 当前展示内容 索引 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/** 是否为逆时针滚动
 *  default: NO
 *  顺时针: 底部 ===> 顶部
 *  逆时针: 顶部 ===> 底部
 */
@property (nonatomic, assign) BOOL isCounterclockwise;

/** 单次滚动 时间
 *  default: 0.5f
 */
@property (nonatomic, assign) CGFloat scrollDuration;
/** 滚动延迟 时间
 *  default: 3.0f
 */
@property (nonatomic, assign) CGFloat scrollDelay;

/** 文字 颜色
 *  default: [UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *textColor;
/** 文字 字体
 *  default: [UIFont systemFontOfSize:14]
 */
@property (nonatomic, strong) UIFont *textFont;
/** 文字 对齐方式
 *  default: NSTextAlignmentLeft
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/** 文字 行数
 *  default: 2（注意一下self.frame的设置）
 */
@property (nonatomic, assign) NSInteger numberOfLines;



#pragma mark - Public Method
/** 设置跑马灯状态
 *  marqueeState: 目标状态（MarqueeState_V）
 */
- (void)marqueeOfSettingWithState:(MarqueeState_V)marqueeState;

/** 滚动 回调 Block */
typedef void(^verticalMarqueeBlock)(JhtVerticalMarquee *view, NSInteger currentIndex);
- (void)scrollWithCallbackBlock:(verticalMarqueeBlock)block;


@end
