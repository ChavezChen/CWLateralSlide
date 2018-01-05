//
//  UIViewController+CWLateralSlide.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/29.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "UIViewController+CWLateralSlide.h"
#import "CWInteractiveTransition.h"
#import "CWDrawerTransition.h"
#import <objc/runtime.h>


@implementation UIViewController (CWLateralSlide)

// 显示抽屉
- (void)cw_showDrawerViewController:(UIViewController *)viewController animationType:(CWDrawerAnimationType)animationType configuration:(CWLateralSlideConfiguration *)configuration {
    
    if (viewController == nil) return;
    
    if (configuration == nil)
        configuration = [CWLateralSlideConfiguration defaultConfiguration];
    
    CWLateralSlideAnimator *animator = objc_getAssociatedObject(self, &CWLateralSlideAnimatorKey);
    
    if (animator == nil) {
        animator = [CWLateralSlideAnimator lateralSlideAnimatorWithConfiguration:configuration];
        objc_setAssociatedObject(viewController, &CWLateralSlideAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    viewController.transitioningDelegate = animator;
    
    CWInteractiveTransition *interactiveHidden = [CWInteractiveTransition interactiveWithTransitiontype:CWDrawerTransitiontypeHidden];
    [interactiveHidden setValue:viewController forKey:@"weakVC"];
    [interactiveHidden setValue:@(configuration.direction) forKey:@"direction"];
    
    [animator setValue:interactiveHidden forKey:@"interactiveHidden"];
    animator.configuration = configuration;
    animator.animationType = animationType;

    [self presentViewController:viewController animated:YES completion:nil];
    
}

// 注册抽屉手势
- (void)cw_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture transitionDirectionAutoBlock:(void(^)(CWDrawerTransitionDirection direction))transitionDirectionAutoBlock {
    
    CWLateralSlideAnimator *animator = [CWLateralSlideAnimator lateralSlideAnimatorWithConfiguration:nil];
    self.transitioningDelegate = animator;
    
    objc_setAssociatedObject(self, &CWLateralSlideAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CWInteractiveTransition *interactiveShow = [CWInteractiveTransition interactiveWithTransitiontype:CWDrawerTransitiontypeShow];
    [interactiveShow addPanGestureForViewController:self];
    [interactiveShow setValue:@(openEdgeGesture) forKey:@"openEdgeGesture"];
    [interactiveShow setValue:transitionDirectionAutoBlock forKey:@"transitionDirectionAutoBlock"];
    [interactiveShow setValue:@(CWDrawerTransitionDirectionLeft) forKey:@"direction"];
    
    [animator setValue:interactiveShow forKey:@"interactiveShow"];
}

// 抽屉内push界面
- (void)cw_pushViewController:(UIViewController *)viewController{
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)rootVC;
        NSInteger index = tabbar.selectedIndex;
        nav = tabbar.childViewControllers[index];
    }else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)rootVC;
    }else if ([rootVC isKindOfClass:[UIViewController class]]) {
        NSLog(@"This no UINavigationController...");
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [nav pushViewController:viewController animated:NO];
    
}

@end
