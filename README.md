## Marquee（跑马灯）

说一下初衷吧，最初要用到跑马灯功能的时候，也找过一些SDK，但未能找到与我需求很好契合的SDK，主要就是手势滑动后的问题（手势滑动push/pop时候跑马灯出现失灵的状况），故希望通过此SDK给予与我有同样需求的童鞋一些帮助。
<br>

### 先上图，看一下是否符合你的场景吧！
<img src="https://raw.githubusercontent.com/jinht/Marquee/master/ReadMEImages/1.gif"，width=250 height=350 />


### Function Description
1. 轻量级跑马灯；
2. 前/后台切换重新加载；
3. 随时获取跑马灯状态；
4. 手势push/pop后自动滚动<br>


### How to use
#### 1. 简单的集成方式：当成一个普通label使用即可，在初始化方法的时候可以自定义单次滚动时间
```oc
/** 初始化
 *  duration：单次滚动时间
 */
- (instancetype)initWithFrame:(CGRect)frame withSingleScrollDuration:(NSTimeInterval)duration;
```


#### 2. 状态自由设置：通过以下方法传入相应的`MarqueeState`枚举值即可
```oc
#pragma mark 设置跑马灯状态
/** 设置跑马灯状态
 *  marqueeState：跑马灯状态（枚举）
 *  注：“开启跑马灯”放在viewDidAppear中，“关闭跑马灯”放在viewWillDisappear中
 */
- (void)marqueeOfSettingWithState:(MarqueeState)marqueeState;
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


###Remind
* ARC
* iOS >= 8.0
* iPhone \ iPad 
       
       
## Hope
* If you find bug when used，Hope you can Issues me，Thank you or try to download the latest code of this framework to see the BUG has been fixed or not
* If you find the function is not enough when used，Hope you can Issues me，I very much to add more useful function to this framework ，Thank you !

