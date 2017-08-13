//
//  CWLateralSlideAnimator.h
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/29.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWLateralSlideConfiguration.h"
#import "CWInteractiveTransition.h"

@interface CWLateralSlideAnimator : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) CWLateralSlideConfiguration *configuration;
@property (nonatomic,assign) CWDrawerAnimationType animationType;

- (instancetype)initWithConfiguration:(CWLateralSlideConfiguration *)configuration;

+ (instancetype)lateralSlideAnimatorWithConfiguration:(CWLateralSlideConfiguration *)configuration;

@end
