//
//  JhtHorizontalMarquee_Define.h
//  JhtMarquee
//
//  Created by Jht on 2018/5/25.
//  Copyright © 2018年 JhtMarquee. All rights reserved.
//

#ifndef JhtHorizontalMarquee_Define_h
#define JhtHorizontalMarquee_Define_h


/** 跑马灯状态_枚举
 *  tip: 调用 MarqueeShutDown_H 后，需要调用 MarqueeStart_H 才能开启滚动
 */
typedef NS_ENUM(NSUInteger, MarqueeState_H) {
    // 开启
    MarqueeStart_H,
    // 关闭
    MarqueeShutDown_H,
    
    // 暂停
    MarqueePause_H,
    // 取消暂停（继续）
    MarqueeContinue_H,
};


#endif /* JhtHorizontalMarquee_Define_h */
