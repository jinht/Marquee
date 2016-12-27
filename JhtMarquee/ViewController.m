//
//  ViewController.m
//  JhtMarquee
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2016/12/26.
//  Copyright © 2016年 Jht. All rights reserved.
//

#import "ViewController.h"
#import "testVC.h"
#import "JhtMarqueeLabel.h"

/** 屏幕的宽度 */
#define FrameW [UIScreen mainScreen].bounds.size.width

@interface ViewController () <UIGestureRecognizerDelegate> {
    // 跑马灯
    JhtMarqueeLabel *_marquee;
}

@end


@implementation ViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"JhtMarqueeDemo";
    
    // 添加跑马灯
    [self labsCreateMarquee];
}



#pragma mark - 添加跑马灯
- (void)labsCreateMarquee {
    _marquee = [[JhtMarqueeLabel alloc] initWithFrame:CGRectMake(0, 64, FrameW, 40) withSingleScrollDuration:10.0];
    _marquee.text = @"这是一个跑马灯View，测试一下好不好用，哈哈哈，😁👌😀 😁👌😀 😁👌😀 😁👌😀 哈哈哈哈！";
//    _marquee.backgroundColor = [UIColor redColor];
    [self.view addSubview:_marquee];
    
    // 给跑马灯添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labsMarqueeTapGes:)];
    [_marquee addGestureRecognizer:tap];
}

- (void)labsMarqueeTapGes:(UITapGestureRecognizer *)ges {
    NSLog(@"点击跑马灯啦啊！！！");
    
    [self.navigationController pushViewController:[[testVC alloc] init] animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
