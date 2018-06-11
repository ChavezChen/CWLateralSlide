//
//  CWScrollView.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/11/30.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "CWScrollView.h"

@implementation CWScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, 0);
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}


/**
 *  重写手势，如果是左滑，则禁用掉scrollview自带的
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        //NSLog(@"%f -- %f", [pan translationInView:self].x, self.contentOffset.x);
        if([pan translationInView:self].x > 0.0f && self.contentOffset.x == 0.0f) {
            //NSLog(@"左滑手势");
            return NO;
        }
        if ([pan translationInView:self].x < 0.0f && self.contentSize.width - self.contentOffset.x <= self.bounds.size.width) {
            //NSLog(@"右滑手势");
            return NO;
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
