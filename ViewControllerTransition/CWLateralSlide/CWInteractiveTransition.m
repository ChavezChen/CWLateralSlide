//
//  CWInteractiveTransition.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/28.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "CWInteractiveTransition.h"

@interface CWInteractiveTransition ()

@property (nonatomic,weak) UIViewController *weakVC;

@property (nonatomic,assign) CWDrawerTransitiontype type;

@property (nonatomic,assign) BOOL openEdgeGesture;

@property (nonatomic,assign) CWDrawerTransitionDirection direction;

@property (nonatomic,strong) CADisplayLink *link;

@property (nonatomic,copy) void(^transitionBlock)();

@end

@implementation CWInteractiveTransition
{
    CGFloat _percent;
    CGFloat _remaincount;
    BOOL _toFinish;
    CGFloat _oncePercent;
}

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(cw_update)];
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

- (instancetype)initWithTransitiontype:(CWDrawerTransitiontype)type {
    if (self = [super init]) {
        _type = type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cw_singleTap) name:CWLateralSlideTapNotication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cw_handleHiddenPan:) name:CWLateralSlidePanNotication object:nil];
    }
    return self;
}

+ (instancetype)interactiveWithTransitiontype:(CWDrawerTransitiontype)type {
    return [[self alloc] initWithTransitiontype:type];
}

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    
    self.weakVC = viewController;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cw_handleShowPan:)];
    [viewController.view addGestureRecognizer:pan];

}

#pragma mark -GestureRecognizer
- (void)cw_singleTap {
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)cw_handleHiddenPan:(NSNotification *)note {
    
    if (_type == CWDrawerTransitiontypeShow) return;

    UIPanGestureRecognizer *pan = note.object;
    [self handleGesture:pan];

}

- (void)cw_handleShowPan:(UIPanGestureRecognizer *)pan {
    
    if (_type == CWDrawerTransitiontypeHidden) return;
    
    [self handleGesture:pan];

}

- (void)hiddenBeganTranslationX:(CGFloat)x {
    if ((x > 0 && _direction == CWDrawerTransitionDirectionLeft ) || (x < 0 && _direction == CWDrawerTransitionDirectionRight )) return;
    self.interacting = YES;
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)showBeganTranslationX:(CGFloat)x gesture:(UIPanGestureRecognizer *)pan {
    if ((x < 0 && _direction == CWDrawerTransitionDirectionLeft) || (x > 0 && _direction == CWDrawerTransitionDirectionRight)) return;
    
    CGFloat locX = [pan locationInView:_weakVC.view].x;
//    NSLog(@"locX: %f",locX);
    if (_openEdgeGesture && ((locX > 50 && _direction == CWDrawerTransitionDirectionLeft) || (locX < CGRectGetWidth(_weakVC.view.frame) - 50 && _direction == CWDrawerTransitionDirectionRight))) {
        return;
    }
    self.interacting = YES;
    if (_transitionBlock) {
        _transitionBlock();
    }
}

- (void)handleGesture:(UIPanGestureRecognizer *)pan  {
    
    CGFloat x = [pan translationInView:pan.view].x;
    
    _percent = 0;
    _percent = x / self.configuration.distance;
    
    if ((_direction == CWDrawerTransitionDirectionRight && _type == CWDrawerTransitiontypeShow) || (_direction == CWDrawerTransitionDirectionLeft && _type == CWDrawerTransitiontypeHidden)) {
        _percent = -_percent;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if (_type == CWDrawerTransitiontypeShow) {
                [self showBeganTranslationX:x gesture:pan];
            }else {
                [self hiddenBeganTranslationX:x];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            _percent = fminf(fmaxf(_percent, 0.0), 1.0);
            [self updateInteractiveTransition:_percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.interacting = NO;
            if (_percent > 0.5) {
                [self startDisplayerLink:_percent toFinish:YES];
            }else {
                [self startDisplayerLink:_percent toFinish:NO];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startDisplayerLink:(CGFloat)percent toFinish:(BOOL)finish{
    
    _toFinish = finish;
    CGFloat remainDuration = finish ? self.duration * (1 - percent) : self.duration * percent;
    _remaincount = 60 * remainDuration;
    _oncePercent = finish ? (1 - percent) / _remaincount : percent / _remaincount;
    
    [self starDisplayLink];
}

#pragma mark - displayerLink
- (void)starDisplayLink {
    [self link];
}

- (void)stopDisplayerLink {
    [self.link invalidate];
    self.link = nil;
}

- (void)cw_update {

    if (_percent >= 1 && _toFinish) {
        [self stopDisplayerLink];
        [self finishInteractiveTransition];
    }else if (_percent <= 0 && !_toFinish) {
        [self stopDisplayerLink];
        [self cancelInteractiveTransition];
    }else {
        if (_toFinish) {
            _percent += _oncePercent;
        }else {
            _percent -= _oncePercent;
        }
        _percent = fminf(fmaxf(_percent, 0.0), 1.0);
        [self updateInteractiveTransition:_percent];
    }
}

- (void)dealloc {
//    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
