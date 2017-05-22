//
//  ViewController.m
//  JhtMarquee
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2016/12/26.
//  Copyright © 2016年 JhtMarquee. All rights reserved.
//

#import "ViewController.h"
#import "testVC.h"
#import "JhtVerticalMarquee.h"
#import "JhtHorizontalMarquee.h"

/** 屏幕的宽度 */
#define FrameW [UIScreen mainScreen].bounds.size.width

@interface ViewController () <UIGestureRecognizerDelegate> {
    // 水平滚动的跑马灯
    JhtHorizontalMarquee *_horizontalMarquee;
    
    // 上下滚动的跑马灯
    JhtVerticalMarquee *_verticalMarquee;
    // 是否暂停了上下滚动的跑马灯
    BOOL _isPauseV;
}

@end


@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 如果暂停了，使用继续方式开启
    if (_isPauseV) {
        [_verticalMarquee marqueeOfSettingWithState:MarqueeContinue_V];
    }
    
    // 开启跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 关闭跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeShutDown_H];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    // 创建UI界面
    [self createUI];
}



#pragma mark - UI
/** 创建UI界面 */
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"JhtMarqueeDemo";
    
    // 添加水平滚动的跑马灯
    [self addHorizontalMarquee];
    
    // 添加上下滚动的跑马灯
    [self addVerticalMarquee];
}


#pragma mark 水平滚动的跑马灯
/** 添加水平滚动的跑马灯 */
- (void)addHorizontalMarquee {
    _horizontalMarquee = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(0, 64, FrameW, 40) withSingleScrollDuration:10.0];
    _horizontalMarquee.text = @"这是一个跑马灯View，测试一下好不好用，哈哈哈，😁👌😀 😁👌😀 😁👌😀 😁👌😀 哈哈哈哈！ ";
    [self.view addSubview:_horizontalMarquee];
    
    // 给跑马灯添加点击手势
    UITapGestureRecognizer *htap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(horizontalMarqueeTapGes:)];
    [_horizontalMarquee addGestureRecognizer:htap];
}

- (void)horizontalMarqueeTapGes:(UITapGestureRecognizer *)ges {
    NSLog(@"点击__水平__滚动的跑马灯啦啊！！！");
    [_verticalMarquee marqueeOfSettingWithState:MarqueePause_V];
    _isPauseV = YES;
    
    [self.navigationController pushViewController:[[testVC alloc] init] animated:YES];
}


#pragma mark 上下滚动的跑马灯
/** 添加上下滚动的跑马灯 */
- (void)addVerticalMarquee {
    _verticalMarquee = [[JhtVerticalMarquee alloc]  initWithFrame:CGRectMake(10, 200, FrameW - 20, 45)];
    [self.view addSubview:_verticalMarquee];
    _verticalMarquee.backgroundColor = [UIColor yellowColor];
    _verticalMarquee.verticalTextColor = [UIColor purpleColor];
    NSArray *soureArray = @[@"1. 谁曾从谁的青春里走过，留下了笑靥",
                            @"2. 谁曾在谁的花季里停留，温暖了想念",
                            @"3. 谁又从谁的雨季里消失，泛滥了眼泪",
                            @"4. 人生路，路迢迢，谁道自古英雄多寂寥，若一朝，看透了，一身清风挣多少"
                            ];
//    _verticalMarquee.isCounterclockwise = YES;
    _verticalMarquee.sourceArray = soureArray;
    [_verticalMarquee scrollWithCallbackBlock:^(JhtVerticalMarquee *view, NSInteger currentIndex) {
        NSLog(@"滚动到第 %ld 条数据", currentIndex);
    }];
    
    // 开始滚动
    [_verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
    
    // 给跑马灯添加点击手势
    UITapGestureRecognizer *vtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(verticalMarqueeTapGes:)];
    [_verticalMarquee addGestureRecognizer:vtap];
}

- (void)verticalMarqueeTapGes:(UITapGestureRecognizer *)ges {
    NSLog(@"点击第 %ld 条数据啦啊！！！", _verticalMarquee.index);
    [_verticalMarquee marqueeOfSettingWithState:MarqueePause_V];
    _isPauseV = YES;
    
    [self.navigationController pushViewController:[[testVC alloc] init] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
