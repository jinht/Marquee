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
/** 获取_是否处于_暂停状态 */
@property (nonatomic, assign, readonly) BOOL isPaused;



#pragma mark - Public Method
/** 初始化
 *  duration：单次滚动时间
 */
- (instancetype)initWithFrame:(CGRect)frame withSingleScrollDuration:(NSTimeInterval)duration;

#pragma mark 设置跑马灯状态
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（MarqueeState_H）
 *  注：《开启跑马灯》放在viewDidAppear中，《关闭跑马灯》放在viewWillDisappear中
 */
- (void)marqueeOfSettingWithState:(MarqueeState_H)marqueeState;


@end
