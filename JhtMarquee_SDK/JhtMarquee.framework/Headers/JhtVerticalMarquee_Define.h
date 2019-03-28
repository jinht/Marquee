//
//  JhtVerticalMarquee_Define.h
//  JhtMarquee
//
//  Created by Jht on 2018/5/25.
//  Copyright © 2018年 JhtMarquee. All rights reserved.
//

#ifndef JhtVerticalMarquee_Define_h
#define JhtVerticalMarquee_Define_h


/** 跑马灯状态_枚举
 *  tip: 调用 MarqueeShutDown_V 后，需要调用 MarqueeStart_V 才能开启滚动
 */
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


#endif /* JhtVerticalMarquee_Define_h */
