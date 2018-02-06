//
//  CWDrawerTransition.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/27.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "CWDrawerTransition.h"
#import <objc/runtime.h>
@interface CWDrawerTransition ()

@property (nonatomic,weak) CWLateralSlideConfiguration *configuration;

@end

@implementation CWDrawerTransition
{
    CWDrawerTransitiontype _TransitionType;
    CWDrawerAnimationType _animationType;
    CGFloat _hiddenDelayTime;
}


- (instancetype)initWithTransitionType:(CWDrawerTransitiontype)transitionType animationType:(CWDrawerAnimationType)animationType configuration:(CWLateralSlideConfiguration *)configuration {
    if (self = [super init]) {
        _TransitionType = transitionType;
        _animationType = animationType;
        _configuration = configuration;
        if (_TransitionType == CWDrawerTransitiontypeHidden)
        [self setupHiddenAnimationDelayTime];
    }
    return self;
}

+ (instancetype)transitionWithType:(CWDrawerTransitiontype)transitionType animationType:(CWDrawerAnimationType)animationType configuration:(CWLateralSlideConfiguration *)configuration {
    return [[self alloc] initWithTransitionType:transitionType animationType:animationType configuration:configuration];
}

- (void)setupHiddenAnimationDelayTime {
    _hiddenDelayTime = 0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        _hiddenDelayTime = 0.03;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return _TransitionType == CWDrawerTransitiontypeShow ? self.configuration.showAnimDuration : self.configuration.HiddenAnimDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    switch (_TransitionType) {
        case CWDrawerTransitiontypeShow:
            [self animationViewShow:transitionContext];
            break;
        case CWDrawerTransitiontypeHidden:
            [self animationViewHidden:transitionContext];
            break;
        default:
            break;
    }
}

#pragma mark - private methods
- (void)animationViewShow:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (_animationType == CWDrawerAnimationTypeDefault) {
        [self defaultAnimationWithContext:transitionContext];
    }else if (_animationType == CWDrawerAnimationTypeMask) {
        [self maskAnimationWithContext:transitionContext];
    }else {
        
    }
}

- (void)animationViewHidden:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CWMaskView *maskView = [CWMaskView shareInstance];
    for (UIView *view in toVC.view.subviews) {
        if (![maskView.toViewSubViews containsObject:view]) {
            [view removeFromSuperview];
        }
    }

    UIView *containerView = [transitionContext containerView];
    UIImageView *backImageView;
    if ([containerView.subviews.firstObject isKindOfClass:[UIImageView class]])
        backImageView = containerView.subviews.firstObject;
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:_hiddenDelayTime options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{

        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
            toVC.view.transform = CGAffineTransformIdentity;
            fromVC.view.transform = CGAffineTransformIdentity;
            maskView.alpha = 0;
            backImageView.transform = CGAffineTransformMakeScale(1.4, 1.4);
        }];
        
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            maskView.toViewSubViews = nil;
            [CWMaskView releaseInstance];
            [backImageView removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

- (void)defaultAnimationWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CWMaskView *maskView = [CWMaskView shareInstance];
    maskView.frame = fromVC.view.bounds;
    [fromVC.view addSubview:maskView];
    UIView *containerView = [transitionContext containerView];
    
    UIImageView *imageV;
    if (self.configuration.backImage) {
        imageV = [[UIImageView alloc] initWithFrame:containerView.bounds];
        imageV.image = self.configuration.backImage;
        imageV.transform = CGAffineTransformMakeScale(1.4, 1.4);
        imageV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    [containerView addSubview:imageV];
    
    CGFloat width = self.configuration.distance;
    CGFloat x = - width / 2;
    CGFloat ret = 1;
    if (self.configuration.direction == CWDrawerTransitionFromRight) {
        x = kCWSCREENWIDTH - width / 2;
        ret = -1;
    }
    toVC.view.frame = CGRectMake(x, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    // 计算缩放后需要平移的距离
    CGFloat translationX = width - (kCWSCREENWIDTH * (1 - self.configuration.scaleY) / 2);
    CGAffineTransform t1 = CGAffineTransformMakeScale(self.configuration.scaleY, self.configuration.scaleY);
    CGAffineTransform t2 = CGAffineTransformMakeTranslation(ret * translationX, 0);
    CGAffineTransform fromVCTransform = CGAffineTransformConcat(t1, t2);
    CGAffineTransform toVCTransform;
    if (self.configuration.direction == CWDrawerTransitionFromRight) {
        toVCTransform = CGAffineTransformMakeTranslation(ret * (x - CGRectGetWidth(containerView.frame) + width), 0);
    }else {
        toVCTransform = CGAffineTransformMakeTranslation(ret * width / 2, 0);
    }
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            
            fromVC.view.transform = fromVCTransform;
            toVC.view.transform = toVCTransform;
            imageV.transform = CGAffineTransformIdentity;
            maskView.alpha = self.configuration.maskAlpha;
            
        }];
        
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            maskView.userInteractionEnabled = YES;
            maskView.toViewSubViews = fromVC.view.subviews;
            [transitionContext completeTransition:YES];
            [containerView addSubview:fromVC.view];
        }else {
            [imageV removeFromSuperview];
            [CWMaskView releaseInstance];
            [transitionContext completeTransition:NO];
        }
    }];
}

