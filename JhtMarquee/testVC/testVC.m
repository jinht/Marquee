//
//  testVC.m
//  JhtMarquee
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2016/12/26.
//  Copyright © 2016年 Jht. All rights reserved.
//

#import "testVC.h"

@implementation testVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TestVC";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, 200, 20)];
    lab.text = @"这是testVC，你可以右滑返回哦！";
    [lab sizeToFit];
    lab.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:lab];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
