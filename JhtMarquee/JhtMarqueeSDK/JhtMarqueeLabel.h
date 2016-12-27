//
//  JhtMarqueeLabel.h
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2016/11/15.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 跑马灯状态_枚举 */
typedef NS_ENUM(NSUInteger, MarqueeState) {
    // 开启
    MarqueeStart,
    // 关闭
    MarqueeShutDown,
    // 暂停
    MarqueePause,
    // 取消暂停（继续）
    MarqueeContinue,
};

/** 跑马灯Lable */
@interface JhtMarqueeLabel : UILabel
#pragma mark - property
/** 获取_是否处于_暂停状态（只读） */
@property (nonatomic, assign, readonly) BOOL isPaused;



#pragma mark - Public Method
#pragma mark Init
/** 初始化
 *  duration：单次滚动时间
 */
- (instancetype)initWithFrame:(CGRect)frame withSingleScrollDuration:(NSTimeInterval)duration;


#pragma mark 设置跑马灯状态
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（枚举）
 *  注：“开启跑马灯”放在viewDidAppear中，“关闭跑马灯”放在viewWillDisappear中
 */
- (void)marqueeOfSettingWithState:(MarqueeState)marqueeState;


@end
