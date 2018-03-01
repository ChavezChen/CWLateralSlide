//
//  CWInteractiveTransition.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/28.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "CWInteractiveTransition.h"

@interface CWInteractiveTransition ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIViewController *weakVC;
@property (nonatomic,assign) CWDrawerTransitiontype type;
@property (nonatomic,assign) BOOL openEdgeGesture;
@property (nonatomic,assign) CWDrawerTransitionDirection direction;
@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic,copy) void(^transitionDirectionAutoBlock)(CWDrawerTransitionDirection direction);

@end

@implementation CWInteractiveTransition
{
    CGFloat _percent;
    CGFloat _remaincount;
    BOOL    _toFinish;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cw_singleTap) name:CWLateralSlideTapNoticationKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cw_handleHiddenPan:) name:CWLateralSlidePanNoticationKey object:nil];
    }
    return self;
}

+ (instancetype)interactiveWithTransitiontype:(CWDrawerTransitiontype)type {
    return [[self alloc] initWithTransitiontype:type];
}

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    
    self.weakVC = viewController;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cw_handleShowPan:)];
    pan.delegate = self;
    [viewController.view addGestureRecognizer:pan];
}

- (UIViewController *)viewController:(UIView *)view{
    for (UIView* next = view; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
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
    if ((x > 0 && _direction == CWDrawerTransitionFromLeft ) ||
        (x < 0 && _direction == CWDrawerTransitionFromRight )) return;
    self.interacting = YES;
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)showBeganTranslationX:(CGFloat)x gesture:(UIPanGestureRecognizer *)pan {
//    NSLog(@"---->%f", x);
    if (x >= 0) _direction = CWDrawerTransitionFromLeft;
    else        _direction = CWDrawerTransitionFromRight;
    
    if ((x < 0 && _direction == CWDrawerTransitionFromLeft) ||
        (x > 0 && _direction == CWDrawerTransitionFromRight)) return;
    
    CGFloat locX = [pan locationInView:_weakVC.view].x;
    //    NSLog(@"locX: %f",locX);
    if (_openEdgeGesture && ((locX > 50 && _direction == CWDrawerTransitionFromLeft) || (locX < CGRectGetWidth(_weakVC.view.frame) - 50 && _direction == CWDrawerTransitionFromRight))) return;
    
    self.interacting = YES;
    if (_transitionDirectionAutoBlock) {
        _transitionDirectionAutoBlock(_direction);
    }
}

- (void)handleGesture:(UIPanGestureRecognizer *)pan  {
    
    CGFloat x = [pan translationInView:pan.view].x;
    
    _percent = 0;
    _percent = x / pan.view.frame.size.width;
    
    if ((_direction == CWDrawerTransitionFromRight && _type == CWDrawerTransitiontypeShow) || (_direction == CWDrawerTransitionFromLeft && _type == CWDrawerTransitiontypeHidden)) {
        _percent = -_percent;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            if (!self.interacting) { // 保证present只调用一次
                if (_type == CWDrawerTransitiontypeShow) {
                    // 0是零界点，滑动慢的时候向右边滑动可能会导致x为0然后在接下来的自动判断方向识别为向左滑
                    if (x != 0) [self showBeganTranslationX:x gesture:pan];
                }else {
                    [self hiddenBeganTranslationX:x];
                }
            }else {
                _percent = fminf(fmaxf(_percent, 0.001), 1.0);
                [self updateInteractiveTransition:_percent];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.interacting = NO;
            if (_percent > self.configuration.finishPercent) {
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([[self viewController:otherGestureRecognizer.view] isKindOfClass:[UITableViewController class]]) {
        return YES;
    }
    return NO;
}



@end

