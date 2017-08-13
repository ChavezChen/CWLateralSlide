//
//  UIViewController+CWLateralSlide.h
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/29.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWLateralSlideAnimator.h"
#import "CWLateralSlideConfiguration.h"

@interface UIViewController (CWLateralSlide)



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
 注册手势驱动方法，一般在viewDidLoad调用，调用之后会添加一个支持侧滑的手势到本控制器

 @param openEdgeGesture 是否开启边缘手势,边缘手势的开始范围为距离边缘50以内
 @param direction 侧滑呼出的方向，请与配置参数里面的方向保持一致，配置参数为nil是传左侧呼出
 @param transitionBlock 手势过程中执行的操作。传整个点击present的事件即可（看demo的使用）
 */
- (void)cw_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture
                                       direction:(CWDrawerTransitionDirection)direction transitionBlock:(void(^)())transitionBlock;


/**
 自定义的push方法
 因为侧滑出来的控制器实际上是通过present出来的，这个时候是没有导航控制器的，而侧滑出来的控制器上面的一些点击事件需要再push下一个控制器的时候，我们只能通过寻找到根控制器找到对应的导航控制器再进行push操作，QQ的效果能证明是这么实现的
 @param viewController 需要push出来的控制器
 */
- (void)cw_pushViewController:(UIViewController *)viewController;




@end
