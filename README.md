# Marquee
跑马灯/滚动条/动画滚动条/文字滚动条

### 先上图，看一下是否符合你的场景吧！
<img src="https://raw.githubusercontent.com/jinht/RatingBar/master/ReadMEImages/Gif/1.gif"，width=250 height=420 />
&emsp;<img src="https://raw.githubusercontent.com/jinht/RatingBar/master/ReadMEImages/Gif/2.gif"，width=250 height=420 />


### Function Description
1. 点击评分；
2. 滑动评分；
3. 个性化设置。<br>


### How to use
#### 1. 点击评分
```oc
/** 常规初始化方法 */
JhtRatingBar *bar = [[JhtRatingBar alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 280) / 2, 150, 280, 35)];
```

#### 2. 滑动评分：只要这两个属性不关闭，默认是可以滑动评分的
```oc
/** 是否允许可触摸（默认：允许） */
@property (nonatomic, assign) BOOL isEnableTouch;
/** 是否允许滑动选择（默认：允许）（在isEnableTouch = YES的前提下才有意义） */
@property (nonatomic, assign) BOOL scrollSelectEnable;
```


#### 3. 个性化设置：可以通过设置以下属性做相关设置：半分 && 背景颜色 && 获取最终评分
```oc
/** 是否需要半分（默认不需要） */
@property (nonatomic, assign) BOOL isNeedHalf;
/** 底部视图的颜色（默认：白色） */
@property (nonatomic, strong) UIColor *bgViewColor;

/** 点亮星星发生变化 */
@property (nonatomic, copy) StarChange starChange;
/** 获得的分数 */
@property (nonatomic, assign, readonly) CGFloat scale;
__weak JhtRatingBar *weakBar = bar;
    bar.starChange = ^() {
        NSLog(@"scale = %lf", weakBar.scale);
};
```

注：1. 假使这样初始化后不做其他属性的传递，评分条相关属性会使用默认值，例：星星总的数量（默认：5）；<br>
&emsp;&emsp;2. 假使评分条宽度在初始化设置的时候，不足以放得下所有星星，内部会动态改变其宽度以至于可以放得下所有星星。


###Remind
* ARC
* iOS >= 8.0
* iPhone \ iPad 
       
       
## Hope
* If you find bug when used，Hope you can Issues me，Thank you or try to download the latest code of this framework to see the BUG has been fixed or not
* If you find the function is not enough when used，Hope you can Issues me，I very much to add more useful function to this framework ，Thank you !

