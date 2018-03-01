//
//  CWLateralSlideConfiguration.h
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/29.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kCWSCREENWIDTH [UIScreen mainScreen].bounds.size.width

typedef NS_ENUM(NSUInteger,CWDrawerTransitionDirection) {
    CWDrawerTransitionFromLeft = 0, // 左侧滑出
    CWDrawerTransitionFromRight     // 右侧滑出
};

@interface CWLateralSlideConfiguration : NSObject

/**
 根控制器可偏移的距离，默认为屏幕的0.75
 */
@property (nonatomic,assign) float distance;

/**
 手势驱动动画完成的临界点（范围0 - 1.0），默认为0.5（表示手势驱动到动画的一半则执行完动画，拖动不到一半则会取消动画）
 */
@property (nonatomic,assign) float finishPercent;

/**
 抽屉显示动画的持续时间，默认为0.25f
 */
@property (nonatomic,assign) NSTimeInterval showAnimDuration;

/**
 抽屉隐藏动画的持续时间，默认为0.25f
 */
@property (nonatomic,assign) NSTimeInterval HiddenAnimDuration;

/**
 遮罩的透明度
 */
@property (nonatomic,assign) float maskAlpha;

/**
 根控制器在y方向的缩放，默认为不缩放
 */
@property (nonatomic,assign) float scaleY;

/**
 菜单滑出的方向，默认为从左侧滑出
 */
@property (nonatomic,assign) CWDrawerTransitionDirection direction;

/**
 动画切换过程中，最底层的背景图片
 */
@property (nonatomic,strong) UIImage *backImage;



/**
 默认配置

 @return 配置对象本身
 */
+ (instancetype)defaultConfiguration;

/**
 创建一个配置对象的实例方法

 @param distance 偏移距离
 @param alpha 遮罩的透明度
 @param scaleY y方向的缩放 (仅CWDrawerAnimationTypeDefault动画模式有效)
 @param direction 滑出方向
 @param backImage 动画切换过程中，最底层的背景图片 (仅CWDrawerAnimationTypeDefault动画模式有效)
 @return 配置对象本身
 */
- (instancetype)initWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(CWDrawerTransitionDirection)direction backImage:(UIImage *)backImage;

/**
 创建一个配置对象的类方法

 @param distance 偏移距离
 @param alpha 遮罩的透明度
 @param scaleY y方向的缩放
 @param direction 滑出方向
 @param backImage 动画切换过程中，最底层的背景图片
 @return 配置对象本身
 */
+ (instancetype)configurationWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(CWDrawerTransitionDirection)direction backImage:(UIImage *)backImage;

@end
