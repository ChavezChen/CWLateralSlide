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


- (void)cw_presentViewController:(UIViewController *)viewController configuration:(CWLateralSlideConfiguration *)configuration {
    
    if (viewController == nil) return;

    if (configuration == nil)
        configuration = [CWLateralSlideConfiguration configurationWithDistance:kCWSCREENWIDTH * 0.75 maskAlpha:0.4 scaleY:1.0 direction:CWDrawerTransitionDirectionLeft backImage:nil];
    
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

    [self presentViewController:viewController animated:YES completion:nil];
    
}

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


- (void)cw_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture direction:(CWDrawerTransitionDirection)direction transitionBlock:(void(^)())transitionBlock {
    
    CWLateralSlideAnimator *animator = [CWLateralSlideAnimator lateralSlideAnimatorWithConfiguration:nil];
    
    self.transitioningDelegate = animator;
    
    objc_setAssociatedObject(self, &CWLateralSlideAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CWInteractiveTransition *interactiveShow = [CWInteractiveTransition interactiveWithTransitiontype:CWDrawerTransitiontypeShow];
    [interactiveShow addPanGestureForViewController:self];
    [interactiveShow setValue:@(openEdgeGesture) forKey:@"openEdgeGesture"];
    [interactiveShow setValue:transitionBlock forKey:@"transitionBlock"];
    [interactiveShow setValue:@(direction) forKey:@"direction"];

    [animator setValue:interactiveShow forKey:@"interactiveShow"];
}



@end
