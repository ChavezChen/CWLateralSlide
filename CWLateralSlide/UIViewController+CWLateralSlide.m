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

// 显示默认抽屉
- (void)cw_showDefaultDrawerViewController:(UIViewController *)viewController {
    [self cw_showDrawerViewController:viewController animationType:CWDrawerAnimationTypeDefault configuration:nil];
}

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
    objc_setAssociatedObject(viewController, &CWLateralSlideDirectionKey, @(configuration.direction), OBJC_ASSOCIATION_ASSIGN);

    CWInteractiveTransition *interactiveHidden = [CWInteractiveTransition interactiveWithTransitiontype:CWDrawerTransitiontypeHidden];
    [interactiveHidden setValue:viewController forKey:@"weakVC"];
    [interactiveHidden setValue:@(configuration.direction) forKey:@"direction"];
    
    [animator setValue:interactiveHidden forKey:@"interactiveHidden"];
    animator.configuration = configuration;
    animator.animationType = animationType;
    if (@available(iOS 13.0, *)) {
        viewController.modalPresentationStyle =  UIModalPresentationFullScreen;
    }
    [self presentViewController:viewController animated:YES completion:nil];
    
}

// 注册抽屉手势
- (void)cw_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture transitionDirectionAutoBlock:(void(^)(CWDrawerTransitionDirection direction))transitionDirectionAutoBlock {
    
    CWLateralSlideAnimator *animator = [CWLateralSlideAnimator lateralSlideAnimatorWithConfiguration:nil];
    self.transitioningDelegate = animator;
    
    objc_setAssociatedObject(self, &CWLateralSlideAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CWInteractiveTransition *interactiveShow = [CWInteractiveTransition interactiveWithTransitiontype:CWDrawerTransitiontypeShow];
    [interactiveShow setValue:@(openEdgeGesture) forKey:@"openEdgeGesture"];
    [interactiveShow setValue:transitionDirectionAutoBlock forKey:@"transitionDirectionAutoBlock"];
    [interactiveShow addPanGestureForViewController:self];
    
    [animator setValue:interactiveShow forKey:@"interactiveShow"];
}

// 抽屉内push界面
- (void)cw_pushViewController:(UIViewController *)viewController{
    [self cw_pushViewController:viewController drewerHiddenDuration:0];
}

- (void)cw_pushViewController:(UIViewController *)vc drewerHiddenDuration:(NSTimeInterval)duration {
    
    CWLateralSlideAnimator *animator = (CWLateralSlideAnimator *)self.transitioningDelegate;
    animator.configuration.HiddenAnimDuration = duration > 0 ? duration : animator.configuration.HiddenAnimDuration;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav;
    NSString *TransitionType = kCATransitionPush;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)rootVC;
        NSInteger index = tabbar.selectedIndex;
        nav = tabbar.childViewControllers[index];
    }else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        if (animator.animationType == CWDrawerAnimationTypeDefault) TransitionType = kCATransitionFade;
        nav = (UINavigationController *)rootVC;
    }else  {
        NSLog(@"This no UINavigationController...");
        return;
    }
    
    NSNumber *direction = objc_getAssociatedObject(self, &CWLateralSlideDirectionKey);
    NSString *subType = direction.integerValue ? kCATransitionFromLeft : kCATransitionFromRight;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.20f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = TransitionType;
    transition.subtype = subType;
    [nav.view.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [nav pushViewController:vc animated:NO];
}


// 抽屉内present页面
- (void)cw_presentViewController:(UIViewController *)viewController {
    [self cw_presentViewController:viewController drewerHidden:NO];
}

- (void)cw_presentViewController:(UIViewController *)vc drewerHidden:(BOOL)hidden {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    vc.view.frame = CGRectMake(0, kCWSCREENHEIGHT, kCWSCREENWIDTH, kCWSCREENHEIGHT);
    vc.view.tag = 5201314;
    [keyWindow addSubview:vc.view];
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.frame = CGRectMake(0, 0, kCWSCREENWIDTH, kCWSCREENHEIGHT);
    } completion:^(BOOL finished) {
        // 强引用，不然会被释放
        [rootVC addChildViewController:vc];
        if (hidden) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)cw_dismissViewController {
    if (self.view.tag != 5201314 && self.parentViewController.view.tag != 5201314) {
        NSLog(@"只有通过cw_presentViewController显示的控制器才能调用此方法...");
        return;
    }
    
    UIViewController *weakSelf = self;
    if (self.parentViewController.view.tag == 5201314) {
        weakSelf = self.parentViewController;
    }
    weakSelf.edgesForExtendedLayout = UIRectEdgeNone;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.view.frame = CGRectMake(0, kCWSCREENHEIGHT, kCWSCREENWIDTH, kCWSCREENHEIGHT);
    } completion:^(BOOL finished) {
        [weakSelf.view removeFromSuperview];
        [weakSelf removeFromParentViewController];
    }];
    
}


@end
