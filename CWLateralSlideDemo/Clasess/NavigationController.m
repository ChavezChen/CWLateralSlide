//
//  NavigationController.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/28.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController


+ (void)initialize{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:18]; // 字体大小
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor]; // 颜色
    
    UINavigationBar *naviBar = [UINavigationBar appearance];
    [naviBar setTitleTextAttributes:attrs];
//    [naviBar setBackgroundImage:[UIImage imageNamed:@"yitiji_date_nav_bg"] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    return;
    // 解决iOS11界面缩放后导航栏空出状态栏的空隙的问题
    if (@available(iOS 11, *)) { // xcode9新特性 可以这样判断，xcode9以下只能用UIDevice systemVersion 来判断
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        CGFloat statusH = CGRectGetHeight(statusBar.frame);
        for (UIView *view in self.navigationBar.subviews) {
            if ([NSStringFromClass([view class]) isEqualToString:@"_UIBarBackground"]) {
                CGRect frame = view.frame;
                frame.size.height = 44 + statusH;
                frame.origin.y = -statusH;
                view.frame = frame;
            }
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
