# CWLateralSlide

目前有一些侧滑框架适用场景的局限性很高，且固定死的模板，比如设置一个leftVC，rightVC，middleVC为TabbarVC（根控制器），如果我要使用这种方式来实现侧滑，就必须根据它的要求来调整我们整个APP的架构，侵入型很高，新项目还好，老项目只能说，o shit！😁。假如界面要换交互方式，由于耦合高，替换成本是比较大的，而且侧滑的抽屉界面会一直存在内存里，展示在我们看不见的地方（屏幕外，或者根控制器下边）。

我们的优势:没有所谓的leftVC，rightVC，对整个项目没有任何限制和依赖，不需要设置啥XXXTabbarController这种根控制器，也没有任何需要继承自某某类～真正的**0耦合、0侵入、0污染**。使用极致简单，真正的大白话操作。。侧滑的控制器拥有完整的生命周期函数调用。也就是说，侧滑的界面在隐藏的情况下，并不会对app产生额外的内存占用（正确的被释放）**最重要的是简单：只要一行代码就能拥有一个侧滑抽屉**。
## update：
```
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
实现的一些细节方面可以看一下我的文章
[需要侧滑抽屉效果？一行代码足以](https://juejin.im/post/5a444b94518825698e7259f6) 

    
![效果](https://github.com/ChavezChen/CWLateralSlide/blob/master/示例图.gif)

## How To Use：
**支持iOS7以上。支持cocoapods.**
目前是1.5.7版本，**强烈建议使用最新版本,最近不断的在进行优化**：
```objective-c
platform :ios, '7.0'

target 'TargetName' do
pod 'CWLateralSlide', '~> 1.5.7'
end
```
**因为是新上传的，如果搜索不到最新版本，可以更新一下cocoapods或者清除一下repo的缓存再 重新搜索。。搜索不到的解决方法(适用于任何框架不能搜索到最新版本的情况)：**
```
1、执行rm ~/Library/Caches/CocoaPods/search_index.json 删除索引的缓存再搜索，如果这样也搜索不到的话更新cocoapods
2、执行 pod repo update --verbose 更新成功之后就没问题了
```
### 1、如果想实现一下示例图中左侧点击侧滑的功能，只需要1行代码。If you want to achieve the effects of the left click on the drawer slide in gif，Need only one line of code：
首先导入我们的分类：#import "UIViewController+CWLateralSlide.h" 里面仅有3个函数.
```objective-c
// 调用这个方法，Using this method
[self cw_showDefaultDrawerViewController:vc];
// 或者这样～Or it
// [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];
```
vc为你需要侧滑出来的控制器，调用这个方法你就拥有了侧滑功能+左划返回功能，其实这样就已经有了一个很好的侧滑功能了，如果需要更多的一些功能，可以往下看

### 2、如果需要实现手势显示侧边控制器的功能，我们需要注册一个手势，使用也非常简单，代码如下
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
做完第二步，我们在界面上往右滑动的时候，左侧的控制器会跟着出现

### 3、如果想要实现如示例图上面右侧按钮的点击这种自定义的效果，我们只需要在第一步的时候多加一行代码，就是给方法传入一个configuration。代码如下：
```objective-c
- (void)rightClick {
    
    RightViewController *vc = [[RightViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:CWDrawerTransitionDirectionRight backImage:[UIImage imageNamed:@"back.jpg"]];
    
    [self cw_showDrawerViewController:vc animationType:0 configuration:conf];
}
```
这样你就有了如示例图里面带有一定缩放的侧滑功能

### 4、侧滑出来的控制器不带有导航控制器，但是我们又需要进行push操作，该怎么办呢？这个我们也又封装一个方法，代码如下;
```objective-c
    NextViewController *vc = [NextViewController new];
    //  在侧滑的控制器内(没有导航控制器)，调用这个方法进行push操作就可以了
    [self cw_pushViewController:vc];
```
### 5、主动关闭抽屉的方法
```objective-c
[self dismissViewControllerAnimated:YES completion:nil];
```
因为我们实现的本质就是调用系统的present方法，所以关闭抽屉我们只需要调用系统的dismiss方法即可，**注意：动画要设置为YES**。

### 6、打开抽屉情况下的布局
![效果](https://github.com/ChavezChen/CWLateralSlide/blob/master/layoutImage/allLayout.png)

还有不是很了解的可以下载demo看一下。有任何问题欢迎大家向我提issue，我会积极响应大家的问题。。

最后希望大家给个star支持一下，感谢。
