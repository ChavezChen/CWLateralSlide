# CWLateralSlide
优势:没有所谓的leftVC，rightVC，对整个项目没有任何限制和依赖，不需要设置啥XXXTabbarController这种根控制器，也没有任何需要继承自某某类～真正的0耦合。。使用极致简单，真正的大白话操作。。侧滑的控制器拥有完整的生命周期函数调用。也就是说，侧滑的界面在隐藏的情况下，并不会对app产生额外的内存占用（正确的被释放）。
    实现的一些细节方面可以看一下我的文章
[真！一行代码集成0耦合QQ侧滑功能](http://www.jianshu.com/p/6b83846d461c) 

    
![效果](https://github.com/ChavezChen/CWLateralSlide/blob/master/GIF1.gif)

使用方法：
首先导入我们的分类：#import "UIViewController+CWLateralSlide.h" 里面仅有3个函数.
   
   1、如果想实现一下示例图中左侧点击侧滑的功能，只需要1行代码：
```
// 调用这个方法
[self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];
```
vc为你需要侧滑出来的控制器，调用这个方法你就拥有了侧滑功能+左划返回功能，其实这样就已经有了一个很好的侧滑功能了，如果需要更多的一些功能，可以往下看

2、如果需要实现手势显示侧边控制器的功能，我们需要注册一个手势，使用也非常简单，代码如下
```
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    // 第一个参数为是否开启边缘手势，开启则默认从边缘50距离内有效，第二个参数为控制器从哪个方向滑出，第三个block为手势过程中我们希望做的操作
    [self cw_registerShowIntractiveWithEdgeGesture:YES direction:CWDrawerTransitionDirectionLeft transitionBlock:^{
    // leftClick里面其实就是左边按钮的点击事件，里面也只有下面的两行代码，为了更明确的知会大家需要做什么，所以把这两行代码写到这里来了
//        [weakSelf leftClick];
        LeftViewController *vc = [[LeftViewController alloc] init];
        [weakSelf cw_presentViewController:vc configuration:nil];
    }];
```
做完第二步，我们在界面上往右滑动的时候，左侧的控制器会跟着出现

3、如果想要实现如示例图上面右侧按钮的点击这种自定义的效果，我们只需要在第一步的时候多加一行代码，就是给方法传入一个configuration。代码如下：
```
- (void)rightClick {
    
    RightViewController *vc = [[RightViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:CWDrawerTransitionDirectionRight backImage:[UIImage imageNamed:@"back.jpg"]];
    
    [self cw_showDrawerViewController:vc animationType:0 configuration:conf];
}
```
这样你就有了如示例图里面带有一定缩放的侧滑功能

4、由于我们实现的本质是系统的present，侧滑出来的控制器不带有导航控制器，但是我们又需要进行push操作，该怎么办呢？这个我们也又封装一个方法，代码如下;
```
    NextViewController *vc = [NextViewController new];
    //  在侧滑的控制器内(没有导航控制器)，调用这个方法进行push操作就可以了
    [self cw_pushViewController:vc];
```
还有疑问的可以下载demo看一下。。基本一看就会。。

目前也支持cocoapods，只需要： pod 'CWLateralSlide', '~> 1.0.3' 目前是1.0.3版本，因为是新上传的，如果搜索不到，可以更新一下cocoapods或者清除一下repo的缓存再
重新搜索。。
最后希望大家给个star支持一下，感谢。

