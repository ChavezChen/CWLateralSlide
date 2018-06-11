//
//  TabbarController.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/28.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "TabbarController.h"
#import "MainViewController.h"
#import "NavigationController.h"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface TabbarController ()

@end

@implementation TabbarController

+ (void)initialize{
    // 设置tabbarItem统一样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:87/255.0 green:125/255.0 blue:130/255.0 alpha:1.0];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:12/255.0 green:204/255.0 blue:207/255.0 alpha:1.0];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupChildVc:[MainViewController new] title:@"聊天" image:@"tab_zhushou" selectedImage:@"tab_zhushou_pre"];

    [self setupChildVc:[MainViewController new] title:@"通讯录" image:@"tab_wenzhen" selectedImage:@"tab_wenzhen_pre"];
    
}

- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    return;
    if (!iPhoneX) return;

    for (UIView *view in self.tabBar.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"]) {
            CGRect frame = view.frame;
            frame.size.height = 48;
            view.frame = frame;
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:48];
            heightConstraint.priority = UILayoutPriorityDefaultHigh;
//            [view addConstraint:heightConstraint];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!iPhoneX) return;
    CGRect frame = self.tabBar.frame;
    CGFloat h = 83 - frame.size.height;
    frame.size.height += h;
    frame.origin.y -= h;
    self.tabBar.frame = frame;
    
}




@end
