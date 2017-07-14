//
//  ViewController.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/27.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "ViewController.h"

#import "LeftViewController.h"

#import "RightViewController.h"

#import "UIViewController+CWLateralSlide.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%@",self);
    
    [self setupNavBarItem];
    
    [self setupTableView];
    
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:YES direction:CWDrawerTransitionDirectionLeft transitionBlock:^{
//        [weakSelf leftClick];
        LeftViewController *vc = [[LeftViewController alloc] init];
        [weakSelf cw_presentViewController:vc configuration:nil];
    }];
    
}

- (void)setupNavBarItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightClick)];
}


- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

// 导航栏左边按钮的点击事件
- (void)leftClick {
    // 自己随心所欲创建的一个控制器
    LeftViewController *vc = [[LeftViewController alloc] init];
    // 调用这个方法
    [self cw_presentViewController:vc configuration:nil];

}

- (void)rightClick {
    RightViewController *vc = [[RightViewController alloc] init];
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:CWDrawerTransitionDirectionRight backImage:[UIImage imageNamed:@"back.jpg"]];
    [self cw_presentViewController:vc configuration:conf];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"----------%zd",indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:@"header.jpg"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self leftClick];
}

@end
