//
//  CWLateralSlideConfiguration.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/29.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "CWLateralSlideConfiguration.h"

@implementation CWLateralSlideConfiguration

+ (instancetype)defaultConfiguration {
    return [CWLateralSlideConfiguration configurationWithDistance:kCWSCREENWIDTH * 0.75 maskAlpha:0.4 scaleY:1.0 direction:CWDrawerTransitionFromLeft backImage:nil];
}

- (instancetype)initWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(CWDrawerTransitionDirection)direction backImage:(UIImage *)backImage {
    if (self = [super init]) {
        _distance = distance;
        _maskAlpha = alpha;
        _direction = direction;
        _backImage = backImage;
        _scaleY = scaleY;
    }
    return self;
}

+ (instancetype)configurationWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(CWDrawerTransitionDirection)direction backImage:(UIImage *)backImage {
    return [[self alloc] initWithDistance:distance maskAlpha:alpha scaleY:scaleY direction:direction backImage:backImage];
}

- (float)distance {
    if (_distance <= 0)
        return kCWSCREENWIDTH * 0.75;
    return _distance;
}

- (float)maskAlpha {
    if (_maskAlpha <= 0)
        return 0.4;
    return _maskAlpha;
}

- (float)scaleY {
    if (_scaleY <= 0)
        return 1.0;
    return _scaleY;
}

- (float)finishPercent {
    if (_finishPercent <= 0)
        return 0.5;
    return _finishPercent;
}

- (NSTimeInterval)showAnimDuration {
    if (_showAnimDuration <= 0)
        return 0.25;
    
    return _showAnimDuration;
}

- (NSTimeInterval)HiddenAnimDuration {
    if (_HiddenAnimDuration <= 0)
        return 0.25;
    
    return _HiddenAnimDuration;
}

- (void)dealloc {
//    NSLog(@"%s",__func__);
}

@end



