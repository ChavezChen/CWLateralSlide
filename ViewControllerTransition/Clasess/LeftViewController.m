//
//  LeftViewController.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "LeftViewController.h"

#import "UIViewController+CWLateralSlide.h"

#import "NextTableViewCell.h"

#import "NextViewController.h"
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation LeftViewController



- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",@"personal_myservice_icons",@"personal_news_icons",@"personal_order_icons",@"personal_preview_icons",@"personal_service_icons"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        if (_drawerType == DrawerDefaultRight || _drawerType == DrawerTypeMaskRight) {
            _titleArray = @[@"Push下一个界面",@"Push下一个界面",@"Push下一个界面",@"Push下一个界面",@"Push下一个界面",@"主动收起抽屉"];
        }else {
            _titleArray = @[@"present下一个界面",@"Push下一个界面",@"Push下一个界面",@"Push下一个界面",@"Push下一个界面",@"主动收起抽屉"];
        }
    }
    return _titleArray;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupHeader];
    
    [self setupTableView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    
    switch (_drawerType) {
        case DrawerDefaultLeft:
            [self.view.superview sendSubviewToBack:self.view];
            break;
        case DrawerTypeMaskLeft:
            rect.size.width = CGRectGetWidth(self.view.frame) * 0.75;
            break;
        default:
            break;
    }
    
    self.view.frame = rect;
}




- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, kCWSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    //    tableView.backgroundColor = [UIColor clearColor];
    _tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"NextTableViewCell" bundle:nil] forCellReuseIdentifier:@"NextCell"];
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, 300)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageV];
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NextCell"];
    cell.imageName = self.imageArray[indexPath.row];
    cell.title = self.titleArray[indexPath.row];
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.titleArray.count - 1) { // 点击最后一个主动收起抽屉
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NextViewController *vc = [NextViewController new];
    if (indexPath.row == 0 && _drawerType != DrawerDefaultRight && _drawerType != DrawerTypeMaskRight) {
        [self presentViewController:vc animated:YES completion:nil];
//        [self presentViewController:[TestViewController new] animated:YES completion:nil];

    }else {
        [self cw_pushViewController:vc];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}



@end
