//
//  CWDrawerTransition.h
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/27.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CWLateralSlideConfiguration.h"

typedef NS_ENUM(NSUInteger,CWDrawerTransitiontype) {
    CWDrawerTransitiontypeShow = 0,
    CWDrawerTransitiontypeHidden
};


typedef NS_ENUM(NSUInteger,CWDrawerAnimationType) {
    CWDrawerAnimationTypeDefault = 0,
    CWDrawerAnimationTypeMask
};

@interface CWDrawerTransition : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(CWDrawerTransitiontype)transitionType animationType:(CWDrawerAnimationType)animationType configuration:(CWLateralSlideConfiguration *)configuration;

+ (instancetype)transitionWithType:(CWDrawerTransitiontype)transitionType animationType:(CWDrawerAnimationType)animationType configuration:(CWLateralSlideConfiguration *)configuration;

@end


@interface MsakView : UIView<UIGestureRecognizerDelegate>

@end


UIKIT_EXTERN NSString *const CWLateralSlideAnimatorKey;
UIKIT_EXTERN NSString *const CWLateralSlideMaskViewKey;
UIKIT_EXTERN NSString *const CWLateralSlideInterativeKey;

UIKIT_EXTERN NSString *const CWLateralSlidePanNotication;
UIKIT_EXTERN NSString *const CWLateralSlideTapNotication;




