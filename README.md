# CWLateralSlide
![iOS7+](https://img.shields.io/badge/iOS-7%2B-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/CWLateralSlide.svg?style=flat)](https://cocoapods.org/pods/CWLateralSlide)

打破传统侧滑抽屉框架LeftVC，RightVC，CenterVC模式，使用自定义转场动画实现的**0耦合、0侵入、0污染**的抽屉框架，抽屉控制器拥有完整的生命周期函数调用，关闭抽屉时抽屉不会展示在我们看不见的地方（屏幕外，或者根控制器下边）,**最重要的是简单：只要一行代码就能拥有一个侧滑抽屉**。

实现的一些细节方面可以看一下我的文章
[需要侧滑抽屉效果？一行代码足以](https://juejin.im/post/5a444b94518825698e7259f6) 

    
![效果](https://github.com/ChavezChen/CWLateralSlide/blob/master/示例图.gif)

## How To Use：
**使用cocoapods或者手动拖入.**
```objective-c
platform :ios, '7.0'

target 'TargetName' do
pod 'CWLateralSlide', '~> 1.6.3'
end
```
**搜索不到最新版本的解决方法：**
```
1、执行rm ~/Library/Caches/CocoaPods/search_index.json 删除索引的缓存再搜索，如果这样也搜索不到的话更新cocoapods
2、执行 pod repo update --verbose 更新成功之后就没问题了
```
### 1、显示抽屉：
导入分类：#import "UIViewController+CWLateralSlide.h" 
```objective-c
// 调用这个方法，Using this method
[self cw_showDefaultDrawerViewController:vc];
// 或者这样～Or it
// [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];
```
vc为你需要侧滑出来的控制器，调用这个方法你就拥有一个抽屉效果+左划/点击返回功能。

### 2、注册滑动手势驱动抽屉
```objective-c
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    // 第一个参数为是否开启边缘手势，开启则默认从边缘50距离内有效，第二个block为手势过程中我们希望做的操作
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        //NSLog(@"direction = %ld", direction);
        if (direction == CWDrawerTransitionDirectionLeft) { // 左侧滑出
            [weakSelf leftClick];
        } else if (direction == CWDrawerTransitionDirectionRight) { // 右侧滑出
            [weakSelf rightClick];
        }
    }];
```
做完第二步，我们在界面上往右滑动的时候，左侧的抽屉会跟着出现

### 3、自定义抽屉效果：
```objective-c
- (void)rightClick {
    
    RightViewController *vc = [[RightViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:CWDrawerTransitionDirectionRight backImage:[UIImage imageNamed:@"back.jpg"]];
    
    [self cw_showDrawerViewController:vc animationType:0 configuration:conf];
}
```
这样你就有了如示例图里面带有一定缩放的侧滑功能

### 4、抽屉内Push、Present操作
```objective-c
    NextViewController *vc = [NextViewController new];
    //  在侧滑的控制器内(没有导航控制器)，调用这个方法进行push操作就可以了
    [self cw_pushViewController:vc];
    // present & dismiss
    [self cw_presentViewController:vc];
    [self cw_dismissViewController];
```
### 5、主动关闭抽屉
```objective-c
// 注意：动画要设置为YES
[self dismissViewControllerAnimated:YES completion:nil];
```
因为我们实现的本质就是调用系统的present方法，所以关闭抽屉我们只需要调用系统的dismiss方法即可，**注意：动画要设置为YES**。
### 6、多手势冲突自定义处理接口
直接在调用cw_showDrawer...方法的控制器里实现下面的函数，进行自己的手势处理方法
```objective-c
#pragma mark - 自定义处理手势冲突接口
- (BOOL)cw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;// 可以在这里实现自己需要处理的手势冲突逻辑
}
```
### 7、打开抽屉情况下的布局
![效果](https://github.com/ChavezChen/CWLateralSlide/blob/master/layoutImage/allLayout.png)

## update：
```
1.6.4
优化边缘手势
1.6.3
修改cw_present 以及 cw_dismiss接口。
1.6.2
添加多手势冲突自定义处理接口。
1.6.1
修改iOS8手势打开界面的时候闪动的问题。
1.5.9
修改在特定场景下收起抽屉会多次dismiss的bug。
1.5.8
重新调整控制器直接为tableviewController时手势冲突问题，如果主界面类似QQ聊天列表需要侧滑显示抽屉同时需要左划显示删除等按钮可以翻看文末。
1.5.7
修改控制器直接为tableviewController时手势冲突问题
1.5.6
修改当navigation为根控制器时push动画闪动问题。
1.5.5
在抽屉界面进行Push与Present的自定义接口，增加隐藏抽屉动画时间的参数，可制定性更高
1.5.3
新增在侧滑出来的界面present另一个界面的方法。。。或者也可以使用demo内提供的直接present的方法。
1.5.2
新增手势驱动完成临界点参数，新增显示抽屉与隐藏抽屉动画时间参数。
1.5.1
增加一个默认抽屉效果的API,只需要一个VC参数
1.5.0
优化抽屉界面push动画效果
1.4.2
修改与cell侧滑删除冲突的问题。修改iphoneX会跳动的问题。修改缩放界面时界面失帧的问题
1.4.0
注册手势API更新，智能识别手势方向（感谢idozhuoyong童鞋的优化建议）
```

**主界面类似QQ聊天列表需要侧滑显示抽屉同时需要左划显示删除等按钮手势的处理方式：**

实现自定义处理手势冲突接口、修改成如下，并在注册手势的时候将是否开启**边缘手势设置为YES**；即可解决手势冲突的问题。
```
#pragma mark - 自定义处理手势冲突接口
-(BOOL)cw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 如果是自己创建tableview添加在VC的view上 这样写就足够了
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    // 如果是一个整体的tableViewController 需要下成下面这样
//    if ([[self viewController:otherGestureRecognizer.view] isKindOfClass:[UITableViewController class]] || //[otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
//        return YES;
//    }
    return NO;
}
```
**关于iOS11 设置scale界面缩放时导航栏出现20像素高黑条或者浅白条的问题可以看看下面这个issue**

[issues24](https://github.com/ChavezChen/CWLateralSlide/issues/24) 

还有不是很了解的可以下载demo看一下。有任何问题欢迎大家向我提issue或者加我联系方式，我会积极响应大家的问题。。

**QQ\微信:543438338**

最后希望大家给个star支持一下，感谢。  
#### 广而告之：欢聚时代YY直播团队招聘iOS开发，位置广州番禺南村万博万达广场，有兴趣的可以将简历发送至 chenwang@yy.com 或者加我微信/QQ联系我，其他任意岗位也可以联系我内推哦，让我赚点外快吧😂
