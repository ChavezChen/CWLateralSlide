//
//  ViewController.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/27.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "CWScrollView.h"
#import "CWTableViewInfo.h"
#import "UIViewController+CWLateralSlide.h"

@interface MainViewController ()

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *selArray;
@property (nonatomic,strong) NSMutableArray *tableViewInfonArray;

@property (nonatomic,weak) CWScrollView * contentScrollView;
@property (nonatomic,strong) LeftViewController *leftVC; // 强引用，可以避免每次显示抽屉都去创建
@end

@implementation MainViewController

- (LeftViewController *)leftVC {
    if (_leftVC == nil) {
        _leftVC = [LeftViewController new];
    }
    return _leftVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:YES transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            [weakSelf defaultAnimationFromLeft];
        } else if (direction == CWDrawerTransitionFromRight) { // 右侧滑出
            [weakSelf scaleYAnimationFromRight];
        }
    }];
}


#pragma mark - UI相关

- (void)setupUI {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupNavBarItem];
    [self setupScrollView]; // 多个tableview
    //    [self setupTableView];
}

- (void)setupNavBarItem {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(defaultAnimationFromLeft)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(scaleYAnimationFromRight)];
}


- (void)setupTableView {
    
    CWTableViewInfo *tableViewInfo = [[CWTableViewInfo alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = self.titleArray[i];
        SEL sel = NSSelectorFromString(self.selArray[i]);
        CWTableViewCellInfo *cellInfo = [CWTableViewCellInfo cellInfoWithTitle:title imageName:nil target:self sel:sel];
        [tableViewInfo addCell:cellInfo];
    }
    
    [self.view addSubview:[tableViewInfo getTableView]];
    [[tableViewInfo getTableView] reloadData];
    [self.tableViewInfonArray addObject:tableViewInfo];
}

- (void)setupScrollView {
    
    CGFloat navigationHeight = self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabbarHeight = self.tabBarController.tabBar.bounds.size.height;
    
    CWScrollView * contentScrollView = [[CWScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - navigationHeight - tabbarHeight)];
    _contentScrollView = contentScrollView;
    [self.view addSubview:contentScrollView];
    
    for (int index = 0; index < 3; index++) {
        
        CWTableViewInfo *tableViewInfo = [[CWTableViewInfo alloc] initWithFrame:CGRectMake(CGRectGetWidth(_contentScrollView.bounds) * index, 0, CGRectGetWidth(_contentScrollView.bounds), CGRectGetHeight(_contentScrollView.bounds)) style:UITableViewStylePlain];
        
        for (int i = 0; i < self.titleArray.count; i++) {
            NSString *title = self.titleArray[i];
            SEL sel = NSSelectorFromString(self.selArray[i]) ;
            CWTableViewCellInfo *cellInfo = [CWTableViewCellInfo cellInfoWithTitle:title imageName:nil target:self sel:sel];
            [tableViewInfo addCell:cellInfo];
        }
        
        [[tableViewInfo getTableView] reloadData];
//        [tableViewInfo getTableView].scrollEnabled = NO;
        [_contentScrollView addSubview:[tableViewInfo getTableView]];
        [self.tableViewInfonArray addObject:tableViewInfo]; // 强引用
    }
    
}

#pragma mark - Getter方法
- (NSMutableArray *)tableViewInfonArray {
    if (_tableViewInfonArray == nil) {
        _tableViewInfonArray = [NSMutableArray array];
    }
    return _tableViewInfonArray;
}

- (NSArray *)titleArray {
    return @[@"仿QQ左侧划出",
             @"仿QQ右侧划出",
             @"缩小从左侧划出",
             @"缩小从右侧划出",
             @"遮盖在上面从左侧划出",
             @"遮盖在上面从右侧划出"];
}

- (NSArray *)selArray {
    return @[NSStringFromSelector(@selector(defaultAnimationFromLeft)),
             NSStringFromSelector(@selector(defaultAnimationFromRight)),
             NSStringFromSelector(@selector(scaleYAnimationFromLeft)),
             NSStringFromSelector(@selector(scaleYAnimationFromRight)),
             NSStringFromSelector(@selector(maskAnimationFromLeft)),
             NSStringFromSelector(@selector(maskAnimationFromRight))];
}

#pragma mark - cell的点击事件
// 仿QQ从左侧划出
- (void)defaultAnimationFromLeft {
    
    // 强引用leftVC，不用每次创建新的,也可以每次在这里创建leftVC，抽屉收起的时候会释放掉
    [self cw_showDefaultDrawerViewController:self.leftVC];
    // 或者这样调用
//    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];
}

// 仿QQ从右侧划出
- (void)defaultAnimationFromRight{
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration defaultConfiguration];
    conf.direction = CWDrawerTransitionFromRight; // 从右边滑出
    conf.finishPercent = 0.2f;
    conf.showAnimDuration = 0.2;
    conf.HiddenAnimDuration = 0.2;
    conf.maskAlpha = 0.1;
    
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:conf];
}

// 缩小从左侧划出
- (void)scaleYAnimationFromLeft {
    
    RightViewController *vc = [[RightViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:CWDrawerTransitionFromLeft backImage:[UIImage imageNamed:@"0.jpg"]];
    
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:conf];
}

// 缩小从右侧划出
- (void)scaleYAnimationFromRight {
    
    RightViewController *vc = [[RightViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration defaultConfiguration];
    conf.direction = CWDrawerTransitionFromRight; // 从右边滑出
    conf.finishPercent = 0.1f;
    conf.showAnimDuration = 1.0;
//    conf.HiddenAnimDuration = 1.0;
//    conf.maskAlpha = 0.1;
    conf.backImage = [UIImage imageNamed:@"0.jpg"];
    conf.scaleY = 0.8;
    
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:conf];
    
}

// 遮盖在上从左侧划出
- (void)maskAnimationFromLeft{
    
    LeftViewController *vc = [[LeftViewController alloc] init];

    // 调用这个方法
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
}

// 遮盖在上从右侧划出
- (void)maskAnimationFromRight{
    
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration defaultConfiguration];
    conf.direction = CWDrawerTransitionFromRight;
    conf.showAnimDuration = 1.0f;
    
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:conf];
}

#pragma mark - 自定义处理手势冲突接口
#if 0
- (BOOL)cw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;// 可以在这里实现自己需要处理的手势冲突逻辑
}
#endif

@end

