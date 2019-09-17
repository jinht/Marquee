//
//  testVC.m
//  JhtMarquee
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2016/12/26.
//  Copyright © 2016年 JhtMarquee. All rights reserved.
//

#import "testVC.h"

@implementation testVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TestVC";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, 200, 20)];
    lab.text = @" 这是testVC，你可以右滑返回哦！";
    [lab sizeToFit];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 5;
    lab.backgroundColor = [UIColor redColor];
    [self.view addSubview:lab];
}


@end
