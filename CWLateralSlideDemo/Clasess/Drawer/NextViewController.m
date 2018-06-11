//
//  NextViewController.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/27.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "NextViewController.h"
#import "CWTableViewInfo.h"
#import "UIViewController+CWLateralSlide.h"

@interface NextViewController ()

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation NextViewController
{
    CWTableViewInfo *_tableViewInfo;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"😄😄😄";
    [self setupTableView];
}

- (void)setupTableView {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _tableViewInfo = [[CWTableViewInfo alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = self.titleArray[i];
        NSString *imageName = self.imageArray[i];
        SEL sel = @selector(didSelectCell:indexPath:);
        CWTableViewCellInfo *cellInfo = [CWTableViewCellInfo cellInfoWithTitle:title imageName:imageName target:self sel:sel];
        [_tableViewInfo addCell:cellInfo];
    }
    
    [self.view addSubview:[_tableViewInfo getTableView]];
    [[_tableViewInfo getTableView] reloadData];
    
    [self setupHeader];
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"2.jpg"];
    [imageV sizeToFit];
    [_tableViewInfo getTableView].tableHeaderView = imageV;
}

#pragma mark - cell点击事件
- (void)didSelectCell:(CWTableViewCellInfo *)cellInfo indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        NextViewController *vc = [NextViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        _titleArray = @[@"dimiss界面",
                        @"push界面",
                        @"呵呵呵呵",
                        @"嘿嘿嘿嘿",
                        @"哈哈哈哈",
                        @"嘻嘻嘻嘻"];
    }
    return _titleArray;
}

@end
