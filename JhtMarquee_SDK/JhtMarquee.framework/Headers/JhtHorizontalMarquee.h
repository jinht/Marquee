//
//  JhtHorizontalMarquee.h
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2016/11/15.
//  Copyright © 2016年 JhtMarquee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JhtHorizontalMarquee_Define.h"

/** 横向 跑马灯 */
@interface JhtHorizontalMarquee : UILabel

#pragma mark - property
/** 当前_是否为_暂停状态 */
@property (nonatomic, assign, readonly) BOOL isPaused;
/** 单次滚动时间
 *  注: 初始化 单次滚动时间《使用内部自适应计算功能》，singleScrollDuration 为内部计算结果
 */
@property (nonatomic, assign, readonly) CGFloat singleScrollDuration;



#pragma mark - Public Method
/** 初始化
 *  duration: 单次滚动时间
 *  注: duration = 0.0，使用内部自适应计算功能
 */
- (instancetype)initWithFrame:(CGRect)frame singleScrollDuration:(NSTimeInterval)duration;

#pragma mark 设置跑马灯状态
/** 设置跑马灯状态
 *  marqueeState: 跑马灯状态（MarqueeState_H）
 *  注: 《开启跑马灯》放在viewDidAppear中，《关闭跑马灯》放在viewWillDisappear中
 */
- (void)marqueeOfSettingWithState:(MarqueeState_H)marqueeState;


@end
