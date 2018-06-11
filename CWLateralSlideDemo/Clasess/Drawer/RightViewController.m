//
//  RightViewController.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "RightViewController.h"
#import "NextViewController.h"
#import "CWTableViewInfo.h"
#import "UIViewController+CWLateralSlide.h"

@interface RightViewController ()

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation RightViewController
{
    CWTableViewInfo *_tableViewInfo;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    _tableViewInfo = [[CWTableViewInfo alloc] initWithFrame:CGRectMake(0, 300, kCWSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    _tableViewInfo.backGroudColor = [UIColor clearColor];
    _tableViewInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = self.titleArray[i];
        NSString *imageName = self.imageArray[i];
        SEL sel = @selector(push);
        CWTableViewCellInfo *cellInfo = [CWTableViewCellInfo cellInfoWithTitle:title imageName:imageName target:self sel:sel];
        cellInfo.accessoryType = UITableViewCellAccessoryNone;
        cellInfo.backGroudColor = [UIColor clearColor];
        [_tableViewInfo addCell:cellInfo];
    }
    
    [self.view addSubview:[_tableViewInfo getTableView]];
    [[_tableViewInfo getTableView] reloadData];
}

#pragma mark - cell点击事件
- (void)push {
    NextViewController *vc = [NextViewController new];
    [self cw_pushViewController:vc];
}

#pragma mark - Getter方法
- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",
                        @"personal_myservice_icons",
                        @"personal_news_icons",
                        @"personal_order_icons",
                        @"personal_preview_icons",
                        @"personal_service_icons"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"了解会员特权",
                        @"钱包",
                        @"个性装扮",
                        @"我的收藏",
                        @"我的相册",
                        @"我的文件"];
    }
    return _titleArray;
}

@end