- (void)maskAnimationWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CWMaskView *maskView = [CWMaskView shareInstance];
    maskView.frame = fromVC.view.bounds;
    [fromVC.view addSubview:maskView];
    
    UIView *containerView = [transitionContext containerView];
    
    CGFloat width = self.configuration.distance;
    CGFloat x = - width;
    CGFloat ret = 1;
    if (self.configuration.direction == CWDrawerTransitionFromRight) {
        x = kCWSCREENWIDTH;
        ret = -1;
    }
    toVC.view.frame = CGRectMake(x, 0, width, CGRectGetHeight(containerView.frame));
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    CGAffineTransform toVCTransiform = CGAffineTransformMakeTranslation(ret * width , 0);
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            toVC.view.transform = toVCTransiform;
            maskView.alpha = self.configuration.maskAlpha;
        }];
        
    } completion:^(BOOL finished) {
        
        if (![transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:YES];
            maskView.toViewSubViews = fromVC.view.subviews;
            [containerView addSubview:fromVC.view];
            [containerView bringSubviewToFront:toVC.view];
            maskView.userInteractionEnabled = YES;
        }else {
            [CWMaskView releaseInstance];
            [transitionContext completeTransition:NO];
        }
    }];
}


- (void)dealloc {
//    NSLog(@"%s",__func__);
}


@end


@implementation CWMaskView
static CWMaskView *cw_shareInstance = nil;
static dispatch_once_t cw_onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&cw_onceToken, ^{
        cw_shareInstance = [[CWMaskView alloc] init];
    });
    return cw_shareInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)singleTap {
    [[NSNotificationCenter defaultCenter] postNotificationName:CWLateralSlideTapNoticationKey object:self];
}

- (void)handleGesture:(UIPanGestureRecognizer *)pan {
    [[NSNotificationCenter defaultCenter] postNotificationName:CWLateralSlidePanNoticationKey object:pan];
}

+ (void)releaseInstance{
    [cw_shareInstance removeFromSuperview];
    cw_onceToken = 0;
    cw_shareInstance = nil;
}

- (void)dealloc {
//    NSLog(@"mask dealloc");
}

@end

NSString *const CWLateralSlideMaskViewKey = @"CWLateralSlideMaskViewKey";
NSString *const CWLateralSlideAnimatorKey = @"CWLateralSlideAnimatorKey";
NSString *const CWLateralSlideInterativeKey = @"CWLateralSlideInterativeKey";

NSString *const CWLateralSlidePanNoticationKey = @"CWLateralSlidePanNoticationKey";
NSString *const CWLateralSlideTapNoticationKey = @"CWLateralSlideTapNoticationKey";

NSString *const CWLateralSlideDirectionKey = @"CWLateralSlideDirectionKey";



