//
//  UIViewController+CWLateralSlide.h
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/29.
//  Copyright © 2017年 chavez. All rights reserved.
//  v1.6.4

#import <UIKit/UIKit.h>
#import "CWLateralSlideAnimator.h"
#import "CWLateralSlideConfiguration.h"

@interface UIViewController (CWLateralSlide)

/*-----------------------------------v1.6.5-----------------------------------------*/
/*-----------------------------------v1.6.5-----------------------------------------*/
/*-----------------------------------v1.6.5-----------------------------------------*/

/**
 显示默认抽屉
 从左侧滑出类似QQ抽屉效果
 @param viewController 需要侧滑显示出来的控制器
 */
- (void)cw_showDefaultDrawerViewController:(UIViewController *)viewController;

/**
 呼出侧滑控制器的方法（主要）

 @param viewController 需要侧滑显示出来的控制器
 @param animationType 侧滑时候的动画类型
 @param configuration 侧滑过程的一些参数配置，如果传nil会创建一个默认的配置参数
 */
- (void)cw_showDrawerViewController:(UIViewController *)viewController
                      animationType:(CWDrawerAnimationType)animationType
                      configuration:(CWLateralSlideConfiguration *)configuration;

/**
 注册手势驱动方法，侧滑呼出的方向自动确定，一般在viewDidLoad调用，调用之后会添加一个支持侧滑的手势到本控制器
 
 @param openEdgeGesture 是否开启边缘手势,系统的边缘手势判断
 @param transitionDirectionAutoBlock 手势过程中执行的操作。根据参数direction传整个点击present的事件即可（看demo的使用）
 */
- (void)cw_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture
                    transitionDirectionAutoBlock:(void(^)(CWDrawerTransitionDirection direction))transitionDirectionAutoBlock;

/**
 Custom push method 自定义的push动画
 push another viewController in the side slip out of the controller 在侧滑界面push另一个界面
 @param viewController Need to push of the controller
 */
- (void)cw_pushViewController:(UIViewController *)viewController;

/**
 Custom push method 自定义的push动画,比上面的API多了一个时间参数
 push another viewController in the side slip out of the controller. 在侧滑界面push另一个界面
 @param vc  Need to push of the controller
 @param duration  The Drewer Hidden Animation Duration When Push. push时抽屉隐藏动画的持续时间
 */
- (void)cw_pushViewController:(UIViewController *)vc
         drewerHiddenDuration:(NSTimeInterval)duration;

/**
 Custom present method 自定义的present动画
 present another viewController in the side slip out of the controller 在侧滑界面present另一个界面
 @param viewController Need to present of the controller
 */
- (void)cw_presentViewController:(UIViewController *)viewController;

/**
 Custom present method 自定义的present动画
 present another viewController in the side slip out of the controller 在侧滑界面present另一个界面
 @param vc Need to present of the controller
 @param hidden  The Drewer isHidden . present时抽屉是否隐藏
 */
- (void)cw_presentViewController:(UIViewController *)vc
                    drewerHidden:(BOOL)hidden;

/**
 Custom present method 自定义的dismiss动画
 必须要是通过cw_presentViewController的控制器才能使用这个方法dismiss
 */
- (void)cw_dismissViewController;



@end
