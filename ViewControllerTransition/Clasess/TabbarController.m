//
//  TabbarController.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/28.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "TabbarController.h"
#import "ViewController.h"
#import "NavigationController.h"

@interface TabbarController ()

@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *vc1 = [[ViewController alloc] init];
    NavigationController *nav1 = [[NavigationController alloc] initWithRootViewController:vc1];
    vc1.title = @"聊天";
//    vc1.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:nav1];
    
    
    ViewController *vc2 = [[ViewController alloc] init];
    NavigationController *nav2 = [[NavigationController alloc] initWithRootViewController:vc2];
    vc2.title = @"通讯录";
    vc2.view.backgroundColor = [UIColor cyanColor];
    [self addChildViewController:nav2];
    
}







@end
