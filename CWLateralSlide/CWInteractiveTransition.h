//
//  CWInteractiveTransition.h
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/28.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWDrawerTransition.h"

@interface CWInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic,weak) CWLateralSlideConfiguration *configuration;
@property (nonatomic,assign) BOOL interacting;


- (instancetype)initWithTransitiontype:(CWDrawerTransitiontype)type;

+ (instancetype)interactiveWithTransitiontype:(CWDrawerTransitiontype)type;

- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end



