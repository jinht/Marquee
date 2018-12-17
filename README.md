## Marquee（跑马灯）

说一下初衷吧，最初要用到跑马灯功能的时候，也找过一些SDK，但未能找到与我需求很好契合的SDK，主要就是手势滑动后的问题（手势滑动push/pop时候跑马灯出现失灵的状况），目前支持水平 && 上下（正向 && 逆向）滚动，解决push/pop && 前后台切换 && 手势滑动 && 意外中断等情况，希望通过此SDK给予与我有同样需求的童鞋一些帮助。
<br>


### 先上图，看一下是否符合你的场景吧！
<img src="https://raw.githubusercontent.com/jinht/Marquee/master/ReadMEImages/1.gif" width=240 height=426 />


### Function Description
1. 轻量级跑马灯
2. 支持attributedText
3. 随时获取跑马灯状态
4. 前/后台切换重新加载
5. 水平 && 上下（正向 && 逆向）
6. push/pop || 前后台切换 || 手势返回后自动滚动<br>


## How to use
### 1. podfile 
```oc
platform:ios, '8.0'

target '*****' do

pod 'JhtMarquee'
        
end
```


### 2. 水平：水平向左滚动的跑马灯

#### a. 简单的集成方式：当成一个普通label使用即可，在初始化方法的时候可以自定义单次滚动时间
```oc
/** 初始化
 *  duration: 单次滚动时间
 *  注: duration = 0.0，使用内部自适应计算功能
 */
- (instancetype)initWithFrame:(CGRect)frame withSingleScrollDuration:(NSTimeInterval)duration;
```

#### b. 状态自由设置：通过以下方法传入相应的`MarqueeState_H`枚举值即可
```oc
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（枚举）
 *  注：“开启跑马灯”放在viewDidAppear中，“关闭跑马灯”放在viewWillDisappear中
 */
- (void)marqueeOfSettingWithState:(MarqueeState_H)marqueeState;
```


* 注：demo中有详细使用的方法，集成的时候按其方式使用即可，此外，还要注意一下`开启/关闭跑马灯`方法放置的函数
```oc
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 开启跑马灯
    [_marquee marqueeOfSettingWithState:MarqueeStart];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 关闭跑马灯
    [_marquee marqueeOfSettingWithState:MarqueeShutDown];
}
```


### 3. 上下：上下（正向 && 逆向）滚动的跑马灯

#### a. 简单的集成方式：正常初始化后，传入滚动文字的数据源数组即可

#### b. 状态自由设置：通过以下方法传入相应的`MarqueeState_V`枚举值即可
```oc
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（枚举）
 */
- (void)marqueeOfSettingWithState:(MarqueeState_V)marqueeState;
```

#### c. 实时回调：通过`index`属性和`scrollWithCallbackBlock`方法可以实时获取当前展示文字在数据源数组中的位置
```oc
/** 当前显示展示的文字在数据源数组中的索引_只读 */
@property (nonatomic, assign) NSInteger index;

/** 每次滚动回调的Block */
- (void)scrollWithCallbackBlock:(verticalMarqueeBlock)block;
```

#### d. 个性化设置：可通过以下属性进行个性化的设置
```oc
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
```


* 在demo中可以查看具体使用方法（使用demo之前请先 **pod install** ）



### Remind
* ARC
* iOS >= 8.0
* iPhone \ iPad 
       
       
## Hope
* If you find bug when used，Hope you can Issues me，Thank you or try to download the latest code of this framework to see the BUG has been fixed or not
* If you find the function is not enough when used，Hope you can Issues me，I very much to add more useful function to this framework ，Thank you !
