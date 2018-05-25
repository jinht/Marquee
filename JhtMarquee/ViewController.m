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
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>

/** 屏幕的宽度 */
#define FrameW [UIScreen mainScreen].bounds.size.width

@interface ViewController () <UIGestureRecognizerDelegate> {
    // 横向 跑马灯
    JhtHorizontalMarquee *_horizontalMarquee;
    
    // 纵向 跑马灯
    JhtVerticalMarquee *_verticalMarquee;
    // 是否暂停了纵向 跑马灯
    BOOL _isPauseV;
}

@end


@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;

#else
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
#endif
    
    [self createUI];
}



#pragma mark - UI
/** createUI */
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"JhtMarqueeDemo";
    
    // 添加 横向 跑马灯
    [self addHorizontalMarquee];
    
    // 添加 纵向 跑马灯
    [self addVerticalMarquee];
}


#pragma mark 横向 跑马灯
/** 添加 横向 跑马灯 */
- (void)addHorizontalMarquee {
    self.horizontalMarquee.text = @" 这是一个跑马灯View，测试一下好不好用，哈哈哈，😁👌😀 😁👌😀 😁👌😀 😁👌😀 哈哈哈哈！ ";
    [self.view addSubview:self.horizontalMarquee];
}


#pragma mark 纵向 跑马灯
/** 添加纵向 跑马灯 */
- (void)addVerticalMarquee {
    [self.view addSubview:self.verticalMarquee];
    
    [self.verticalMarquee scrollWithCallbackBlock:^(JhtVerticalMarquee *view, NSInteger currentIndex) {
        NSLog(@"滚动到第 %ld 条数据", (long)currentIndex);
    }];
    /*
    NSArray *soureArray = @[@"1. 谁曾从谁的青春里走过，留下了笑靥",
                            @"2. 谁曾在谁的花季里停留，温暖了想念",
                            @"3. 谁又从谁的雨季里消失，泛滥了眼泪",
                            @"4. 人生路，路迢迢，谁道自古英雄多寂寥，若一朝，看透了，一身清风挣多少"
                            ];
     */
    
    NSString *str = @"谁曾在谁的花季里停留，温暖了想念";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0f] range:NSMakeRange(0, 3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 2)];
    [attrStr addAttribute:NSBackgroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(7, 2)];
    [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(11, 5)];
    
    NSArray *soureArray = @[@"1. 谁曾从谁的青春里走过，留下了笑靥",
                            attrStr,
                            @"3. 谁又从谁的雨季里消失，泛滥了眼泪",
                            @"4. 人生路，路迢迢，谁道自古英雄多寂寥，若一朝，看透了，一身清风挣多少"];
    
    self.verticalMarquee.sourceArray = soureArray;
    
    // 开始滚动
    [self.verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
}



#pragma mark - Get
/** 横向 跑马灯 */
- (JhtHorizontalMarquee *)horizontalMarquee {
    if (!_horizontalMarquee) {
        _horizontalMarquee = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(0, 66, FrameW, 40) withSingleScrollDuration:10.0];
        
        // 添加点击手势
        UITapGestureRecognizer *htap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(horizontalMarqueeTapGes:)];
        [_horizontalMarquee addGestureRecognizer:htap];
    }
    
    return _horizontalMarquee;
}

/** 纵向 跑马灯 */
- (JhtVerticalMarquee *)verticalMarquee {
    if (!_verticalMarquee) {
        _verticalMarquee = [[JhtVerticalMarquee alloc]  initWithFrame:CGRectMake(10, CGRectGetMaxY(self.horizontalMarquee.frame) + 40, FrameW - 20, 45)];
        
        _verticalMarquee.backgroundColor = [UIColor yellowColor];
        _verticalMarquee.verticalTextColor = [UIColor purpleColor];
        
        // 添加点击手势
        UITapGestureRecognizer *vtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(verticalMarqueeTapGes:)];
        [_verticalMarquee addGestureRecognizer:vtap];
    }
    
    return _verticalMarquee;
}


#pragma mark Get Method
/** 点击 水平滚动跑马灯 触发方法 */
- (void)horizontalMarqueeTapGes:(UITapGestureRecognizer *)ges {
    NSLog(@"点击__水平__滚动的跑马灯啦！！！");
    [self.verticalMarquee marqueeOfSettingWithState:MarqueePause_V];
    _isPauseV = YES;
    
    [self.navigationController pushViewController:[[testVC alloc] init] animated:YES];
}

/** 点击 纵向滚动跑马灯 触发方法 */
- (void)verticalMarqueeTapGes:(UITapGestureRecognizer *)ges {
    NSLog(@"点击__纵向__滚动的跑马灯_第 %ld 条数据啦！！！", (long)self.verticalMarquee.currentIndex);
    [self.verticalMarquee marqueeOfSettingWithState:MarqueePause_V];
    _isPauseV = YES;
    
    [self.navigationController pushViewController:[[testVC alloc] init] animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
